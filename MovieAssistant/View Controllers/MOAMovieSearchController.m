//  MOAMovieSearchController.m
//  MovieAssistantFinal
//  Created by team on 8/30/16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import "MOAMovieCollectionViewCell.h"

#import "MOADownloadManager.h"
#import "MOAGenres.h"
#import "MOAMovieManager.h"
#import "MOAMovieSearchController.h"
#import "MOASelectedMovieViewController.h"
#import "MOATrailer.h"


#pragma mark - Interface:

@interface MOAMovieSearchController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, nonatomic) NSMutableArray<MOAMovieManager *> *movieSearchMatches;
@property(strong, nonatomic) NSMutableArray<MOAMovieManager *> *collectionViewData;

@property NSInteger kSearchMatchesCount;
@property NSInteger selectedMovieIndex;

@property(strong, nonatomic) MOAGenres *genres;
@property (copy, nonatomic) __block NSString* trailerLink;
@property(weak, nonatomic) IBOutlet UITextField *searchForMovieTextField;
@property(weak, nonatomic) IBOutlet UICollectionView *foundedMoviesCollectionView;

- (IBAction)searchForMovieTextFieldValueChanged:(id)sender;

@end

#pragma mark - Implementation:

@implementation MOAMovieSearchController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Initialiazing arrays
  self.movieSearchMatches = [NSMutableArray array];
  self.collectionViewData = [NSMutableArray array];

  // Setting delegates etc.
  self.foundedMoviesCollectionView.delegate = self;
  self.foundedMoviesCollectionView.dataSource = self;
  self.searchForMovieTextField.delegate = self;

  // Configuring UIColletionView
  UINib *nib = [UINib nibWithNibName:@"MOACollectionViewCell" bundle:nil];
  [self.foundedMoviesCollectionView registerNib:nib
                     forCellWithReuseIdentifier:@"collectionViewCell"];

  UICollectionViewFlowLayout *flowLayout =
      [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setItemSize:CGSizeMake(150, 215)];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  [self.foundedMoviesCollectionView setCollectionViewLayout:flowLayout];

  // Initialize UITextField delegate
  self.searchForMovieTextField.delegate = self;

  // Initializing other values
  self.kSearchMatchesCount = 15;
  [self.searchForMovieTextField
             addTarget:self
                action:@selector(searchForMovieTextFieldValueChanged:)
      forControlEvents:UIControlEventEditingDidEndOnExit];
  [self.searchForMovieTextField becomeFirstResponder];

  //    // Adding observer for notifications from search matches
  //    [[NSNotificationCenter defaultCenter]
  //     addObserver:self
  //     selector:@selector(receiveNotification:)
  //     name:@"selectedSearchMatchNotification"
  //     object:nil];
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

  return self.movieSearchMatches.count;
}

// The cell that is returned must be retrieved from a call to
// -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *cellIdentifier = @"collectionViewCell";

  MOAMovieCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                forIndexPath:indexPath];

  cell.movieInfoLabel.textColor = [UIColor whiteColor];
  cell.movieInfoLabel.text = [NSString
      stringWithFormat:@"%@, %@",
                       [self.collectionViewData objectAtIndex:indexPath.row]
                           .movieName,
                       [self.collectionViewData objectAtIndex:indexPath.row]
                           .movieYear];

  [MOADownloadManager
              imageView:cell.moviePosterImage
      loadImageWithPath:[self.movieSearchMatches objectAtIndex:indexPath.row]
                            .moviePoster];

  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return 1;
}

