//
//  LoginViewController.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 10/31/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "roman_andruseiko_SimpleBooks-Swift.h"

static NSString *const kTabBarControllerSegueKey = @"tabBarControllerSegue";

@interface LoginViewController ()

@end

@implementation LoginViewController


#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    [self checkForExistingUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillDisappear:animated];
}

#pragma mark - private methods
- (void)buildUI {
    FBSDKLoginButton *loginButton = [FBSDKLoginButton new];
    [self.view addSubview:loginButton];
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.5f constant:0.f]];

    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    loginButton.delegate = self;
}

- (void)checkForExistingUser {
    if ([[CoreDataManager sharedInstance] isUserLoggedIn]) {
        [self makeLogIn];
    }
}

- (void)makeLogIn {
    [self performSegueWithIdentifier:kTabBarControllerSegueKey sender:nil];
}

#pragma mark - FBSDKLoginButton Delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error == nil) {
        NSString *facebookToken = [[result token] tokenString];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (error == nil) {
                NSDictionary *userDetails = result;
                NSString *userId = userDetails[@"id"];
                NSString *userName = userDetails[@"name"];
                [[CoreDataManager sharedInstance] createUserWithId:userId name:userName token:facebookToken];
                [self makeLogIn];
            } else {
                [self showErrorMessage];
            }

        }];
    } else {
        [self showErrorMessage];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"loginButtonDidLogOut");
}


@end
