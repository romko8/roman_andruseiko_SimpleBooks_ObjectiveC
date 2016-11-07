//
//  NSString+Addons.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/7/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "NSString+Addons.h"

@implementation NSString (Addons)

+ (NSString *)randomStringWithLength:(NSInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    return randomString;
}

@end