#pragma mark - Segues

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

  self.selectedMovieIndex = indexPath.row;
  [self performSegueWithIdentifier:@"segueToSelectedMovie" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  // Make sure your segue name in storyboard is the same as this line
  if ([[segue identifier] isEqualToString:@"segueToSelectedMovie"]) {
    // Get reference to the destination view controller
    MOASelectedMovieViewController *vc = [segue destinationViewController];

    [vc setMovieTitleString:[self.collectionViewData
                                objectAtIndex:self.selectedMovieIndex]
                                .movieName];
    [vc setMovieYearString:[self.collectionViewData
                               objectAtIndex:self.selectedMovieIndex]
                               .movieYear];
    [vc setMovieRatingString:[self.collectionViewData
                                 objectAtIndex:self.selectedMovieIndex]
                                 .movieRating];
    [vc setMovieDescriptionString:[self.collectionViewData
                                      objectAtIndex:self.selectedMovieIndex]
                                      .movieDescription];
    [vc setMovieGenresString:[self.collectionViewData
                                 objectAtIndex:self.selectedMovieIndex]
                                 .movieGenres];
    [vc setMoviePosterString:[self.collectionViewData
                                 objectAtIndex:self.selectedMovieIndex]
                                 .moviePoster];
    [vc setMovieTrailerString:[self.collectionViewData
                                  objectAtIndex:self.selectedMovieIndex]
                                  .movieYouTubeID];
  }
}

#pragma mark - UITextField delegate

- (IBAction)searchForMovieTextFieldValueChanged:(id)sender {

  if ([self.searchForMovieTextField.text isEqualToString:@""]) {
    [self.searchForMovieTextField resignFirstResponder];
    return;
  } else {

    [self movieSearchAutoComplete:self.searchForMovieTextField.text];
  }
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  return YES;
}

#pragma mark - Movie search autocomplete

- (void)movieSearchAutoComplete:(NSString *)stringToSearch {

  [self.movieSearchMatches removeAllObjects];
  [MOADownloadManager
      autocompleteMovieTitle:self.searchForMovieTextField.text
           completionHandler:^(NSArray *resultsArray) {

             self.kSearchMatchesCount = resultsArray.count;
             for (NSInteger i = 0; i < self.kSearchMatchesCount; i++) {

               NSDictionary *movieDictionary = [resultsArray objectAtIndex:i];

               NSString *currentDateString = movieDictionary[@"release_date"];
               NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];

               [dateFormater setDateFormat:@"yyyy-MM-DD"];
               NSDate *currentDate =
                   [dateFormater dateFromString:currentDateString];

               [dateFormater setDateFormat:@"yyyy"];
               NSString *convertedDateString =
                   [dateFormater stringFromDate:currentDate];

               NSString *posterPath = movieDictionary[@"poster_path"];
               NSString *posterURLstring = [[NSString
                   stringWithFormat:@"https://image.tmdb.org/t/p/original%@",
                                    posterPath]
                   stringByReplacingOccurrencesOfString:@" "
                                             withString:@"%20"];

               self.genres = [MOAGenres
                   genreWithNumberArray:movieDictionary[@"genre_ids"]];

               NSString *genresString = @"";
               for (NSString *name in self.genres.namesArray) {
                 if ([genresString isEqualToString:@""]) {
                   genresString = name; // First time
                 } else {
                   genresString = [NSString
                       stringWithFormat:@"%@, %@", genresString, name];
                 }
               }
                 
                 

               [MOADownloadManager fetchYoutubeTrailer:movieDictionary[@"id"]
                                     completionHandler:^(MOATrailer *trailer) {
                                         
                                         [self.movieSearchMatches
                                          addObject:[MOAMovieManager
                                                     newMoviewWithName:movieDictionary[
                                                                                       @"original_title"]
                                                     andYear:convertedDateString
                                                     andGenres:genresString
                                                     andRating:[NSString
                                                                stringWithFormat:
                                                                @"%@",
                                                                movieDictionary[
                                                                                @"vote_average"]]
                                                     andDescription:movieDictionary[@"overview"]
                                                     andPoster:posterURLstring
                                                     andTrailer:trailer.youtubeID]];
                                         
                                         [self provideData:self.movieSearchMatches];
                                             
                                         }];
                
                 
                 
             }
           }];
}

- (void)provideData:(NSMutableArray *)tableViewData {

  self.collectionViewData = self.movieSearchMatches;
  [self.foundedMoviesCollectionView reloadData];
}

@end