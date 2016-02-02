//
//  FMArticleViewController.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 AFCodeTest. All rights reserved.
//

#import "FMArticleViewController.h"
#import <SVProgressHUD.h>

@interface FMArticleViewController () <UIWebViewDelegate>
@property (nonatomic, strong) FMArticle *article;

@property (nonatomic, weak) IBOutlet UILabel *articleTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *articleImageView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, assign) BOOL finishedWithInitialLoading;

@end


@implementation FMArticleViewController

-(id)initWithArticle:(FMArticle *)article {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self = [storyboard instantiateViewControllerWithIdentifier:@"FullArticleVC"];
	
	if (self) {
		self.article = article;
	}
	return self;
}

@end
