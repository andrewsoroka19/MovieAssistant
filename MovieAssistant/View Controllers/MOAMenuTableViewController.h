//
//  YYMenuTableViewController.h
//  MoviesProjectMapKit
//
//  Created by Yura Yasinskyy on 19.08.16.
//  Copyright © 2016 yura.yasinskyy. All rights reserved.
//

#import <GoogleMaps/GMSMarker.h>
#import <UIKit/UIKit.h>

@interface MOAMenuTableViewController : UITableViewController

- (void)provideData:(NSMutableArray *)tableViewData;

@property(nonatomic) CLLocationCoordinate2D userLocationCoordinate;

@end
