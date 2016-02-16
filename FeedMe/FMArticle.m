//
//  FMArticle.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 Ogorek. All rights reserved.
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

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.articleHTMLSummary forKey:@"HTMLSummary"];
	NSData *pngRep = UIImagePNGRepresentation(self.articleImage);
	NSData *myEncodedImageData = [NSKeyedArchiver archivedDataWithRootObject:pngRep];
	[coder encodeObject:myEncodedImageData forKey:@"Image"];
	[coder encodeObject:self.articleSummary forKey:@"Summary"];
	[coder encodeObject:self.articleTitle forKey:@"Title"];
	[coder encodeObject:self.articleLink forKey:@"Link"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	
	if (self) {
		
		self.articleTitle = [coder decodeObjectForKey:@"Title"];
		self.articleSummary = [coder decodeObjectForKey:@"Summary"];
		NSData *myEncodedImageData = [coder decodeObjectForKey:@"Image"];
		NSData *pngRep = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedImageData];
		self.articleImage = [UIImage imageWithData:pngRep];
		self.articleHTMLSummary = [coder decodeObjectForKey:@"HTMLSummary"];
		self.articleLink = [coder decodeObjectForKey:@"Link"];
	}
	return self;
}

@end
