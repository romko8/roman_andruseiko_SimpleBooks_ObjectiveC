//
//  BestsellerCustomCell.h
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BestsellerCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end
