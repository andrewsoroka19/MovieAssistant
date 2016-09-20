//  SHADataFavorite.h
//  MAproject
//  Created by Andrew Shabunko on 8/19/16.
//  Copyright © 2016 Andrew Shabunko. All rights reserved.

#import <Foundation/Foundation.h>

@interface SHADataFavorite : NSObject

- (void) saveDataInFavoriteList:(NSMutableArray*)jsonArray;

- (NSArray*) readDataFromFavoriteList:(NSString*) filmTitle;

- (void) clearDataInFavoriteList;

@end