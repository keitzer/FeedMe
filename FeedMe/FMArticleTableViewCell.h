//
//  FMArticleTableViewCell.h
//  FeedMe
//
//  Created by Alex Ogorek on 2/1/16.
//  Copyright © 2016 Ogorek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMArticleTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *articleTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *articleSummaryLabel;
@property (nonatomic, weak) IBOutlet UIImageView *articleImageView;

@end
