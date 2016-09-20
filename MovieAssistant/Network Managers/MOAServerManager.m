//
//  YYServerManager.m
//  MoviesProjectMapKit
//
//  Created by Yura Yasinskyy on 12.08.16.
//  Copyright © 2016 yura.yasinskyy. All rights reserved.
//

#import "MOAConsts.h"
#import "MOAServerManager.h"
#import <AFNetworking.h>

@interface MOAServerManager ()

@property(strong, nonatomic) AFHTTPSessionManager *requestSharedManager;

@end

@implementation MOAServerManager

#pragma mark - Making singlton

+ (MOAServerManager *)sharedServerManager {
  static MOAServerManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [MOAServerManager new];
    // Any other initialisation stuff here
  });
  return manager;
}

#pragma mark - Methods

- (void)getPlaces:(CGFloat)lat
    andLongtitude:(CGFloat)lon
        onSuccess:(void (^)(NSArray *places))success
        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {

  NSString *URLstring =
      [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/"
                                 @"nearbysearch/"
                                 @"json?location=%f,%f&radius=20000&types="
                                 @"movie_theater&language=uk&key=%@",
                                 lat, lon, googleMapsAPIKey];

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:URLstring
      parameters:nil
      progress:nil
      success:^(NSURLSessionTask *task, id responseObject) {

        NSArray *placesArray = responseObject[@"results"];

        if (success) {
          success(placesArray);
        }

      }
      failure:^(NSURLSessionTask *operation, NSError *error) {

        // NSLog(@"Error: %@", error);

        if (failure) {
          failure(error, 0);
        }
      }];
}

- (void)getPlacePictureWithReference:(NSString *)reference
                         andMaxWidth:(NSInteger)width
                        andMaxHeigth:(NSInteger)height
                          getPicture:(void (^)(id picture))success
                           onFailure:(void (^)(NSError *error,
                                               NSInteger statusCode))failure {

  NSString *URLstring = [NSString
      stringWithFormat:@"https://maps.googleapis.com/maps/api/place/"
                       @"photo?maxwidth=%ld&maxheight=%ld&"
                       @"photoreference=%@&key=%@",
                       (long)width, (long)height, reference, googleMapsAPIKey];

  NSURLSessionConfiguration *configuration =
      [NSURLSessionConfiguration defaultSessionConfiguration];
  AFURLSessionManager *manager =
      [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
  manager.responseSerializer = [AFImageResponseSerializer serializer];

  NSURL *URL = [NSURL URLWithString:URLstring];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];

  NSURLSessionDataTask *dataTask =
      [manager dataTaskWithRequest:request
                 completionHandler:^(NSURLResponse *response, id responseObject,
                                     NSError *error) {
                   if (error) {
                     // NSLog(@"Error: %@", error);
                     failure(error, 0);
                   } else {
                     // NSLog(@"%@ %@", response, responseObject);
                     success(responseObject);
                   }
                 }];
  [dataTask resume];
}

- (void)getPlaceCoordinateByID:(NSString *)placeID
                getCoordinates:(void (^)(NSArray *placeCoordinatesByID))success
                     onFailure:(void (^)(NSError *error,
                                         NSInteger statusCode))failure {

  NSString *URLstring =
      [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/"
                                 @"details/json?placeid=%@&key=%@",
                                 placeID, googleMapsAPIKey];

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:URLstring
      parameters:nil
      progress:nil
      success:^(NSURLSessionTask *task, id responseObject) {

        NSDictionary *placesArray = [[[responseObject objectForKey:@"result"]
            objectForKey:@"geometry"] objectForKey:@"location"];

        NSMutableArray *coordinatesArray = [NSMutableArray array];
        [coordinatesArray addObject:placesArray[@"lat"]];
        [coordinatesArray addObject:placesArray[@"lng"]];
        [coordinatesArray addObject:[[responseObject objectForKey:@"result"]
                                        objectForKey:@"name"]];
        [coordinatesArray addObject:[[responseObject objectForKey:@"result"]
                                        objectForKey:@"formatted_address"]];

        if (success) {
          success([coordinatesArray copy]);
        }

      }
      failure:^(NSURLSessionTask *operation, NSError *error) {

        // NSLog(@"Error: %@", error);

        if (failure) {
          failure(error, 0);
        }
      }];
}

- (void)getDistanceBetweenLocations:(CGFloat)lat1
                      andLongtitude:(CGFloat)lon1
                          latitude2:(CGFloat)lat2
                        longtitude2:(CGFloat)lon2
                          onSuccess:(void (^)(NSString *distance))success
                          onFailure:(void (^)(NSError *error,
                                              NSInteger statusCode))failure {

  NSString *URLstring = [NSString
      stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/"
                       @"json?origin=%f,%f&destination=%f,%f&mode=driving&"
                       @"units=metric&language=uk&key=%@",
                       lat1, lon1, lat2, lon2, googleMapsAPIKey];

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:URLstring
      parameters:nil
      progress:nil
      success:^(NSURLSessionTask *task, id responseObject) {

        NSArray *arrayWithData = responseObject[@"routes"];
        NSArray *arrayWithDistance =
            [[arrayWithData firstObject] objectForKey:@"legs"];
        NSDictionary *dictionaryWithDistance =
            [[arrayWithDistance firstObject] objectForKey:@"distance"];
        NSDictionary *dictionaryWithDuration =
            [[arrayWithDistance firstObject] objectForKey:@"duration"];

        NSString *durationBetweenLocations = dictionaryWithDuration[@"text"];
        NSString *distanceBetweenLocations = dictionaryWithDistance[@"text"];

        NSString *distanceAndDurationBetweenLocations =
            [NSString stringWithFormat:@"%@, %@", distanceBetweenLocations,
                                       durationBetweenLocations];

        if (success) {
          success(distanceAndDurationBetweenLocations);
        }

      }
      failure:^(NSURLSessionTask *operation, NSError *error) {

        // NSLog(@"Error: %@", error);

        if (failure) {
          failure(error, 0);
        }
      }];
}

- (void)getDirectionsBetweenLocations:(CGFloat)lat1
                        andLongtitude:(CGFloat)lon1
                            latitude2:(CGFloat)lat2
                          longtitude2:(CGFloat)lon2
                            onSuccess:
                                (void (^)(NSDictionary *routePoints))success
                            onFailure:(void (^)(NSError *error,
                                                NSInteger statusCode))failure {

  NSString *URLstring = [NSString
      stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/"
                       @"json?origin=%f,%f&destination=%f,%f&mode=driving&"
                       @"units=metric&language=uk&key=%@",
                       lat1, lon1, lat2, lon2, googleMapsAPIKey];

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:URLstring
      parameters:nil
      progress:nil
      success:^(NSURLSessionTask *task, id responseObject) {

        NSArray *arrayWithData = responseObject[@"routes"];
        NSDictionary *dictionaryWithPolylines =
            [[arrayWithData firstObject] objectForKey:@"overview_polyline"];

        if (success) {
          success(dictionaryWithPolylines);
        }

      }
      failure:^(NSURLSessionTask *operation, NSError *error) {

        // NSLog(@"Error: %@", error);

        if (failure) {
          failure(error, 0);
        }
      }];
}

@end
