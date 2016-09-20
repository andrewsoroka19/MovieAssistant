//
//  YYMenuTableViewController.m
//  MoviesProjectMapKit
//
//  Created by Yura Yasinskyy on 19.08.16.
//  Copyright © 2016 yura.yasinskyy. All rights reserved.
//

#import "MOAMenuTableCellView.h"
#import "MOAMenuTableViewController.h"
#import "MOAServerManager.h"

@interface MOAMenuTableViewController ()

@property(strong, nonatomic) NSMutableArray<GMSMarker *> *tableData;

@end

@implementation MOAMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  UINib *nib = [UINib nibWithNibName:@"MOAMenuTableCellView" bundle:nil];
  [[self tableView] registerNib:nib
         forCellReuseIdentifier:@"locationTableCell"];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.separatorColor = [UIColor orangeColor];

  // Blur, etc.
  UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
  if (!UIAccessibilityIsReduceTransparencyEnabled()) {
    backgroundView.backgroundColor = [UIColor clearColor];

    UIBlurEffect *blurEffect =
        [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView =
        [[UIVisualEffectView alloc] initWithEffect:blurEffect];

    blurEffectView.frame = backgroundView.bounds;
    blurEffectView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [backgroundView addSubview:blurEffectView];
  } else {
    backgroundView.backgroundColor = [UIColor clearColor];
  }

  [self.view addSubview:backgroundView];
  [self.view sendSubviewToBack:backgroundView];

  [self.tableView setBackgroundColor:[UIColor clearColor]];
  [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)provideData:(NSMutableArray *)tableViewData {

  self.tableData = tableViewData;
  [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 115;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *locationsTableIdentifier = @"locationTableCell";

  MOAMenuTableCellView *cell =
      [tableView dequeueReusableCellWithIdentifier:locationsTableIdentifier];

  if (cell == nil) {

    cell =
        [[MOAMenuTableCellView alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:locationsTableIdentifier];
  }

  cell.cinemaNameLabel.text =
      [[self.tableData objectAtIndex:indexPath.row] title];
  cell.cinemaAdressLabel.text =
      [[self.tableData objectAtIndex:indexPath.row] snippet];
  cell.cinemaPosition = [[self.tableData objectAtIndex:indexPath.row] position];

  [[MOAServerManager sharedServerManager]
      getDistanceBetweenLocations:self.userLocationCoordinate.latitude
      andLongtitude:self.userLocationCoordinate.longitude
      latitude2:[[self.tableData objectAtIndex:indexPath.row] position].latitude
      longtitude2:[[self.tableData objectAtIndex:indexPath.row] position]
                      .longitude
      onSuccess:^(NSString *distance) {
        cell.distanceToCinemaLabel.text = distance;

      }
      onFailure:^(NSError *error, NSInteger statusCode){
          //        NSLog(@"error = %@, code = %li", [error
          //        localizedDescription],
          //              (long)statusCode);
      }];

  [cell.navigateToCinemaButton
             addTarget:self
                action:@selector(tableCellNavigateToCinemaButtonTapped:)
      forControlEvents:UIControlEventTouchDown];

  [cell setBackgroundColor:[UIColor clearColor]];

  return cell;
}

- (void)tableCellNavigateToCinemaButtonTapped:(id)sender {

  CGPoint buttonPosition =
      [sender convertPoint:CGPointZero toView:self.tableView];
  NSIndexPath *indexPath =
      [self.tableView indexPathForRowAtPoint:buttonPosition];

  NSArray *arrayWithLocationToBuildDirection = @[
    @([(MOAMenuTableCellView *)[self.tableView cellForRowAtIndexPath:indexPath]
          cinemaPosition]
          .latitude),
    @([(MOAMenuTableCellView *)[self.tableView cellForRowAtIndexPath:indexPath]
          cinemaPosition]
          .longitude)
  ];
  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"notificationToBuildDirection"
                    object:arrayWithLocationToBuildDirection];
}

@end
