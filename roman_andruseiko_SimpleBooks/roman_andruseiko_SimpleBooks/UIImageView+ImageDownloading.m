//
//  UIImageView+ImageDownloading.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/6/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "UIImageView+ImageDownloading.h"

@implementation UIImageView (ImageDownloading)

- (void)setImageDownloadedFrom:(NSString *)url {
    self.image = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}

@end
