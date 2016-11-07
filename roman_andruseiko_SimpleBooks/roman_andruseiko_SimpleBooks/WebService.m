//
//  WebService.m
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import "WebService.h"
#import "DataModels.h"

static NSString *const kBooksAPIKey = @"0e795c8f9956400aaaeee0ad6f1a56c8";
static NSString *const kBooksAPIServerURL = @"https://api.nytimes.com/svc/books/v3/";

@implementation WebService

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[[self class] alloc] init];
    });
    
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)makeGetRequest:(NSString *)path withCompletion:(void(^)(NSDictionary *response))completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSLog(@"response - %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               if (error == nil) {
                                   NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
                                       completion(dictionary);
                                   } else {
                                       completion(nil);
                                   }
                               } else {
                                   completion(nil);
                               }
                           }];
}

- (void)getGenres:(void(^)(NSMutableArray *genres))completion {
    [self makeGetRequest:[NSString stringWithFormat:@"%@lists/names.json?api-key=%@", kBooksAPIServerURL, kBooksAPIKey] withCompletion:^(NSDictionary *response) {
        if (response && response[@"results"]) {
            NSArray *results = response[@"results"];
            NSMutableArray *genres = [NSMutableArray new];
            for (NSDictionary *genreDictionary in results) {
                Genre *genre = [[Genre alloc] initWithDictionary:genreDictionary];
                [genres addObject:genre];
            }
            completion(genres);
        } else {
            completion(nil);
        }
    }];
}

- (void)getBestsellersForGenre:(NSString *)genre withCompletion:(void(^)(NSMutableArray *bestsellers))completion {
    [self makeGetRequest:[NSString stringWithFormat:@"%@lists.json?api-key=%@&list=%@", kBooksAPIServerURL, kBooksAPIKey, genre] withCompletion:^(NSDictionary *response) {
        if (response && response[@"results"]) {
            NSArray *results = response[@"results"];
            NSMutableArray *bestsellers = [NSMutableArray new];
            for (NSDictionary *bestsellerDictionary in results) {
                Bestseller *bestseller = [[Bestseller alloc] initWithDictionary:bestsellerDictionary];
                [bestsellers addObject:bestseller];
            }
            completion(bestsellers);
        } else {
            completion(nil);
        }
    }];
}

- (NSString *)getCoverImagePath:(NSString *)isbn {
    if (isbn.length > 0) {
        return [NSString stringWithFormat:@"http://images.amazon.com/images/P/%@.01.20TRZZZZ.jpg", isbn];
    }
    return @"";
}

@end
