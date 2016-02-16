//
//  FMArticle.h
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 Ogorek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMArticle : NSObject

@property (nonatomic, strong) UIImage *articleImage;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleSummary;
@property (nonatomic, strong) NSString *articleHTMLSummary;
@property (nonatomic, strong) NSString *articleLink;

-(id)initWithTitle:(NSString*)titleText summary:(NSString*)summaryText htmlSummary:(NSString*)htmlSummary link:(NSString*)link andImage:(UIImage*)image;

@end
