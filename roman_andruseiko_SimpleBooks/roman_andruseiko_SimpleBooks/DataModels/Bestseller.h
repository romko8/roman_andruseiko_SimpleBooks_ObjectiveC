//
//  Bestseller.h
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;

@interface Bestseller : NSObject

@property(nonatomic, strong, nullable) NSString *name;
@property(nonatomic, strong, nullable) NSString *authorName;
@property(nonatomic, readwrite) NSInteger rank;
@property(nonatomic, strong, nullable) NSString *isbnCode;
@property(nonatomic, strong, nullable) NSString *amazonURL;
@property(nonatomic, strong, nullable) NSData *imageData;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;
- (nonnull instancetype)initWithBook:(nonnull Book *)book;

@end
