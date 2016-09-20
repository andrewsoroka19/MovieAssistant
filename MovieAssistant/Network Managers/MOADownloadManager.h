//
//  DownloadManager.h
//  MovieApp
//
//  Created by Soroka Andrii on 8/4/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import "MOAFilm.h"
#import "MOATrailer.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MOADownloadManager : NSObject

+ (void)fetchMovieWithTitle:(NSString *)movieTitle
          completionHandler:(void (^)(MOAFilm *))handler;
+ (void)fetchYoutubeTrailer:(NSString *)youtubeId
          completionHandler:(void (^)(MOATrailer *))handler;
+ (void)autocompleteMovieTitle:(NSString *)movieTitle
             completionHandler:(void (^)(NSArray *))handler;
+ (void)fetchMovieWithTitleFromSearchTable:(NSString *)movieTitle
                          searchTableIndex:(NSInteger)index
                         completionHandler:(void (^)(MOAFilm *))handler;
+ (void)imageView:(UIImageView *)imageView loadImageWithPath:(NSString *)path;
+ (void)fetchAllMoviesWithCompletionUpComing:(void(^)(NSArray<MOAFilm *> *))handler;
+ (void)fetchAllMoviesWithCompletionMostPopular:(void(^)(NSArray<MOAFilm *> *))handler;

+ (void)fetchAllMoviesWithCompletionTopRated:(void(^)(NSArray<MOAFilm *> *))handler;


@end
