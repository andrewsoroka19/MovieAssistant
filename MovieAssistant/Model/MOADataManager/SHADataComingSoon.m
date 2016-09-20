//  SHADataComingSoon.m
//  MAproject
//  Created by Andrew Shabunko on 8/19/16.
//  Copyright © 2016 Andrew Shabunko. All rights reserved.

#import "SHADataComingSoon.h"

static BOOL didFirstSave;

@implementation SHADataComingSoon

- (void) saveDataInComingSoonList:(NSMutableArray*)jsonArray {
    
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
        
        // saving clean data in plist file at follow path:
        
        NSString *comingSoonDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataComingSoonList.plist";
        
        // making simple saving structure:
        
        NSMutableDictionary *mainComingSoonDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:comingSoonDataFilePath];
        
        NSMutableDictionary *subComingSoonDataDict = [NSMutableDictionary dictionary];
        
        NSString *titleOfRaw = [NSString stringWithString:([[jsonArray objectAtIndex:0] objectForKey:@"original_title"])]; // set raw's title
        
        [mainComingSoonDataDict setObject:subComingSoonDataDict forKey:titleOfRaw];
        
        [subComingSoonDataDict setObject:clearGeneralJsonArray forKey:@"1GeneralInfo"];
        [subComingSoonDataDict setObject:clearSavedJsonArray forKey:@"2SavedInfo"];
        [subComingSoonDataDict setObject:clearCellJsonArray forKey:@"3CellInfo"];
        
        [mainComingSoonDataDict writeToFile:comingSoonDataFilePath atomically:YES];
        
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

#pragma mark - Saving 2nd        
        
        // saving clean data from ClearJsonArray into plist file at follow path:
        
        NSString *comingSoonDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataComingSoonList.plist";
        
        // making simple saving structure:
        
        NSMutableDictionary *mainComingSoonDataDict = [[NSMutableDictionary dictionaryWithContentsOfFile:comingSoonDataFilePath ]mutableCopy];
        
        NSMutableDictionary *subComingSoonDataDict = [NSMutableDictionary dictionary];
        
        NSString *titleOfRaw = [NSString stringWithString:([[jsonArray objectAtIndex:0] objectForKey:@"original_title"])]; // set raw's title
        
        [mainComingSoonDataDict setObject:subComingSoonDataDict forKey:titleOfRaw];
        
        [subComingSoonDataDict setObject:clearGeneralJsonArray forKey:@"1GeneralInfo"];
        [subComingSoonDataDict setObject:clearSavedJsonArray forKey:@"2SavedInfo"];
        [subComingSoonDataDict setObject:clearCellJsonArray forKey:@"3CellInfo"];
        
        [mainComingSoonDataDict writeToFile:comingSoonDataFilePath atomically:YES];
    }
}

#pragma mark - Reading

- (NSArray*) readDataFromComingSoonList:(NSString*) filmTitle {
    
    NSString *localFilmTitle = [NSString stringWithString:filmTitle];
    NSString *comingSoonDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataComingSoonList.plist";
    
    NSMutableDictionary *readComingSoonDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:comingSoonDataFilePath];
    NSMutableDictionary *filmDict = [NSMutableDictionary dictionaryWithDictionary:[readComingSoonDataDict objectForKey:localFilmTitle]];
    
    NSMutableArray *savedArray = [filmDict objectForKey:@"2SavedInfo"];
    NSMutableArray *currentFilmArray = [NSMutableArray array];
    
    for (NSInteger step = 0; step < [savedArray count]; step++) {
        
        if ([[[savedArray objectAtIndex:step] objectForKey:@"original_title"] isEqualToString:localFilmTitle]) {
            
            [currentFilmArray addObject:[savedArray objectAtIndex:step]];
        }
    }
    return currentFilmArray;
}

- (void) clearDataInComingSoonList {

    // метод очищення - перезаписує основний словник в файлі з даними на пустий словник:

    NSString *favoriteDataFilePath = @"/Users/AndrewShabunko/Desktop/Movie Assistant/MovieAssistant/Model/MOADataManager/SHADataComingSoonList.plist";

    NSMutableDictionary *clearDict = [NSMutableDictionary dictionaryWithContentsOfFile:favoriteDataFilePath];
    [clearDict removeAllObjects];
    [clearDict writeToFile:favoriteDataFilePath atomically:YES];
}

@end