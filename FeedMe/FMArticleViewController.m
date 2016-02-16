//
//  FMArticleViewController.m
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 Ogorek. All rights reserved.
//

#import "FMArticleViewController.h"
#import <SVProgressHUD.h>

@interface FMArticleViewController () <UIWebViewDelegate>
@property (nonatomic, strong) FMArticle *article;

@property (nonatomic, weak) IBOutlet UILabel *articleTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *articleImageView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

//a boolean to know when to stop showing the Loading indicator
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

-(void)viewDidLoad {
	[super viewDidLoad];
	
	self.articleTitleLabel.text = self.article.articleTitle;
	self.articleImageView.image = self.article.articleImage ? self.article.articleImage : [UIImage imageNamed:@"placeholder"];
	self.articleImageView.layer.cornerRadius = 8;
	self.articleImageView.layer.masksToBounds = YES;
	
	self.navigationItem.title = self.article.articleTitle;
	
	[self startLoadingWebContent];
}

-(void)startLoadingWebContent {
	
	//attach the webView's delegate to self to receieve the callbacks
	self.webView.delegate = self;
	
	//if there's a URL link attached to the Article, try to load that
	if (self.article.articleLink) {
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.article.articleLink]]];
	}
	//otherwise, simply show the HTML summary that was connected to the RSS feed item
	else {
		[self.webView loadHTMLString:self.article.articleHTMLSummary baseURL:nil];
	}
	
	self.finishedWithInitialLoading = NO;
}

#pragma mark - Web View delegate methods

-(void)webViewDidStartLoad:(UIWebView *)webView {
	
	//if it hasn't already completed one cycle of loading, show the "Loading..." indicator
	if (!self.finishedWithInitialLoading) {
		[SVProgressHUD showWithStatus:@"Loading..."];
	}
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
	
	//once finished, dismiss the indicator
	self.finishedWithInitialLoading = YES;
	[SVProgressHUD dismiss];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	//if an error occured BEFORE the first loading cycle, hide the web view to reveal "Issue loading"
	if (!self.finishedWithInitialLoading) {
		[SVProgressHUD dismiss];
		
		NSLog(@"error: %@", error.description);
		self.webView.hidden = YES;
	}
	
	[self.webView stopLoading];
}

@end
