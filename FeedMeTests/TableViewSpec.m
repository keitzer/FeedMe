//
//  TableViewSpec.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 AFCodeTest. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "FMTableViewController.h"
#import "FMArticleTableViewCell.h"

@interface FMTableViewController (Spec)
@property (nonatomic, strong) NSMutableArray *articleArray;
@end


SPEC_BEGIN(FMTableViewSpec)

describe(@"Table View", ^{
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	__block FMTableViewController *tableController;
 
	beforeAll(^{
		//initialize the proper Table View from the storyboard
		tableController = [storyboard instantiateViewControllerWithIdentifier:@"TableViewVC"];
		
		//...and load the view
		[tableController view];
	});
	
	context(@"after view loads", ^{
		it(@"array should be initialized", ^{
			[[tableController.articleArray shouldNot] beNil];
		});
	});
	
	context(@"cell for row at index path", ^{
		
		context(@"if article exists", ^{
			
			beforeEach(^{
				//ensure at least 1 object exists within the array
				[tableController.articleArray insertObject:[NSObject new] atIndex:0];
				[tableController.tableView reloadData];
			});
			
			it(@"should return an Article cell", ^{
				[[[tableController tableView:tableController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should] beMemberOfClass:[FMArticleTableViewCell class]];
			});
		});
		
		
		it(@"should return the attractive table view cell if no articles exist", ^{
			//ensure no objects exist within the array
			[tableController.articleArray removeAllObjects];
			[tableController.tableView reloadData];
			
			[[[tableController tableView:tableController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should] beMemberOfClass:[UITableViewCell class]];
		});
	});
});

SPEC_END