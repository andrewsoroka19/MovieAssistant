//
//  MOASelectedMovieViewController.m
//  MovieAssistant
//
//  Created by Soroka Andrii on 8/30/16.
//  Copyright © 2016 lv189.ios. All rights reserved.
//

#import "MOADownloadManager.h"
#import "MOASelectedMovieViewController.h"
#import "YTPlayerView.h"

@interface MOASelectedMovieViewController () <YTPlayerViewDelegate>

@property(weak, nonatomic) IBOutlet YTPlayerView *trailerView;

@end

@implementation MOASelectedMovieViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
    self.trailerView.delegate = self;

  self.movieTitle.text = self.movieTitleString;
  self.movieGenres.text = self.movieGenresString;
  self.movieDescription.text = self.movieDescriptionString;
  self.movieYear.text = self.movieYearString;
  self.movieRating.text = self.movieRatingString;

  [MOADownloadManager imageView:self.moviePoster
              loadImageWithPath:self.moviePosterString];

  [self updateTrailerView:self.movieTrailerString];

}

- (void)updateTrailerView:(NSString *)youtubeID {

  if (youtubeID == nil) {
    self.trailerView.hidden = YES;
  } else {
    self.trailerView.hidden = NO;
    [self.trailerView loadWithVideoId:youtubeID];
  }
}

- (nullable UIView *)playerViewPreferredInitialLoadingView:
    (nonnull YTPlayerView *)playerView {
  UIActivityIndicatorView *indicator = [UIActivityIndicatorView new];
  indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
  indicator.hidesWhenStopped = YES;
  [indicator startAnimating];
  return indicator;
}

@end
