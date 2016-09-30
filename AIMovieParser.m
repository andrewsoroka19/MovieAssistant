//  AIMovieParser.m
//  MovieAssistantFinal
//  Created by Andrii & Ihor on 9/17/16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import "AIMovieParser.h"

@implementation AIMovieParser

+ (AIMovieParser*) parseMovie:(NSDictionary*) dictionary {
    
    AIMovieParser *parsedMovie = [[AIMovieParser alloc] init];
    
    parsedMovie.movieOriginalTitle = dictionary[@"original_title"];
    parsedMovie.movieCurrentTitle = dictionary[@"title"];
    parsedMovie.movieOriginalLanguage = dictionary[@"original_language"];
    parsedMovie.movieOverview= dictionary[@"overview"];
    parsedMovie.moviePosterPath = [[NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", dictionary[@"poster_path"]]stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    parsedMovie.movieBackdropPath = [[NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", dictionary[@"backdrop_path"]]stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    parsedMovie.movieReleaseDate = dictionary[@"release_date"];
    parsedMovie.movieID = dictionary[@"id"];
    parsedMovie.movieVoteCount = dictionary[@"vote_count"];
    parsedMovie.movieVoteAverage = dictionary[@"vote_average"];
    parsedMovie.moviePopularity = dictionary[@"popularity"];
    parsedMovie.movieGenres = dictionary[@"genre_ids"];

    return parsedMovie;
}

+ (AIMovieParser*) takeParsedElementsxOriginalTitle:(NSString*) originalTitle
                                    andCurrentTitle:(NSString*) currentTitle
                                andOriginalLanguage:(NSString*) originalLanguage
                                        andOverview:(NSString*) overview
                                      andPosterPath:(NSString*) posterPath
                                    andBackdropPath:(NSString*) backdropPath
                                     andReleaseDate:(NSDate*) releaseDate
                                              andID:(NSNumber*) iD
                                       andVoteCount:(NSNumber*) voteCount
                                     andVoteAverage:(NSNumber*) voteAverage
                                      andPopularity:(NSNumber*) popularity
                                          andGenres:(NSNumber*) genres {
    
    AIMovieParser *takedMovie = [[AIMovieParser alloc]init];
    
    takedMovie.movieOriginalTitle = originalTitle;
    takedMovie.movieCurrentTitle = currentTitle;
    takedMovie.movieOriginalLanguage = originalLanguage;
    takedMovie.movieOverview = overview;
    takedMovie.moviePosterPath = posterPath;
    takedMovie.movieBackdropPath = backdropPath;
    takedMovie.movieReleaseDate = releaseDate;
    takedMovie.movieID = iD;
    takedMovie.movieVoteCount = voteCount;
    takedMovie.movieVoteAverage = voteAverage;
    takedMovie.moviePopularity = popularity;
    takedMovie.movieGenres = genres;
    
    return takedMovie;
}

@end