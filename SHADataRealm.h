//  SHADataRealm.h
//  MovieAssistantFinal
//  Created by Andrew Shabunko on 9/21/16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import <Realm/Realm.h>

@interface SHADataRealm : RLMObject

// accessors for movie on selected View:
@property NSString *realmPosterString;
@property NSString *realmTitleString;
@property NSString *realmGenresString;
@property NSString *realmYearString;
@property NSString *realmRatingString;
@property NSString *realmDescriptionString;
@property NSString *realmTrailerString;

@end

RLM_ARRAY_TYPE(SHADataRealm)