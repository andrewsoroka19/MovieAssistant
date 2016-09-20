//
//  ASTrailer.m
//  MovieApp
//
//  Created by Soroka Andrii on 8/18/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import "MOATrailer.h"

@implementation MOATrailer

+ (MOATrailer *)initWithDictionary:(NSDictionary *)dictionary {
  MOATrailer *trailer = [[MOATrailer alloc] init];


  NSString *youtubekey = dictionary[@"key"];
  NSString *trailerURLLink = [NSString
      stringWithFormat:@"https://www.youtube.com/watch?v=%@", youtubekey];

  trailer.youtubekey = trailerURLLink;
  trailer.youtubeID = youtubekey;

  return trailer;
}

@end
