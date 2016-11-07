//
//  Genre.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "Genre.h"

static NSString *const kGenreNameKey = @"display_name";
static NSString *const kGenreEncodedNameKey = @"list_name_encoded";

@implementation Genre

- (nonnull instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]){
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary[kGenreNameKey] isKindOfClass:[NSString class]]) {
        self.name = dictionary[kGenreNameKey];
    }
    if ([dictionary[kGenreEncodedNameKey] isKindOfClass:[NSString class]]) {
        self.encodedName = dictionary[kGenreEncodedNameKey];
    }
}

@end
