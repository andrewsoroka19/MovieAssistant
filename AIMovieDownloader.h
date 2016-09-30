//  AIMovieDownloader.h
//  MovieAssistantFinal
//  Created by Andrii & Ihor on 9/17/16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import <Foundation/Foundation.h>

@class AIMovieParser, UIImageView;

@interface AIMovieDownloader : NSObject

@property (strong, nonatomic) NSString *selectedCategory;

- (void)searchMovies:(int)locker : (void(^)(NSArray<AIMovieParser*>*))handler;

+ (void)imageView:(UIImageView *)imageView testLoadImageWithPath:(NSString *)path;

@end