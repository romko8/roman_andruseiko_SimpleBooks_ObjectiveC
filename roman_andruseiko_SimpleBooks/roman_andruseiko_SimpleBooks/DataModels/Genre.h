//
//  Genre.h
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Genre : NSObject

@property(nonatomic, strong, nullable) NSString *name;
@property(nonatomic, strong, nullable) NSString *encodedName;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
