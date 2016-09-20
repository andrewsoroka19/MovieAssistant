//
//  MOAMovieCollectionViewCell.h
//  MovieAssistant
//
//  Created by admin on 8/30/16.
//  Copyright © 2016 lv189.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOAMovieCollectionViewCell : UICollectionViewCell

@property(weak, nonatomic) IBOutlet UIImageView *moviePosterImage;
@property(weak, nonatomic) IBOutlet UILabel *movieInfoLabel;

@end
