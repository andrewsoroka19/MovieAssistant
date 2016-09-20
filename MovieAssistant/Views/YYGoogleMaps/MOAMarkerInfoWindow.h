//
//  MarkerInfoWindow.h
//  MoviesProjectMapKit
//
//  Created by Yura Yasinskyy on 17.08.16.
//  Copyright © 2016 yura.yasinskyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOAMarkerInfoWindow : UIView

@property(weak, nonatomic) IBOutlet UILabel *markerName;
@property(weak, nonatomic) IBOutlet UILabel *markerAdress;
@property(weak, nonatomic) IBOutlet UIImageView *markerPicture;

@end
