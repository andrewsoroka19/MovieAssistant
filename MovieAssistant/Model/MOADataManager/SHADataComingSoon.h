//  SHADataComingSoon.h
//  MAproject
//  Created by Andrew Shabunko on 8/19/16.
//  Copyright © 2016 Andrew Shabunko. All rights reserved.

#import <Foundation/Foundation.h>

@interface SHADataComingSoon : NSObject

- (void) saveDataInComingSoonList:(NSMutableArray*)jsonArray;

- (NSArray*) readDataFromComingSoonList:(NSString*) filmTitle;

- (void) clearDataInComingSoonList;

@end