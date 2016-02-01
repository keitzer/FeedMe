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

@interface FMTableViewController ()

@property (nonatomic, strong) NSMutableArray *articleArray;

@end

@implementation FMTableViewController


-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.articleArray = [NSMutableArray array];
}

#pragma mark - Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	
	if (self.articleArray.count == 0) {
		UITableViewCell *noArticleCell = [tableView dequeueReusableCellWithIdentifier:@"NO_ARTICLE" forIndexPath:indexPath];
		return noArticleCell;
	}
	else {
		FMArticleTableViewCell *articleCell = [tableView dequeueReusableCellWithIdentifier:@"ARTICLE" forIndexPath:indexPath];
		return articleCell;
	}
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.articleArray.count == 0) {
		return 1;
	}
	
	return self.articleArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.articleArray.count == 0) {
		return [UIScreen mainScreen].bounds.size.height - 60;
	}
	else {
		return 80;
	}
}

@end
