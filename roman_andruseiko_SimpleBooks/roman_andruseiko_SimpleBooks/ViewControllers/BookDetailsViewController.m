//
//  BookDetailsViewController.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/6/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "BookDetailsViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "UIImageView+ImageDownloading.h"
#import "WebService.h"
#import "roman_andruseiko_SimpleBooks-Swift.h"

@interface BookDetailsViewController (){
    FBSDKShareButton *_facebookShareButton;
}
@property (weak, nonatomic) IBOutlet UIButton *amazonButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@end

@implementation BookDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayData];
}

- (void)displayData {
    if  (!_bestseller) {
        return;
    }
    if (_bestseller.imageData) {
        _imageView.image = [UIImage imageWithData:_bestseller.imageData];
    } else {
        [_imageView setImageDownloadedFrom:[[WebService sharedInstance] getCoverImagePath:_bestseller.isbnCode]];
    }
    _nameLabel.text = _bestseller.name;
    _authorLabel.text = _bestseller.authorName;
    
    _rankLabel.text = _bestseller.rank > 0 ? [NSString stringWithFormat:@"Rank: %li", _bestseller.rank] : @"";
    
    if (_bestseller.amazonURL && _bestseller.amazonURL.length > 0) {
        [_amazonButton setTitle:_bestseller.amazonURL forState:UIControlStateNormal];
        _amazonButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

        FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
        content.contentTitle = @"SimpleBooks";
        content.contentURL = [NSURL URLWithString:_bestseller.amazonURL];
        _facebookShareButton = [FBSDKShareButton new];
        _facebookShareButton.shareContent = content;
        _facebookShareButton.center = self.view.center;
        [self.view addSubview:_facebookShareButton];
        _facebookShareButton.hidden = YES;
    } else {
        _amazonButton.hidden = YES;
        _shareButton.hidden = YES;
    }
    
    [self setLikeButtonText];
}

- (void)setLikeButtonText {
    Book *book = [[CoreDataManager sharedInstance] getBookWithCodeWithIsbnCode:_bestseller.isbnCode];
    if (book) {
        [_likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
    } else {
        [_likeButton setTitle:@"Like" forState:UIControlStateNormal];
    }
}

#pragma mark - Buttons methods
- (IBAction)amazonButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_bestseller.amazonURL]];
}

- (IBAction)shareButtonPressed {
    [_facebookShareButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)likeButtonPressed {
    Book *book = [[CoreDataManager sharedInstance] getBookWithCodeWithIsbnCode:_bestseller.isbnCode];
    if (book) {
        [[CoreDataManager sharedInstance] removeBookWithCodeWithIsbnCode:_bestseller.isbnCode];
    } else {
        NSData *imageData;
        if (_imageView.image) {
            imageData = UIImagePNGRepresentation(_imageView.image);
        }
        [[CoreDataManager sharedInstance] createBookWithName:_bestseller.name author:_bestseller.authorName amazonURL:_bestseller.amazonURL rank:[NSString stringWithFormat:@"%li", _bestseller.rank] isbnCode:_bestseller.isbnCode image:imageData];
    }
    [self setLikeButtonText];
}

@end
