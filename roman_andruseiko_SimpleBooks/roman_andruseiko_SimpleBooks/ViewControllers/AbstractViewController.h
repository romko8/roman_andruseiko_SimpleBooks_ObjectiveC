//
//  AbstractViewController.h
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/1/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractViewController : UIViewController

- (void)showErrorMessage;
- (void)showAlertWithMessage:(NSString *)message;

@end
