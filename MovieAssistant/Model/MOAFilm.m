//
//  ASFilm.m
//  MovieApp
//
//  Created by Soroka Andrii on 18/08/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import "MOAFilm.h"

@interface NSDateFormatter (ASFormatter)

+ (NSDateFormatter *)sharedFormatter;

@end

@implementation NSDateFormatter (ASFormatter)

// For avoiding creating NSDateFormatter every time
+ (NSDateFormatter *)sharedFormatter {
  static NSDateFormatter *_dateFormatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
  });
  return _dateFormatter;
}

@end

@interface MOAFilm ()

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *posterPath;
@property(strong, nonatomic) NSNumber *rating;
@property(strong, nonatomic) NSDate *releaseDate;
@property(strong, nonatomic) MOAGenres *genres;
//@property (strong, nonatomic) NSNumber* youtubeId;

@end

@implementation MOAFilm

+ (MOAFilm *)initWithDictionary:(NSDictionary *)dictionary {
  MOAFilm *film = [[MOAFilm alloc] init];
  film.genres = [MOAGenres genreWithNumberArray:dictionary[@"genre_ids"]];
  film.title = dictionary[@"title"];
  film.rating = dictionary[@"vote_average"];
  film.youtubeId = dictionary[@"id"];
    
    NSString *currentDateString = dictionary[@"release_date"];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy-MM-DD"];
    NSDate *currentDate =
    [dateFormater dateFromString:currentDateString];
    
    [dateFormater setDateFormat:@"yyyy"];
    NSString *convertedDateString =
    [dateFormater stringFromDate:currentDate];
    film.releaseDateString = convertedDateString;
    
    
    film.movieDescription = dictionary[@"overview"];

    
//  NSString *dateString = dictionary[@"release_date"];
//  film.releaseDate =
//      [[NSDateFormatter sharedFormatter] dateFromString:dateString];

  NSString *posterPath = dictionary[@"poster_path"];
  NSString *posterURLstring = [[NSString
      stringWithFormat:@"https://image.tmdb.org/t/p/original%@", posterPath]
      stringByReplacingOccurrencesOfString:@" "
                                withString:@"%20"];
  film.posterPath = posterURLstring;


  return film;
}


@end
