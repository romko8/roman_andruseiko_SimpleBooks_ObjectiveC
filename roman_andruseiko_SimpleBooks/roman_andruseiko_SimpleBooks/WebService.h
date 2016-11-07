//
//  WebService.h
//  roman_andruseiko_SimpleBooks
//
//  Created by Roman Andruseiko on 11/4/16.
//  Copyright © 2016 SimpleBooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+ (instancetype)sharedInstance;
- (void)getGenres:(void(^)(NSMutableArray *genres))completion;
- (void)getBestsellersForGenre:(NSString *)genre withCompletion:(void(^)(NSMutableArray *bestsellers))completion;
- (NSString *)getCoverImagePath:(NSString *)isbn;

@end
