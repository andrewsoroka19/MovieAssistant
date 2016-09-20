//
//  ASGenres.m
//  MovieApp
//
//  Created by Soroka Andrii on 8/18/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOAGenres : NSObject

@property(strong, nonatomic) NSString *labelText;

+ (MOAGenres *)genreWithNumberArray:(NSArray<NSNumber *> *)array;

@property(strong, nonatomic) NSArray *namesArray;

@end
