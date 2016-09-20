//
//  ASGenres.m
//  MovieApp
//
//  Created by Soroka Andrii on 8/18/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import "MOAGenres.h"

typedef NS_ENUM(NSInteger, GenreType) {
  GenreUnknown = 0,
  GenreAction = 28,
  GenreAdventure = 12,
  GenreAnimation = 16,
  GenreComedy = 35,
  GenreCrime = 80,
  GenreDocumentary = 99,
  GenreDrama = 18,
  GenreFamily = 10751,
  GenreFantasy = 14,
  GenreForeign = 10769,
  GenreHistory = 36,
  GenreMusic = 10402,
  GenreMystery = 9648,
  GenreRomance = 10749,
  GenreScienceFiction = 878,
  GenreTVMovie = 10770,
  GenreThriller = 53,
  GenreWar = 10752,
  GenreWestern = 37
};

@interface MOAGenres ()

@end

@implementation MOAGenres

+ (MOAGenres *)genreWithNumberArray:(NSArray<NSNumber *> *)array {
  MOAGenres *ganres = [[MOAGenres alloc] init];
  if (!array || array.count == 0) {
    // TODO: Handle error
    ganres.namesArray = @[];
    return ganres;
  }

  NSMutableArray *resultsArray = [NSMutableArray array];
  for (NSNumber *genreID in array) {
    NSInteger integerValue = [genreID integerValue];
    NSString *name = [MOAGenres nameFromType:(GenreType)integerValue];
    if (![name isEqualToString:@"Unknown"]) {
      [resultsArray addObject:name];
    }
  }
  ganres.namesArray = [resultsArray copy];
  return ganres;
}

- (NSString *)labelText {
  NSString *text = @"";
  for (NSString *name in self.namesArray) {
    if ([text isEqualToString:@""]) {
      text = name; // First time
    } else {
      text = [NSString stringWithFormat:@"%@, %@", text, name];
    }
  }
  return text;
}

+ (NSString *)nameFromType:(GenreType)type {
  switch (type) {
  case GenreAction:
    return @"Action";
  case GenreAdventure:
    return @"Adventure";
  case GenreAnimation:
    return @"Animation";
  case GenreComedy:
    return @"Comedy";
  case GenreCrime:
    return @"Crime";
  case GenreDocumentary:
    return @"Documentary";
  case GenreDrama:
    return @"Drama";
  case GenreFamily:
    return @"Family";
  case GenreFantasy:
    return @"Fantasy";
  case GenreForeign:
    return @"Foreign";
  case GenreHistory:
    return @"History";
  case GenreMusic:
    return @"Music";
  case GenreMystery:
    return @"Mystery";
  case GenreRomance:
    return @"Romance";
  case GenreScienceFiction:
    return @"Science Fiction";
  case GenreTVMovie:
    return @"TV Movie";
  case GenreThriller:
    return @"Thriller";
  case GenreWar:
    return @"War";
  case GenreWestern:
    return @"Western";
  default:
    return @"Unknown";
  }
}

@end
