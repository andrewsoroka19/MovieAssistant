//  SHASearchDataHistory.m
//  MovieAssistant
//  Created by Andrew Shabunko on 8/30/16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import "SHASearchDataHistory.h"
#import "SHADataFavorite.h"
#import "SHADataComingSoon.h"

@implementation SHASearchDataHistory

static BOOL didFirstSave;

- (void) saveDataInSearchHistoryList:(NSMutableArray*)jsonArray {
    
#pragma mark - Filter
    
    // deleting all null objects from jsonArray:
    
    NSMutableArray *locJsonArray = [NSMutableArray arrayWithArray:jsonArray];
    NSMutableArray *clearJsonArray = [NSMutableArray array];
    
    NSInteger countElements = [locJsonArray count];
    for (NSInteger startPoint = 0; startPoint < countElements; startPoint++) {
        
        NSMutableDictionary *dictClear = [[locJsonArray objectAtIndex:startPoint] mutableCopy];
        NSArray *keysForNullValues = [dictClear allKeysForObject:[NSNull null]];
        
        [dictClear removeObjectsForKeys:keysForNullValues];
        [clearJsonArray addObject:dictClear];
    }
    
    // deleting all useless elements for History List:
    
    NSMutableArray *historyJsonArray = [NSMutableArray arrayWithArray:clearJsonArray];
    NSMutableArray *clearHistoryJsonArray = [NSMutableArray array];
    
    NSInteger countElementsHistory = [historyJsonArray count];
    for (NSInteger startPoint = 0; startPoint < countElementsHistory; startPoint++) {
        
        NSMutableDictionary *historyDictClear = [[historyJsonArray objectAtIndex:startPoint] mutableCopy];
        NSArray *keysForUselessValues = [NSArray arrayWithObjects:@"adult",@"video", nil];
        
        [historyDictClear removeObjectsForKeys:keysForUselessValues];
        [clearHistoryJsonArray addObject:historyDictClear];
    }
    
    SHADataFavorite *testFavorite = [[SHADataFavorite alloc]init];
    [testFavorite saveDataInFavoriteList:clearHistoryJsonArray];
    
    SHADataComingSoon *testComingSoon = [[SHADataComingSoon alloc]init];
    [testComingSoon saveDataInComingSoonList:clearHistoryJsonArray];
    
#pragma mark - Save
    
    if (!didFirstSave) { // 1st save
        
        NSMutableArray *localArray = [NSMutableArray arrayWithArray:clearHistoryJsonArray];
        NSString *dataSearchFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHASearchDataHistoryList.plist";
        NSString *sectionTitle = [NSString stringWithString:[[localArray firstObject] objectForKey:@"original_title"]];
        
        NSMutableDictionary *dictWithFilms = [NSMutableDictionary dictionaryWithContentsOfFile:dataSearchFilePath];
        NSMutableDictionary *dictWithConcretFilm = [NSMutableDictionary dictionary];
        
        for (NSInteger step = 0; step < [localArray count]; step++) { // change array to dictionary
            
            NSMutableDictionary *clearDict = [NSMutableDictionary dictionaryWithDictionary:[localArray objectAtIndex:step]];
            
            NSString *titleFilm = [NSString stringWithString:[clearDict objectForKey:@"original_title"]];
            
            [dictWithConcretFilm setObject:clearDict forKey:titleFilm];
        }
        
        [dictWithFilms setObject:dictWithConcretFilm forKey:sectionTitle];
        [dictWithFilms writeToFile:dataSearchFilePath atomically:YES];
        
        didFirstSave = YES;
    }
    else { // 2nd and future save
        
        NSMutableArray *localArray = [[NSMutableArray arrayWithArray:clearHistoryJsonArray]mutableCopy];
        NSString *dataSearchFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHASearchDataHistoryList.plist";
        NSString *sectionTitle = [NSString stringWithString:[[localArray firstObject] objectForKey:@"original_title"]];
        
        NSMutableDictionary *dictWithFilms = [[NSMutableDictionary dictionaryWithContentsOfFile:dataSearchFilePath]mutableCopy];
        NSMutableDictionary *dictWithConcretFilm = [NSMutableDictionary dictionary];
        
        for (NSInteger step = 0; step < [localArray count]; step++) { // change array to dictionary
            
            NSMutableDictionary *clearDict = [NSMutableDictionary dictionaryWithDictionary:[localArray objectAtIndex:step]];
            
            NSString *titleFilm = [NSString stringWithString:[clearDict objectForKey:@"original_title"]];
            
            [dictWithConcretFilm setObject:clearDict forKey:titleFilm];
        }
            [dictWithFilms setObject:dictWithConcretFilm forKey:sectionTitle];
        [dictWithFilms writeToFile:dataSearchFilePath atomically:YES];
    }
}

- (NSDictionary*) readDataFromSearchHistory:(NSString*) requestString {
    
    NSString *titleString = [NSString stringWithString:requestString];
    NSString *dataSearchFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHASearchDataHistoryList.plist";
    
    NSMutableDictionary *readHistoryDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:dataSearchFilePath];
    NSMutableDictionary *historyDict = [NSMutableDictionary dictionaryWithDictionary:[readHistoryDataDict objectForKey:titleString]];
    NSMutableDictionary *historyCurrentFilmDict = [NSMutableDictionary dictionaryWithDictionary:[historyDict objectForKey:titleString]];
    NSLog(@"ret %@",historyCurrentFilmDict);
    return historyCurrentFilmDict;
}

@end