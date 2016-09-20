//
//  ASTrailer.h
//  MovieApp
//
//  Created by Soroka Andrii on 8/18/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOATrailer : NSObject

@property(strong, nonatomic) NSString *youtubekey;
@property(strong, nonatomic) NSString *youtubeID;

+ (MOATrailer *)initWithDictionary:(NSDictionary *)dictionary;

@end
