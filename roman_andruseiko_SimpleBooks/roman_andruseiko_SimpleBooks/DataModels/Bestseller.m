//
//  Bestseller.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "Bestseller.h"
#import "NSString+Addons.h"
#import "roman_andruseiko_SimpleBooks-Swift.h"

static NSString *const kBookDetailsKey = @"book_details";
static NSString *const kAuthorKey = @"author";
static NSString *const kTitleKey = @"title";
static NSString *const kIsbnsKey = @"isbns";
static NSString *const kIsbn10Key = @"isbn10";
static NSString *const kAmazonURLKey = @"amazon_product_url";
static NSString *const kRankKey = @"rank";

@implementation Bestseller


- (nonnull instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]){
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (id)initWithBook:(Book *)book {
    if (self = [super init]){
        self.name = book.name;
        self.authorName = book.author;
        self.rank = [book.rank integerValue];
        self.isbnCode = book.isbnCode;
        self.amazonURL = book.amazonURL;
        self.imageData = book.image;
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        if (dictionary[kBookDetailsKey]) {
            NSArray *bookDetailsArray = dictionary[kBookDetailsKey];
            if (bookDetailsArray.count > 0) {
                NSDictionary *bookDetails = bookDetailsArray.firstObject;
                if (bookDetails[kAuthorKey]) {
                    self.authorName = bookDetails[kAuthorKey];
                }
                if (bookDetails[kTitleKey]) {
                    self.name = bookDetails[kTitleKey];
                }
            }
        }
        
        if (dictionary[kRankKey]) {
            self.rank = [dictionary[kRankKey] integerValue];
        } else {
            self.rank = 0;
        }

        if (dictionary[kIsbnsKey]) {
            NSArray *isbns = dictionary[kIsbnsKey];
            if (isbns.count > 0) {
                NSDictionary *codeDictionary = isbns.firstObject;
                if (codeDictionary[kIsbn10Key]) {
                    self.isbnCode = codeDictionary[kIsbn10Key];
                } else {
                    self.isbnCode = [NSString randomStringWithLength:10];
                }
                
            } else {
                self.isbnCode = [NSString randomStringWithLength:10];
            }
        }
        
        if (dictionary[kAmazonURLKey]) {
            self.amazonURL = dictionary[kAmazonURLKey];
        }
    }
}

@end
