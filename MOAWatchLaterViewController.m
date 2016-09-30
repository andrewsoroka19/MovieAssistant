//  MOAInitialViewController.m
//  MovieAssistantFinal
//  Created by team on 22.08.16.
//  Copyright © 2016 lv189.ios. All rights reserved.

#import "MOAWatchLaterViewController.h"
#import "AIMovieParser.h"
#import "AIMovieDownloader.h"
#import "iCarousel.h"
#import <AFNetworking/AFNetworking.h>
#import <Realm/Realm.h>
#import "SHADataRealm.h"
#import "MOADownloadManager.h"
#pragma mark - Interface:

@interface MOAWatchLaterViewController () <iCarouselDataSource, iCarouselDelegate>

@property(weak, nonatomic) IBOutlet iCarousel *moviesCarousel;

@property(weak, nonatomic) IBOutlet UILabel *movieInfoLabel;
// Networking:
@property (strong, nonatomic) NSMutableArray* arrayWithDataForCollections;
@property(strong, nonatomic) NSMutableArray <SHADataRealm*> *movieArray;

@end

#pragma mark - Implementation:

@implementation MOAWatchLaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDefaultMovies];

}

// Default movies on starting view:

- (void)initDefaultMovies {
    
    RLMResults *dataFromRealm = [SHADataRealm allObjects];

    self.movieArray = (NSMutableArray*)dataFromRealm;
//    NSLog(@"adsdas %@", self.movieArray);
    
    [self configureCarusels];
}



// Carousel data load:
- (void)configureCarusels {
    
    self.moviesCarousel.delegate = self;
    self.moviesCarousel.dataSource = self;
    self.moviesCarousel.type = iCarouselTypeCoverFlow;
    [self.moviesCarousel reloadData];
    
    [self.moviesCarousel scrollToItemAtIndex:self.movieArray.count  duration:5.f];
    
 
    
    
}


#pragma mark - iCarousel delegete

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    
    return self.movieArray.count;
}

// Carousel View:
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    
    UIView *movieView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        UINib *nib = [UINib nibWithNibName:@"Movie" bundle:nil];
        NSArray *a = [nib instantiateWithOwner:self options:nil];
        movieView = a.lastObject;
        movieView.frame = view.bounds;
        movieView.tag = 999;
        
        [view addSubview:movieView];
    }
    
    else {
        
        //get a reference to the label in the recycled view
        movieView = (UIView *)[view viewWithTag:999];
    }
    
    UIImageView *iv = [movieView viewWithTag:1];
    
//    NSLog(@"%@", self.movieArray);
    
    
    [MOADownloadManager imageView:iv
                loadImageWithPath:[self.movieArray objectAtIndex:index]
     .realmPosterString];
    UILabel *l = [movieView viewWithTag:2];
    l.text = [self.movieArray objectAtIndex:index].realmTitleString;
    
    return view;
}

// Carousel View Width:
- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    
    return  CGRectGetHeight(carousel.frame)*0.65;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    
    self.movieInfoLabel.text = [NSString
                                stringWithFormat:@"%@", [self.movieArray
                                                         objectAtIndex:carousel.currentItemIndex]
                                .realmTitleString];
}

// Current view did select:
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"this is object at index:%ld", (long)index);
}


- (IBAction)showMapButtonTouch:(id)sender {
    
}


#pragma mark - Working with components

- (void)updateMovieInfoLabel:(NSString *)movieInfo {
    self.movieInfoLabel.text = [NSString stringWithFormat:@"%@", movieInfo];
    
}



@end