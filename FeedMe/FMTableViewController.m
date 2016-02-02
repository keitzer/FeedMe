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
	NSLog(@"Parsing started.");
}

// Provides info about the feed
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	
}

// Provides info about a feed item
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	
}

// Parsing complete or stopped at any time by `stopParsing`
- (void)feedParserDidFinish:(MWFeedParser *)parser {
	[self stopParsingFeed];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error // Parsing failed
{
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
