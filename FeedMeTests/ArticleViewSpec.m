//
//  ArticleViewSpec.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 Ogorek. All rights reserved.
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
	
	context(@"after view did load", ^{
		beforeEach(^{
			[articleVC view];
		});
		
		it(@"should use the same image", ^{
			[[articleVC.articleImageView.image should] equal:fakeArticle.articleImage];
		});
		
		it(@"should use the same title", ^{
			[[articleVC.articleTitleLabel.text should] equal:fakeArticle.articleTitle];
		});
		
		it(@"should begin to load the web view", ^{
			[[articleVC shouldEventually] receive:@selector(webViewDidStartLoad:)];
		});
	});
});

SPEC_END
