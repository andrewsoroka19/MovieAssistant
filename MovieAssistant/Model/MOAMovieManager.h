//  MOAMovieManager.h
//  MovieAssistantFinal
//  Created by team on 22.08.16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import <Foundation/Foundation.h>

@interface MOAMovieManager : NSObject

@property(strong, nonatomic) NSString *movieDescription;
@property(strong, nonatomic) NSString *moviePoster;
@property(strong, nonatomic) NSString *movieYouTubeID;
@property(strong, nonatomic) NSString *movieName;
@property(strong, nonatomic) NSString *movieYear;
@property(strong, nonatomic) NSString *movieGenres;
@property(strong, nonatomic) NSString *movieRating;

+ (MOAMovieManager *)newMoviewWithName:(NSString *)name
                               andYear:(NSString *)year
                             andGenres:(NSString *)genres
                             andRating:(NSString *)rating
                        andDescription:(NSString *)description
                             andPoster:(NSString *)poster
                            andTrailer:(NSString *)trailer;

@end