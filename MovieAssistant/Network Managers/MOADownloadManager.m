//
//  DownloadManager.m
//  MovieApp
//
//  Created by Soroka Andrii on 8/4/16.
//  Copyright © 2016 Soroka Andrii. All rights reserved.
//

#import "MOADownloadManager.h"
#import "UIImageView+AFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "SHASearchDataHistory.h"

NSString *const baseURLString = @"http://api.themoviedb.org/3/search/movie";
NSString *const apiKey = @"5e1809003aa40c436c5632289269da65";
NSString *const upComing = @"http://api.themoviedb.org/3/movie/upcoming?";
NSString *const topRated = @"http://api.themoviedb.org/3/movie/top_rated?";
NSString *const mostPopular = @"http://api.themoviedb.org/3/movie/popular?";

@implementation MOADownloadManager

+ (void)fetchMovieWithTitle:(NSString *)movieTitle
          completionHandler:(void (^)(MOAFilm *))handler {

  if (!handler)
    return;

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];

  [manager GET:baseURLString
      parameters:@{
        @"query" : movieTitle,
        @"api_key" : apiKey
      }
      progress:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class]) {
          NSArray *results = responseObject[@"results"];
          NSDictionary *firstResult = [results firstObject];
          MOAFilm *film = [MOAFilm initWithDictionary:firstResult];
          handler(film);
        } else {
          // TODO: Handle response error!
          NSLog(@"Response Error");
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: Show Allert on error!
        NSLog(@"Error : %@", error.description);
      }];
}

+ (void)autocompleteMovieTitle:(NSString *)movieTitle
             completionHandler:(void (^)(NSArray *))handler {

  if (!handler)
    return;

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];

  [manager GET:baseURLString
      parameters:@{
        @"query" : movieTitle,
        @"api_key" : apiKey
      }
      progress:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class]) {
          NSArray *results = responseObject[@"results"];

            SHASearchDataHistory* testData = [SHASearchDataHistory new];
            [testData saveDataInSearchHistoryList:[results mutableCopy]];
            
          handler(results);
        } else {
          // TODO: Handle response error!
          NSLog(@"Response Error");
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: Show Allert on error!
        NSLog(@"Error : %@", error.description);
      }];
}

+ (void)fetchYoutubeTrailer:(NSString *)youtubeId
          completionHandler:(void (^)(MOATrailer *))handler {

  if (!handler)
    return;

  NSString *posterURLstring = [NSString
      stringWithFormat:@"http://api.themoviedb.org/3/movie/"
                       @"%@?api_key=5e1809003aa40c436c5632289269da65&append_"
                       @"to_response=videos",
                       youtubeId];
  NSURL *requestURL = [NSURL URLWithString:posterURLstring];

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];

  [manager GET:requestURL.absoluteString
      parameters:nil
      progress:^(NSProgress *downloadProgress) {
      }
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class]) {

          NSArray *arrayWithVideos =
              [[responseObject objectForKey:@"videos"] objectForKey:@"results"];
          NSDictionary *dictionaryFromArray = [arrayWithVideos firstObject];

          MOATrailer *trailer =
              [MOATrailer initWithDictionary:dictionaryFromArray];
          handler(trailer);
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: Show Allert on error!
        NSLog(@"Error : %@", error.description);
      }];
}

+ (void)fetchMovieWithTitleFromSearchTable:(NSString *)movieTitle
                          searchTableIndex:(NSInteger)index
                         completionHandler:(void (^)(MOAFilm *))handler {

  if (!handler)
    return;

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];

  [manager GET:baseURLString
      parameters:@{
        @"query" : movieTitle,
        @"api_key" : apiKey
      }
      progress:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class]) {
          NSArray *results = responseObject[@"results"];

            
            SHASearchDataHistory* testData = [SHASearchDataHistory new];
            [testData saveDataInSearchHistoryList:[results mutableCopy]];

          NSDictionary *firstResult = [results objectAtIndex:index];
          MOAFilm *film = [MOAFilm initWithDictionary:firstResult];
          handler(film);
        } else {
          // TODO: Handle response error!
          NSLog(@"Response Error");
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        // TODO: Show Allert on error!
        NSLog(@"Error : %@", error.description);
      }];
}

+ (void)imageView:(UIImageView *)imageView loadImageWithPath:(NSString *)path {
  NSURL *url = [NSURL URLWithString:path];
  if (url) {
    [imageView setImageWithURL:url];
  }
}

+ (void)fetchAllMoviesWithCompletionUpComing:(void(^)(NSArray<MOAFilm *> *))handler {
    
    if (!handler)
        return;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:upComing
      parameters: @{@"api_key" : apiKey}
        progress: nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject isKindOfClass:NSDictionary.class]) {
                 NSArray *results = responseObject[@"results"];
                 
                 NSMutableArray *films = [NSMutableArray array];
                 for (NSDictionary *firstResult in results) {
                     MOAFilm *film = [MOAFilm initWithDictionary:firstResult];
                     [films addObject:film];
                 }
                 
                 handler(films);
             } else {
                 // TODO: Handle response error!
                 NSLog(@"Response Error");
                 
                 handler(nil);
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // TODO: Show Allert on error!
             NSLog(@"Error : %@", error.description);
             handler(nil);
         }];
}

+ (void)fetchAllMoviesWithCompletionTopRated:(void(^)(NSArray<MOAFilm *> *))handler {
    
    if (!handler)
        return;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:topRated
      parameters: @{@"api_key" : apiKey}
        progress: nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject isKindOfClass:NSDictionary.class]) {
                 NSArray *results = responseObject[@"results"];
                 
                 NSMutableArray *films = [NSMutableArray array];
                 for (NSDictionary *firstResult in results) {
                     MOAFilm *film = [MOAFilm initWithDictionary:firstResult];
                     [films addObject:film];
                 }
                 
                 handler(films);
             } else {
                 // TODO: Handle response error!
                 NSLog(@"Response Error");
                 
                 handler(nil);
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // TODO: Show Allert on error!
             NSLog(@"Error : %@", error.description);
             handler(nil);
         }];
}


+ (void)fetchAllMoviesWithCompletionMostPopular:(void(^)(NSArray<MOAFilm *> *))handler {
    
    if (!handler)
        return;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:mostPopular
      parameters: @{@"api_key" : apiKey}
        progress: nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if ([responseObject isKindOfClass:NSDictionary.class]) {
                 NSArray *results = responseObject[@"results"];
                 
                 NSMutableArray *films = [NSMutableArray array];
                 for (NSDictionary *firstResult in results) {
                     MOAFilm *film = [MOAFilm initWithDictionary:firstResult];
                     [films addObject:film];
                 }
                 
                 handler(films);
             } else {
                 // TODO: Handle response error!
                 NSLog(@"Response Error");
                 
                 handler(nil);
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // TODO: Show Allert on error!
             NSLog(@"Error : %@", error.description);
             handler(nil);
         }];
}



@end
