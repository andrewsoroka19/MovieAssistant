//
//  ASFilm.h
//  MovieApp
//
//  Created by Soroka Andrii on 18/08/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import "MOAGenres.h"
#import <Foundation/Foundation.h>

@interface MOAFilm : NSObject

@property(strong, nonatomic, readonly) NSString *title;
@property(strong, nonatomic, readonly) NSString *posterPath;
@property(strong, nonatomic, readonly) NSNumber *rating;
@property(strong, nonatomic, readonly) NSDate *releaseDate;
@property(strong, nonatomic) NSNumber *youtubeId;
@property(strong, nonatomic) NSString *youtubekey;
@property(strong, nonatomic, readonly) MOAGenres *genres;
@property(strong, nonatomic) NSString *releaseDateString;
@property(strong, nonatomic) NSString *movieDescription;


+ (MOAFilm *)initWithDictionary:(NSDictionary *)dictionary;

//+ (OverViewManager *)trailerkey:(NSString *)key
//                    andOverView:(NSString *)overview ;
@end
