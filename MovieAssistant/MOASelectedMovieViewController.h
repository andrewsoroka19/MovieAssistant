//
//  MOASelectedMovieViewController.h
//  MovieAssistant
//
//  Created by Soroka Andrii on 8/30/16.
//  Copyright © 2016 lv189.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOASelectedMovieViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIImageView *moviePoster;
@property(weak, nonatomic) IBOutlet UILabel *movieTitle;
@property(weak, nonatomic) IBOutlet UILabel *movieGenres;
@property(weak, nonatomic) IBOutlet UILabel *movieYear;
@property(weak, nonatomic) IBOutlet UILabel *movieRating;
@property(weak, nonatomic) IBOutlet UITextView *movieDescription;

@property(strong, nonatomic) NSString *moviePosterString;
@property(strong, nonatomic) NSString *movieTitleString;
@property(strong, nonatomic) NSString *movieGenresString;
@property(strong, nonatomic) NSString *movieYearString;
@property(strong, nonatomic) NSString *movieRatingString;
@property(strong, nonatomic) NSString *movieDescriptionString;
@property(strong, nonatomic) NSString *movieTrailerString;

@end
