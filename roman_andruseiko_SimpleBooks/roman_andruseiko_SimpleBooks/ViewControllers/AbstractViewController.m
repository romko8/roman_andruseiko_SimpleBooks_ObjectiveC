//
//  AbstractViewController.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/1/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showErrorMessage {
    [self showAlertWithMessage:@"Something went wrong. Please try again."];
}

@end
