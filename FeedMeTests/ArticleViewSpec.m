//
//  ArticleViewSpec.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 AFCodeTest. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "FMArticleViewController.h"

@interface FMArticleViewController (Spec)
@property (nonatomic, strong) FMArticle *article;

@property (nonatomic, weak) IBOutlet UILabel *articleTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *articleImageView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

SPEC_BEGIN(FullArticle)

describe(@"Article View", ^{
	__block FMArticleViewController *articleVC;
	__block FMArticle *fakeArticle;
	
	context(@"when initializing with Article", ^{
		
		beforeAll(^{
			fakeArticle = [[FMArticle alloc] initWithTitle:@"TestTitle" summary:@"TestSummary" htmlSummary:@"HTMLTest" link:@"TestLink" andImage:[UIImage imageNamed:@"placeholder"]];
			articleVC = [[FMArticleViewController alloc] initWithArticle:fakeArticle];
		});
		
		it(@"should exist", ^{
			[[articleVC shouldNot] beNil];
		});
		
		it(@"should use correct Article", ^{
			[[articleVC.article should] equal:fakeArticle];
		});
	});
});

SPEC_END
