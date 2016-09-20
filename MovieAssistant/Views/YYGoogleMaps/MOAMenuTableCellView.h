//
//  MenuTableCellView.h
//  MoviesProjectMapKit
//
//  Created by Yura Yasinskyy on 19.08.16.
//  Copyright © 2016 yura.yasinskyy. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface MOAMenuTableCellView : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *cinemaNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *cinemaAdressLabel;
@property(weak, nonatomic) IBOutlet UILabel *distanceToCinemaLabel;
@property(weak, nonatomic) IBOutlet UIButton *navigateToCinemaButton;
- (IBAction)navigateToCinema:(id)sender;

@property(nonatomic) CLLocationCoordinate2D cinemaPosition;

@end
