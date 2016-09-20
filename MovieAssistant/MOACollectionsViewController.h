//
//  MOACollectionViewsControllerViewController.h
//  MovieAssistant
//
//  Created by admin on 9/15/16.
//  Copyright © 2016 lv189.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOACollectionsViewController : UIViewController

- (void)provideData:(NSMutableArray *)tableViewData;
@property (strong, nonatomic) NSMutableArray* dataFromInitial;

@end
