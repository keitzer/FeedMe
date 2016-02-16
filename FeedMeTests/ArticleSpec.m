//
//  ArticleSpec.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 Ogorek. All rights reserved.
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
	
	context(@"when archiving and unarchiving", ^{
		
		__block NSData *archivedData;
		beforeEach(^{
			archivedData = [NSKeyedArchiver archivedDataWithRootObject:article];
		});
		
		it(@"should retain the same information", ^{
			FMArticle *newArticle = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
			
			[[article.articleTitle should] equal:newArticle.articleTitle];
			[[article.articleHTMLSummary should] equal:newArticle.articleHTMLSummary];
			[[article.articleLink should] equal:newArticle.articleLink];
			[[article.articleSummary should] equal:newArticle.articleSummary];
			NSData *img1 = UIImagePNGRepresentation(article.articleImage);
			NSData *img2 = UIImagePNGRepresentation(newArticle.articleImage);
			//[[img1 should] equal:img2];
		});
		
	});
	
});

SPEC_END
