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

@interface FMTableViewController (Spec)
@property (nonatomic, strong) NSMutableArray *articleArray;
@end


SPEC_BEGIN(FMTableViewSpec)

describe(@"Table View", ^{
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	__block FMTableViewController *tableController;
 
	beforeAll(^{
		tableController = [storyboard instantiateViewControllerWithIdentifier:@"TableViewVC"];
		
		[tableController view];
	});
	
	context(@"after view loads", ^{
		it(@"array should be initialized", ^{
			[[tableController.articleArray shouldNot] beNil];
		});
	});
	
});

SPEC_END