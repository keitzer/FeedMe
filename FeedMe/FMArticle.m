//
//  FMArticle.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 AFCodeTest. All rights reserved.
//

#import "FMArticle.h"

@implementation FMArticle

-(id)initWithTitle:(NSString *)titleText summary:(NSString *)summaryText htmlSummary:(NSString *)htmlSummary link:(NSString*)link andImage:(UIImage *)image {
	
	self = [super init];
	
	if (self) {
		self.articleSummary = summaryText;
		self.articleImage = image;
		self.articleTitle = titleText;
		self.articleHTMLSummary = htmlSummary;
		self.articleLink = link;
	}
	return self;
}

@end
