//  SHASearchDataHistory.h
//  MovieAssistant
//  Created by Andrew Shabunko on 8/30/16.
//  Copyright © 2016 lv189.ios. All rights reserved

#import <Foundation/Foundation.h>

@interface SHASearchDataHistory : NSObject

- (void) saveDataInSearchHistoryList:(NSMutableArray*)jsonArray;

- (NSDictionary*) readDataFromSearchHistory:(NSString*) requestString;

@end