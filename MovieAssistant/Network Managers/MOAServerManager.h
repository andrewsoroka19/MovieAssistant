//
//  YYServerManager.h
//  MoviesProjectMapKit
//
//  Created by Yura Yasinskyy on 12.08.16.
//  Copyright © 2016 yura.yasinskyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MOAServerManager : NSObject

+ (MOAServerManager *)sharedServerManager;

- (void)getPlaces:(CGFloat)lat
    andLongtitude:(CGFloat)lon
        onSuccess:(void (^)(NSArray *places))success
        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getPlacePictureWithReference:(NSString *)reference
                         andMaxWidth:(NSInteger)width
                        andMaxHeigth:(NSInteger)height
                          getPicture:(void (^)(id picture))success
                           onFailure:(void (^)(NSError *error,
                                               NSInteger statusCode))failure;

- (void)getPlaceCoordinateByID:(NSString *)placeID
                getCoordinates:(void (^)(NSArray *placeCoordinatesByID))success
                     onFailure:(void (^)(NSError *error,
                                         NSInteger statusCode))failure;

- (void)getDistanceBetweenLocations:(CGFloat)lat1
                      andLongtitude:(CGFloat)lon1
                          latitude2:(CGFloat)lat2
                        longtitude2:(CGFloat)lon2
                          onSuccess:(void (^)(NSString *distance))success
                          onFailure:(void (^)(NSError *error,
                                              NSInteger statusCode))failure;

- (void)getDirectionsBetweenLocations:(CGFloat)lat1
                        andLongtitude:(CGFloat)lon1
                            latitude2:(CGFloat)lat2
                          longtitude2:(CGFloat)lon2
                            onSuccess:
                                (void (^)(NSDictionary *routePoints))success
                            onFailure:(void (^)(NSError *error,
                                                NSInteger statusCode))failure;

@end
