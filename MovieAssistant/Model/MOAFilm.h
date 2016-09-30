//
//  ASFilm.h
//  MovieApp
//
//  Created by Soroka Andrii on 18/08/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import "MOAGenres.h"
#import <Foundation/Foundation.h>
#import "MOATrailer.h"

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
@property(strong, nonatomic) MOATrailer *trailerID;


+ (MOAFilm *)initWithDictionary:(NSDictionary *)dictionary;

@end
