//
//  SearchTableViewController.m
//  MovieAssistant
//
//  Created by Yura Yasinskyy on 23.08.16.
//  Copyright © 2016 lv189.ios. All rights reserved.
//

#import "MOAInitialSearchTableViewController.h"

@interface MOAInitialSearchTableViewController ()

@property (strong, nonatomic) NSMutableArray* tableData;

@end

@implementation MOAInitialSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableData = [NSMutableArray array];
    
    // Initializing table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    // Adding blur effect
    UIView* backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        backgroundView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = backgroundView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [backgroundView addSubview:blurEffectView];
    } else {
        backgroundView.backgroundColor = [UIColor clearColor];
    }
    
    
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];

    
}

#pragma mark - Provide data for SearchTableView

- (void)provideData:(NSMutableArray *)tableViewData {
    
    self.tableData = tableViewData;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"selectedSearchMatchNotification"
     object:@(indexPath.row)];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *locationsTableIdentifier = @"movieSearchCell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:locationsTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:locationsTableIdentifier];
        
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.tableData.count > 0) {
        cell.textLabel.text = [[self.tableData objectAtIndex:indexPath.row] description];
    } else {
        
        cell.textLabel.text = @"";
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}





@end
