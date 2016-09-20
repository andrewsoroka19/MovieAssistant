//  SHADataFavorite.m
//  MAproject
//  Created by Andrew Shabunko on 8/19/16.
//  Copyright © 2016 Andrew Shabunko. All rights reserved.

#import "SHADataFavorite.h"

static BOOL didFirstSave;

@implementation SHADataFavorite

- (void) saveDataInFavoriteList:(NSMutableArray*)jsonArray {
    
    if (!didFirstSave) { // 1st save
 
#pragma mark - Filter 1st
        
        // deleting all useless elements for General Info:
        
        NSMutableArray *generalJsonArray = [NSMutableArray arrayWithArray:jsonArray];
        NSMutableArray *clearGeneralJsonArray = [NSMutableArray array];
        
        NSInteger countElementsGeneral = [generalJsonArray count];
        for (NSInteger startPoint = 0; startPoint < countElementsGeneral; startPoint++) {
            
            NSMutableDictionary *generalDictClear = [[generalJsonArray objectAtIndex:startPoint] mutableCopy];
            NSArray *keysForUselessValues = [NSArray arrayWithObject:@"id"];
            
            [generalDictClear removeObjectsForKeys:keysForUselessValues];
            [clearGeneralJsonArray addObject:generalDictClear];
        }
        
        // deleting all useless elements for Saved Info:
        
        NSMutableArray *savedJsonArray = [NSMutableArray arrayWithArray:clearGeneralJsonArray];
        NSMutableArray *clearSavedJsonArray = [NSMutableArray array];
        
        NSInteger countElementsSaved = [savedJsonArray count];
        for (NSInteger startPoint = 0; startPoint < countElementsSaved; startPoint++) {
            
            NSMutableDictionary *savedDictClear = [[savedJsonArray objectAtIndex:startPoint] mutableCopy];
            NSArray *keysForUselessValues = [NSArray arrayWithObjects:@"backdrop_path",@"original_language",@"popularity",@"title",@"vote_count", nil];
            
            [savedDictClear removeObjectsForKeys:keysForUselessValues];
            [clearSavedJsonArray addObject:savedDictClear];
        }
        
        // deleting all useless elements for Cell Info:
        
        NSMutableArray *cellJsonArray = [NSMutableArray arrayWithArray:clearSavedJsonArray];
        NSMutableArray *clearCellJsonArray = [NSMutableArray array];
        
        NSInteger countElementsCell = [cellJsonArray count];
        for (NSInteger startPoint = 0; startPoint < countElementsCell; startPoint++) {
            
            NSMutableDictionary *cellDictClear = [[cellJsonArray objectAtIndex:startPoint] mutableCopy];
            NSArray *keysForUselessValues = [NSArray arrayWithObjects:@"genre_ids",@"vote_average",@"overview",nil];
            
            [cellDictClear removeObjectsForKeys:keysForUselessValues];
            [clearCellJsonArray addObject:cellDictClear];
        }

#pragma mark - Saving 1st
        
            // saving clean data from ClearJsonArray into plist file at follow path:
        
            NSString *favoriteDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataFavoriteList.plist";
        
            // making simple saving structure:
        
            NSMutableDictionary *mainFavoriteDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:favoriteDataFilePath];

            NSMutableDictionary *subFavoriteDataDict = [NSMutableDictionary dictionary];
            
            NSString *titleOfRaw = [NSString stringWithString:([[jsonArray objectAtIndex:0] objectForKey:@"original_title"])]; // set raw's title
            
            [mainFavoriteDataDict setObject:subFavoriteDataDict forKey:titleOfRaw];
        
            [subFavoriteDataDict setObject:clearGeneralJsonArray forKey:@"1GeneralInfo"];
            [subFavoriteDataDict setObject:clearSavedJsonArray forKey:@"2SavedInfo"];
            [subFavoriteDataDict setObject:clearCellJsonArray forKey:@"3CellInfo"];
        
            [mainFavoriteDataDict writeToFile:favoriteDataFilePath atomically:YES];
        
           didFirstSave = YES;
    }

    else { // 2nd and future saving

#pragma mark - Filter 2nd
        
        // deleting all useless elements for General Info:
        
        NSMutableArray *generalJsonArray = [NSMutableArray arrayWithArray:jsonArray];
        NSMutableArray *clearGeneralJsonArray = [NSMutableArray array];
        
        NSInteger countElementsGeneral = [generalJsonArray count];
        for (NSInteger startPoint = 0; startPoint < countElementsGeneral; startPoint++) {
            
            NSMutableDictionary *generalDictClear = [[generalJsonArray objectAtIndex:startPoint] mutableCopy];
            NSArray *keysForUselessValues = [NSArray arrayWithObject:@"id"];
            
            [generalDictClear removeObjectsForKeys:keysForUselessValues];
            [clearGeneralJsonArray addObject:generalDictClear];
            
        }
        
        // deleting all useless elements for Saved Info:
        
        NSMutableArray *savedJsonArray = [NSMutableArray arrayWithArray:clearGeneralJsonArray];
        NSMutableArray *clearSavedJsonArray = [NSMutableArray array];
        
        NSInteger countElementsSaved = [savedJsonArray count];
        for (NSInteger startPoint = 0; startPoint < countElementsSaved; startPoint++) {
            
            NSMutableDictionary *savedDictClear = [[savedJsonArray objectAtIndex:startPoint] mutableCopy];
            NSArray *keysForUselessValues = [NSArray arrayWithObjects:@"backdrop_path",@"original_language",@"dsdsd",@"title",@"vote_count", nil];
            
            [savedDictClear removeObjectsForKeys:keysForUselessValues];
            [clearSavedJsonArray addObject:savedDictClear];
        }
        
        // deleting all useless elements for Cell Info:
        
        NSMutableArray *cellJsonArray = [NSMutableArray arrayWithArray:clearSavedJsonArray];
        NSMutableArray *clearCellJsonArray = [NSMutableArray array];
        
        NSInteger countElementsCell = [cellJsonArray count];
        for (NSInteger startPoint = 0; startPoint < countElementsCell; startPoint++) {
            
            NSMutableDictionary *cellDictClear = [[cellJsonArray objectAtIndex:startPoint] mutableCopy];
            NSArray *keysForUselessValues = [NSArray arrayWithObjects:@"genre_ids",@"vote_average",@"overview",nil];
            
            [cellDictClear removeObjectsForKeys:keysForUselessValues];
            [clearCellJsonArray addObject:cellDictClear];
        }
        
#pragma mark - Saving 2nd
        
        // saving clean data in plist file at follow path:
        
        NSString *favoriteDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataFavoriteList.plist";
        
        // making simple saving structure:
        
        NSMutableDictionary *mainFavoriteDataDict = [[NSMutableDictionary dictionaryWithContentsOfFile:favoriteDataFilePath ]mutableCopy];
        
        NSMutableDictionary *subFavoriteDataDict = [NSMutableDictionary dictionary];
        
        NSString *titleOfRaw = [NSString stringWithString:([[jsonArray objectAtIndex:0] objectForKey:@"original_title"])]; // set raw's title
        
        [mainFavoriteDataDict setObject:subFavoriteDataDict forKey:titleOfRaw];
        
        [subFavoriteDataDict setObject:clearGeneralJsonArray forKey:@"1GeneralInfo"];
        [subFavoriteDataDict setObject:clearSavedJsonArray forKey:@"2SavedInfo"];
        [subFavoriteDataDict setObject:clearCellJsonArray forKey:@"3CellInfo"];
        
        [mainFavoriteDataDict writeToFile:favoriteDataFilePath atomically:YES];
    }
}

