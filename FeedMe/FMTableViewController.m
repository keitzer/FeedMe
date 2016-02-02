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

@interface FMTableViewController ()

//array to store all the articles
@property (nonatomic, strong) NSMutableArray *articleArray;

@end

@implementation FMTableViewController


-(void)viewDidLoad {
	[super viewDidLoad];
	
	//initialize the array
	self.articleArray = [NSMutableArray array];
	
	[self loadInitialArticles];
}

-(void)loadInitialArticles {
	
	//if there aren't any articles saved, simply disable scrolling.
	if (self.articleArray.count == 0) {
		self.tableView.scrollEnabled = NO;
	}
}

#pragma mark - Parsing methods

-(IBAction)refreshPressed {
	//show a loading dialog while the refresh happens
	[SVProgressHUD showWithStatus:@"Loading Articles"];
	
	//if after 5 seconds it isn't already finished, automatically end it as it's probably a network issue.
	[self performSelector:@selector(stopParsingFeed) withObject:nil afterDelay:5];
}

-(void)stopParsingFeed {
	[SVProgressHUD dismiss];
	
	//if there are any articles saved OR receieved from the parser, simply enable scrolling.
	if (self.articleArray.count > 0) {
		self.tableView.scrollEnabled = YES;
	}
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
