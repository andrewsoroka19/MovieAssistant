//  MOAMovieManager.m
//  MovieAssistantFinal
//  Created by team on 22.08.16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import "MOAMovieManager.h"

@implementation MOAMovieManager

+ (MOAMovieManager *)newMoviewWithName:(NSString *)name
                               andYear:(NSString *)year
                             andGenres:(NSString *)genres
                             andRating:(NSString *)rating
                        andDescription:(NSString *)description
                             andPoster:(NSString *)poster
                            andTrailer:(NSString *)trailer {
    
  MOAMovieManager *newMovie = [MOAMovieManager new];

  newMovie.movieName = name;
  newMovie.movieYear = year;
  newMovie.movieGenres = genres;
  newMovie.movieRating = rating;
  newMovie.movieDescription = description;
  newMovie.moviePoster = poster;
  newMovie.movieYouTubeID = trailer;

  return newMovie;
}

@end