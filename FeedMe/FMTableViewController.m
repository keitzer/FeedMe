//
//  FMTableViewController.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 AFCodeTest. All rights reserved.
//

#import "FMTableViewController.h"
#import "FMArticleTableViewCell.h"
#import "FMArticle.h"
#import "FMArticleViewController.h"
#import <SVProgressHUD.h>
#import <MWFeedParser.h>
#import "NSString+HTML.h"

@interface FMTableViewController () <MWFeedParserDelegate>

//array to store all the articles
@property (nonatomic, strong) NSMutableArray *articleArray;
@property (nonatomic, strong) MWFeedParser *feedParser;

@end

@implementation FMTableViewController


-(void)viewDidLoad {
	[super viewDidLoad];
	
	//initialize the array
	self.articleArray = [NSMutableArray array];
	
	[self loadSavedArticles];
	
	[self initializeFeedParser];
}

#pragma mark - Helper methods

-(void)loadSavedArticles {
	
	NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ArticleArray"];
	if (data) {
		self.articleArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
	}
	
	//if there aren't any articles saved, simply disable scrolling.
	if (self.articleArray.count == 0) {
		self.tableView.scrollEnabled = NO;
	}
}

-(void)initializeFeedParser {
	// Create feed parser and pass the URL of the feed
	NSURL *feedURL = [NSURL URLWithString:@"https://news.google.com/news?cf=all&hl=en&pz=1&ned=us&output=rss"];
	self.feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	
	// Delegate must conform to `MWFeedParserDelegate`
	self.feedParser.delegate = self;
	
	// Parse the feeds info (title, link) and all feed items
	self.feedParser.feedParseType = ParseTypeItemsOnly;
	
	// Connection type
	self.feedParser.connectionType = ConnectionTypeAsynchronously;
}

//use local data persistence for storing the Articles' information
-(void)saveArticleArray {
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.articleArray] forKey:@"ArticleArray"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

//not a perfectly fool-proof way, but it works for a vast majority of the articles
-(BOOL)articleTitleExistsInArray:(NSString*)articleTitle {
	for (FMArticle *article in self.articleArray) {
		if ([article.articleTitle isEqualToString:articleTitle]) {
			return YES;
		}
	}
	
	//if it's not found, return NO
	return NO;
}

#pragma mark - Parsing methods

-(IBAction)refreshPressed {
	//show a loading dialog while the refresh happens
	[SVProgressHUD showWithStatus:@"Loading Articles"];
	
	//begin parsing feed
	[self.feedParser parse];
	
	//if after 5 seconds it isn't already finished, automatically end it as it's probably a network issue.
	[self performSelector:@selector(stopParsingFeed) withObject:nil afterDelay:5];
}

-(void)stopParsingFeed {
	[SVProgressHUD dismiss];
	
	[self.feedParser stopParsing];
	
	//if there are any articles saved OR receieved from the parser, simply enable scrolling.
	if (self.articleArray.count > 0) {
		self.tableView.scrollEnabled = YES;
	}
}

#pragma mark - Feed Parser Delegate

// Called when data has downloaded and parsing has begun
- (void)feedParserDidStart:(MWFeedParser *)parser {
}

// Provides info about a feed item
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	
	//only add the item to the list if it isn't already there.
	if (![self articleTitleExistsInArray:item.title]) {
		NSString *summary = [item.summary stringByConvertingHTMLToPlainText];
		
		FMArticle *newArticle = [[FMArticle alloc] initWithTitle:item.title summary:summary htmlSummary:item.summary link:item.link andImage:nil];
		
		//put the newly-parsed article at the top of the list
		[self.articleArray insertObject:newArticle atIndex:0];
		
		//try to get the image associated with the article
		[self obtainImageForArticle:newArticle withItem:item];
		
		//update the display with the newly-inserted article
		[self.tableView reloadData];
	}
}

// Scan through the feed information for an image, and try to download such image.

//NOTE: This method also makes the assumption that the "src=" exists, and an image will be found.
//A lofty assumption indeed.
//However, in the case that an image cannot be found (or loaded), the placeholder image appears in the table view.
//Just something to know (that it's not very modular beyond this app)
-(void)obtainImageForArticle:(FMArticle*)article withItem:(MWFeedItem*)item {
	
	NSString *htmlData = item.summary;
	NSScanner* newScanner = [NSScanner scannerWithString:htmlData];
	NSString *imageURL;
	while (![newScanner isAtEnd]) {
		[newScanner scanUpToString:@"src=""" intoString:NULL];
		[newScanner scanUpToString:@""" alt=" intoString:&imageURL];
	}
	
	//add the proper http:// so it can access the image properly
	imageURL = [NSString stringWithFormat:@"%@%@", @"http://", [imageURL substringFromIndex:7]];
	imageURL = [imageURL substringToIndex:imageURL.length-1];
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageURL]];
		if ( data == nil ) {
			return;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			UIImage *image = [UIImage imageWithData:data];
			
			article.articleImage = image;
			
			[self.tableView reloadData];
			
			[self saveArticleArray];
		});
	});
}

// Parsing complete or stopped at any time by `stopParsing`
- (void)feedParserDidFinish:(MWFeedParser *)parser {
	[self stopParsingFeed];
}

// Parsing failed
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	[self stopParsingFeed];
	NSLog(@"Failed to parse. %@", error.description);
}

#pragma mark - Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	
	//return the "attractive" cell if there are no articles currently stored
	if (self.articleArray.count == 0) {
		UITableViewCell *noArticleCell = [tableView dequeueReusableCellWithIdentifier:@"NO_ARTICLE" forIndexPath:indexPath];
		noArticleCell.selectionStyle = UITableViewCellSelectionStyleNone;
		return noArticleCell;
	}
	
	//otherwise, return the Article cell
	else {
		FMArticleTableViewCell *articleCell = [tableView dequeueReusableCellWithIdentifier:@"ARTICLE" forIndexPath:indexPath];
		
		//make the image corners rounded
		articleCell.articleImageView.layer.cornerRadius = 8;
		articleCell.articleImageView.layer.masksToBounds = YES;
		
		FMArticle *article = self.articleArray[row];
		articleCell.articleTitleLabel.text = article.articleTitle;
		articleCell.articleSummaryLabel.text = article.articleSummary;
		articleCell.articleImageView.image = article.articleImage ? article.articleImage : [UIImage imageNamed:@"placeholder"];
		
		return articleCell;
	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//if no articles, return the "refresh" cell
	if (self.articleArray.count == 0) {
		return 1;
	}
	
	//otherwise, return the number of articles
	return self.articleArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//to ensure we're actually using an Article.
	if (self.articleArray.count > 0) {
		
		//grab the article from the array
		FMArticle *article = self.articleArray[indexPath.row];
		
		//initialize the VC with the article, and push it onto the stack
		FMArticleViewController *articleVC = [[FMArticleViewController alloc] initWithArticle:article];
		[self.navigationController pushViewController:articleVC animated:YES];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// height minus 60 because that's relatively how tall the cell would be minus the nav bar.
	if (self.articleArray.count == 0) {
		return [UIScreen mainScreen].bounds.size.height - 60;
	}
	else {
		return 80;
	}
}

@end
