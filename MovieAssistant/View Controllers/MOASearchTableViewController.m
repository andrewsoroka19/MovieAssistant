//
//  TableViewController.m
//  MainMenu
//
//  Created by admin on 8/16/16.
//  Copyright © 2016 ASh. All rights reserved.
//

#import "MOASearchTableViewController.h"
#import <GooglePlaces/GMSAutocompletePrediction.h>

@interface MOASearchTableViewController ()

@property(strong, nonatomic)
    NSMutableArray<GMSAutocompletePrediction *> *tableData;

@end

@implementation MOASearchTableViewController

#pragma mark - Main View

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

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

#pragma mark - Provide data

- (void)provideData:(NSMutableArray *)tableViewData {

  self.tableData = tableViewData;
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"notificationFromSearchTable"
                    object:@(indexPath.row)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return self.tableData.count;
}

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *locationsTableIdentifier = @"locationTableCell";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:locationsTableIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:locationsTableIdentifier];
  }

  cell.textLabel.textAlignment = NSTextAlignmentCenter;
  cell.textLabel.text = [
      [[self.tableData objectAtIndex:indexPath.row] attributedFullText] string];

  [cell setBackgroundColor:[UIColor clearColor]];

  return cell;
}

@end
