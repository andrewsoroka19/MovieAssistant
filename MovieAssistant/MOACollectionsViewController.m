//
//  MOAMovieSearchController.m
//  MovieAssistant
//
//  Created by admin on 8/30/16.
//  Copyright © 2016 lv189.ios. All rights reserved.
//

#import "MOADownloadManager.h"
#import "MOAGenres.h"
#import "MOAMovieCollectionViewCell.h"
#import "MOAMovieManager.h"
#import "MOACollectionsViewController.h"
#import "MOASelectedMovieViewController.h"
#import "MOATrailer.h"

@interface MOACollectionsViewController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@property(strong, nonatomic) NSMutableArray<MOAMovieManager *> *collectionViewData;
@property NSInteger selectedMovieIndex;
@property(strong, nonatomic) MOAGenres *genres;
@property (copy, nonatomic) __block NSString* trailerLink;


@property(strong, nonatomic) MOATrailer *selectedTrailer;


@property(weak, nonatomic)
IBOutlet UICollectionView *foundedMoviesCollectionView;

@end

@implementation MOACollectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialiazing arrays
    self.collectionViewData = [NSMutableArray array];
    
    // Setting delegates etc.
    self.foundedMoviesCollectionView.delegate = self;
    self.foundedMoviesCollectionView.dataSource = self;
    
    // Configuring UIColletionView
    UINib *nib = [UINib nibWithNibName:@"MOACollectionViewCell" bundle:nil];
    [self.foundedMoviesCollectionView registerNib:nib
                       forCellWithReuseIdentifier:@"collectionViewCell"];
    
    UICollectionViewFlowLayout *flowLayout =
    [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(150, 215)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.foundedMoviesCollectionView setCollectionViewLayout:flowLayout];
    
    
    
    
    [self provideData:self.dataFromInitial];
    
}

#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return self.collectionViewData.count;
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
     loadImageWithPath:[self.collectionViewData objectAtIndex:indexPath.row]
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
    MOAMovieManager *currentManager = [self.collectionViewData objectAtIndex:self.selectedMovieIndex];
    [MOADownloadManager fetchYoutubeTrailer:[currentManager.youTubeID1 stringValue]  completionHandler:^(MOATrailer *trailer) {
        self.selectedTrailer = trailer;
        [self performSegueWithIdentifier:@"segueToSelectedMovie" sender:self];
    }];
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
        vc.selectedTrailer = self.selectedTrailer;
    }
}


- (void)provideData:(NSMutableArray *)tableViewData {
    
    self.collectionViewData = tableViewData;
    [self.foundedMoviesCollectionView reloadData];
}


@end
