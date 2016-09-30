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
#import <Realm/Realm.h>
#import "SHADataRealm.h"

@interface MOASelectedMovieViewController () <YTPlayerViewDelegate>

@property(weak, nonatomic) IBOutlet YTPlayerView *trailerView;
@property(weak, nonatomic) IBOutlet UIButton *shareFilm;


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
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:_movieDescription.text];
    NSRange range = NSMakeRange(0, [attString length]);
    
    [attString addAttribute:NSFontAttributeName value:_movieDescription.font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:_movieDescription.textColor range:range];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeMake(2.0f, 1.0f);
    [attString addAttribute:NSShadowAttributeName value:shadow range:range];
    
    _movieDescription.attributedText = attString;
    
    
    [MOADownloadManager imageView:self.moviePoster
                loadImageWithPath:self.moviePosterString];
    
    [self updateTrailerView:self.movieTrailerString];
    
}

- (void)updateTrailerView:(NSString *)youtubeID {
    
    if (youtubeID == nil && self.selectedTrailer.youtubeID == nil) {
        self.trailerView.hidden = YES;
        return;
    }
    if (youtubeID == nil) {
        self.trailerView.hidden = NO;
        [self.trailerView loadWithVideoId:self.selectedTrailer.youtubeID];
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
- (IBAction)showSocialView:(id)sender {
    
    NSString *shareText = [NSString
                           stringWithFormat:@"Nice movie: %@, %@!",_movieTitle.text, _movieYear.text
                           ];
    NSArray *itemsToShare = @[ shareText ];
    UIActivityViewController *activity =
    [[UIActivityViewController alloc] initWithActivityItems:itemsToShare
                                      applicationActivities:nil];
    activity.popoverPresentationController.sourceView = self.shareFilm;
    activity.popoverPresentationController.sourceRect = ((UIView *)sender).bounds;
    activity.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard ];
    [self presentViewController:activity animated:YES completion:nil];
}


- (IBAction)addMovieToFavorite:(id)sender {
    
    
    SHADataRealm *addMovieToFavorite = [[SHADataRealm alloc]init];
    
    addMovieToFavorite.realmPosterString = self.moviePosterString;
    addMovieToFavorite.realmTitleString = self.movieTitleString;
    addMovieToFavorite.realmGenresString = self.movieGenresString;
    addMovieToFavorite.realmYearString = self.movieYearString;
    addMovieToFavorite.realmRatingString = self.movieRatingString;
    addMovieToFavorite.realmDescriptionString = self.movieDescriptionString;
    addMovieToFavorite.realmTrailerString = self.movieTrailerString;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:addMovieToFavorite];
    [realm commitWriteTransaction];
    
    
}

@end