#pragma mark - Reading

- (NSArray*) readDataFromFavoriteList:(NSString*) filmTitle {
    
    NSString *localFilmTitle = [NSString stringWithString:filmTitle];
    NSString *favoriteDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataFavoriteList.plist";
    
    NSMutableDictionary *readFavoriteDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:favoriteDataFilePath];
    NSMutableDictionary *filmDict = [NSMutableDictionary dictionaryWithDictionary:[readFavoriteDataDict objectForKey:localFilmTitle]];
    
    NSMutableArray *savedArray = [filmDict objectForKey:@"2SavedInfo"];
    NSMutableArray *currentFilmArray = [NSMutableArray array];
    
    for (NSInteger step = 0; step < [savedArray count]; step++) {
        
        if ([[[savedArray objectAtIndex:step] objectForKey:@"original_title"] isEqualToString:localFilmTitle]) {
         
            [currentFilmArray addObject:[savedArray objectAtIndex:step]];
        }
    }
      return currentFilmArray;
}

- (void) clearDataInFavoriteList {
    
    // метод очищення - перезаписує основний словник в файлі з даними на пустий словник:
    
    NSString *favoriteDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataFavoriteList.plist";
    
    NSMutableDictionary *clearDict = [NSMutableDictionary dictionaryWithContentsOfFile:favoriteDataFilePath];
    [clearDict removeAllObjects];
    [clearDict writeToFile:favoriteDataFilePath atomically:YES];
}

@end