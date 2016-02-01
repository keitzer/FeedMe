//
//  ArticleSpec.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 AFCodeTest. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "FMArticle.h"

SPEC_BEGIN(Article)

describe(@"Article", ^{
	__block FMArticle *article;
	__block UIImage *image;
	
	beforeEach(^{
		image = [UIImage imageNamed:@"placeholder"];
		article = [[FMArticle alloc] initWithTitle:@"TestTitle" summary:@"TestSummary" htmlSummary:@"TestHTMLSummary" link:@"TestLink" andImage:image];
	});
	
	afterEach(^{
		article = nil;
	});
	
	context(@"after initialization", ^{
		it(@"should exist", ^{
			[[article shouldNot] beNil];
		});
		
		it(@"should contain all elements", ^{
			[[article.articleTitle should] equal:@"TestTitle"];
			[[article.articleHTMLSummary should] equal:@"TestHTMLSummary"];
			[[article.articleLink should] equal:@"TestLink"];
			[[article.articleSummary should] equal:@"TestSummary"];
			[[article.articleImage should] equal:image];
		});
	});
	
	
});

SPEC_END
