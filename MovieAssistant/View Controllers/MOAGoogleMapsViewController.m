//
//  YYGoogleMapsViewController.m
//  MoviesProjectMapKit
//
//  Created by Yura Yasinskyy on 09.08.16.
//  Copyright © 2016 yura.yasinskyy. All rights reserved.
//

#import "MOAGoogleMapsViewController.h"
#import "MOAMarkerInfoWindow.h"
#import "MOAMenuTableViewController.h"
#import "MOASearchTableViewController.h"
#import "MOAServerManager.h"

@interface MOAGoogleMapsViewController () <UISearchBarDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) GMSPlacesClient *placesClient;
@property(strong, nonatomic) GMSPlacePicker *placePicker;
@property(strong, nonatomic) NSMutableArray *placesArray;
@property(nonatomic) CLLocationCoordinate2D userLocationCoordinate;
@property(strong, nonatomic) MOASearchTableViewController *searchTablePopover;
@property(strong, nonatomic)
    NSMutableArray<GMSAutocompletePrediction *> *locationSearchMatches;
@property(strong, nonatomic) __block NSMutableArray *allMarkersFromMap;
@property(strong, nonatomic) __block NSMutableArray *allPolylinesFromMap;
@property(strong, nonatomic) MOAMenuTableViewController *menuTablePopover;
@property(strong, nonatomic) __block NSMutableArray *systemData;
@property BOOL isStreetViewShown;

@property(strong, nonatomic) IBOutlet GMSMapView *mapView;
@property(weak, nonatomic) IBOutlet UIButton *menuButton;
@property(weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet UIButton *showStreetViewButton;
@property(weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSwitcher;
- (IBAction)showMenu:(id)sender;
- (IBAction)showSearchBarButton:(id)sender;
- (IBAction)showStreetViewFromLocation:(id)sender;
- (IBAction)mapTypeChanged:(id)sender;

@end

@implementation MOAGoogleMapsViewController {

  GMSMapView *mapView_;
}

#pragma mark - Main View

- (void)viewDidLoad {
  [super viewDidLoad];

  // Initializing arrays and other properties
  self.allMarkersFromMap = [NSMutableArray array];
  self.allPolylinesFromMap = [NSMutableArray array];
  self.systemData = [NSMutableArray array];
  self.searchBar.layer.cornerRadius = 10;

  // Asking user for his location and initializing map
  [self askForUserLocationUsage];

  mapView_ = self.mapView;
  mapView_.delegate = self;
  mapView_.myLocationEnabled = YES;
  mapView_.mapType = kGMSTypeNormal;
  [mapView_.settings setAllGesturesEnabled:YES];
  mapView_.settings.compassButton = YES;
  mapView_.settings.myLocationButton = YES;

  if (([CLLocationManager authorizationStatus] ==
       kCLAuthorizationStatusAuthorizedAlways) ||
      ([CLLocationManager authorizationStatus] ==
       kCLAuthorizationStatusAuthorizedWhenInUse)) {

    self.userLocationCoordinate = self.locationManager.location.coordinate;

    [self addMarkerToPosition:self.userLocationCoordinate
                    withTitle:@"Current location"
                     subtitle:@""
                        onMap:mapView_
                     dragable:NO
                   markerData:@"UL"
                      andIcon:nil
           streetViewPanorama:nil];

    // Getting cinemas near user
    [self getCinemasNearCoordinates:self.userLocationCoordinate];
  }

  // Initializng GooglePlaces
  self.placesClient = [[GMSPlacesClient alloc] init];
  self.placesArray = [NSMutableArray array];

  // Delegates etc.
  [mapView_ setTranslatesAutoresizingMaskIntoConstraints:YES];
  mapView_.frame = self.view.bounds;

  self.searchBar.hidden = YES;
  self.showStreetViewButton.hidden = YES;
  self.isStreetViewShown = NO;

  self.searchBar.delegate = self;
  self.searchTablePopover = [MOASearchTableViewController new];
  self.locationSearchMatches = [NSMutableArray array];

  // Observing notifications
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(receiveNotification:)
             name:@"notificationFromSearchTable"
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(notificationToBuildDiraction:)
             name:@"notificationToBuildDirection"
           object:nil];

  self.menuTablePopover = [MOAMenuTableViewController new];
}

#pragma mark - Recieve notifications

- (void)notificationToBuildDiraction:(NSNotification *)notification {

  if ([[notification name] isEqualToString:@"notificationToBuildDirection"]) {

    [self buildDirectionsBetweenLocations:self.userLocationCoordinate.latitude
                                  andLon1:self.userLocationCoordinate.longitude
                                  andLat2:[[notification.object objectAtIndex:0]
                                              floatValue]
                                  andLon2:[[notification.object objectAtIndex:1]
                                              floatValue]];
  }
}

- (void)receiveNotification:(NSNotification *)notification {

  if ([[notification name] isEqualToString:@"notificationFromSearchTable"]) {

    NSNumber *recievedTablePosition = notification.object;

    [self geocodePlaceIDToCoordinates:[[self.locationSearchMatches
                                          objectAtIndex:[recievedTablePosition
                                                            integerValue]]
                                          placeID]];

    [self.searchTablePopover
        dismissViewControllerAnimated:YES
                           completion:^{

                             [self.searchBar resignFirstResponder];
                             self.searchBar.hidden = YES;

                             // NSLog(@"Popover controller dismissed");
                           }];
  }
}

#pragma mark - SearchBar delegate

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {

  if (![self.presentedViewController
          isKindOfClass:MOASearchTableViewController.class]) {
    self.searchTablePopover.modalPresentationStyle = UIModalPresentationPopover;
    self.searchTablePopover.popoverPresentationController.sourceView =
        self.searchBar;

    self.searchTablePopover.popoverPresentationController.sourceRect =
        CGRectMake(self.searchBar.frame.size.width / 2,
                   self.searchBar.frame.size.height * 4 - 10, 0, 0);

    [self.searchTablePopover.popoverPresentationController
        setPermittedArrowDirections:0];

    self.searchTablePopover.preferredContentSize = CGSizeMake(500, 225);
    [self presentViewController:self.searchTablePopover
                       animated:YES
                     completion:nil];
  }

  if ([self.searchBar.text isEqualToString:@""]) {

    [self.searchTablePopover
        dismissViewControllerAnimated:YES
                           completion:^{
                               // NSLog(@"Popover controller dismissed");
                           }];
  }

  [self placeAutocomplete:self.searchBar.text];
}

#pragma mark - GMSMapViewDelegate

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView {

  self.userLocationCoordinate = self.locationManager.location.coordinate;

  // Just to be clean
  for (GMSMarker *marker in self.allMarkersFromMap) {

    marker.map = nil;
  }
  [self.allMarkersFromMap removeAllObjects];
  for (UIView *subview in mapView_.subviews) {

    if ([subview isKindOfClass:GMSPanoramaView.class]) {
      [subview removeFromSuperview];
    }
  }
  self.isStreetViewShown = NO;
  for (GMSMarker *marker in self.systemData) {

    marker.map = nil;
  }

  [mapView animateWithCameraUpdate:[GMSCameraUpdate
                                       setTarget:self.userLocationCoordinate
                                            zoom:15]];
  [self getCinemasNearCoordinates:self.userLocationCoordinate];

  return YES;
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {

  if ([marker.userData isEqual:@"NA"] || [marker.userData isEqual:@"UL"]) {
    return nil;
  }

  MOAMarkerInfoWindow *infoWindow =
      [[[NSBundle mainBundle] loadNibNamed:@"MOAMarkerInfoView"
                                     owner:self
                                   options:nil] objectAtIndex:0];
  infoWindow.markerName.text = marker.title;
  infoWindow.markerAdress.text = marker.snippet;
  infoWindow.markerPicture.image = marker.userData;

  return infoWindow;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
  mapView.selectedMarker = marker;

  [mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:marker.position]];
  [mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:marker.position
                                                         zoom:15]];

  [UIView transitionWithView:self.showStreetViewButton
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    if (self.showStreetViewButton.hidden == YES) {
                      self.showStreetViewButton.hidden = NO;

                    } else {
                      self.showStreetViewButton.hidden = YES;
                    }
                  }
                  completion:NULL];

  return YES;
}

- (void)mapView:(GMSMapView *)mapView
    didCloseInfoWindowOfMarker:(GMSMarker *)marker {

  [UIView transitionWithView:self.showStreetViewButton
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    if (self.showStreetViewButton.hidden == YES) {
                      self.showStreetViewButton.hidden = NO;

                    } else {
                      self.showStreetViewButton.hidden = YES;
                    }
                  }
                  completion:NULL];

  // Just to be clean
  for (UIView *subview in mapView_.subviews) {

    if ([subview isKindOfClass:GMSPanoramaView.class]) {
      [subview removeFromSuperview];
    }
  }
  self.isStreetViewShown = NO;

  [self ShowAllMarkersOnMap];
}

#pragma mark - Working with map

- (void)buildDirectionsBetweenLocations:(CGFloat)lat1
                                andLon1:(CGFloat)lon1
                                andLat2:(CGFloat)lat2
                                andLon2:(CGFloat)lon2 {

  for (GMSPolyline *polyline in self.allPolylinesFromMap) {

    polyline.map = nil;
  }

  [[MOAServerManager sharedServerManager] getDirectionsBetweenLocations:lat1
      andLongtitude:lon1
      latitude2:lat2
      longtitude2:lon2
      onSuccess:^(NSDictionary *routePoints) {

        GMSPath *path = [GMSPath pathFromEncodedPath:routePoints[@"points"]];
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:path];
        singleLine.geodesic = YES;
        singleLine.strokeWidth = 4;
        singleLine.strokeColor = [UIColor orangeColor];
        singleLine.map = mapView_;

        [self.allPolylinesFromMap addObject:singleLine];
        [self.menuTablePopover dismissViewControllerAnimated:YES
                                                  completion:^{

                                                      // NSLog(@"Menu popover
                                                      // controller dismissed");
                                                  }];

      }
      onFailure:^(NSError *error, NSInteger statusCode){
          // NSLog(@"error = %@, code = %li", [error localizedDescription],
          // (long)statusCode);
      }];
}

- (void)ShowAllMarkersOnMap {

  CLLocationCoordinate2D firstLocation =
      ((GMSMarker *)self.allMarkersFromMap.firstObject).position;
  GMSCoordinateBounds *bounds =
      [[GMSCoordinateBounds alloc] initWithCoordinate:firstLocation
                                           coordinate:firstLocation];

  for (GMSMarker *marker in self.allMarkersFromMap) {
    bounds = [bounds includingCoordinate:marker.position];
  }

  [mapView_
      animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds
                                          withEdgeInsets:UIEdgeInsetsMake(
                                                             50, 50, 50, 50)]];
}

- (void)geocodePlaceIDToCoordinates:(NSString *)placeID {

  // Just to be clean
  for (GMSMarker *marker in self.allMarkersFromMap) {

    marker.map = nil;
  }
  [self.allMarkersFromMap removeAllObjects];
  for (GMSMarker *marker in self.systemData) {

    marker.map = nil;
  }

  [[MOAServerManager sharedServerManager] getPlaceCoordinateByID:placeID
      getCoordinates:^(NSArray *placeCoordinatesByID) {

        [self addMarkerToPosition:CLLocationCoordinate2DMake(
                                      [[placeCoordinatesByID objectAtIndex:0]
                                          doubleValue],
                                      [[placeCoordinatesByID objectAtIndex:1]
                                          doubleValue])
                        withTitle:[placeCoordinatesByID objectAtIndex:2]
                         subtitle:[placeCoordinatesByID objectAtIndex:3]
                            onMap:mapView_
                         dragable:NO
                       markerData:@"NA"
                          andIcon:nil
               streetViewPanorama:nil];

        // Providing new user location;
        self.userLocationCoordinate = CLLocationCoordinate2DMake(
            [[placeCoordinatesByID objectAtIndex:0] doubleValue],
            [[placeCoordinatesByID objectAtIndex:1] doubleValue]);

        for (GMSPolyline *polyline in self.allPolylinesFromMap) {

          polyline.map = nil;
        }

        [self getCinemasNearCoordinates:CLLocationCoordinate2DMake(
                                            [[placeCoordinatesByID
                                                objectAtIndex:0] doubleValue],
                                            [[placeCoordinatesByID
                                                objectAtIndex:1] doubleValue])];

      }
      onFailure:^(NSError *error, NSInteger statusCode){
          // NSLog(@"error = %@, code = %li", [error localizedDescription],
          // (long)statusCode);
      }];
}

- (void)addMarkerToPosition:(CLLocationCoordinate2D)position
                  withTitle:(NSString *)title
                   subtitle:(NSString *)snippet
                      onMap:(GMSMapView *)map
                   dragable:(BOOL)isDragable
                 markerData:(id)userData
                    andIcon:(NSString *)iconName
         streetViewPanorama:(GMSPanoramaView *)panorama {

  // Creates a marker in the center of the map.
  GMSMarker *marker = [[GMSMarker alloc] init];
  marker.position = position;
  marker.title = title;
  marker.snippet = snippet;
  marker.map = map;
  marker.appearAnimation = kGMSMarkerAnimationPop;
  marker.draggable = isDragable;
  marker.userData = userData;
  marker.panoramaView = panorama;

  if (iconName) {
    // png
    NSString *imagePath =
        [[NSBundle mainBundle] pathForResource:iconName ofType:@"png"];
    UIImage *myImage = [UIImage imageWithContentsOfFile:imagePath];
    // scaling set to 2.0 makes the image 1/2 the size.
    UIImage *scaledImage =
        [UIImage imageWithCGImage:[myImage CGImage]
                            scale:(myImage.scale * 10.0)
                      orientation:(myImage.imageOrientation)];

    marker.icon = scaledImage;
  } else {

    marker.icon = nil;
  }

  if (!([marker.userData isEqual:@"NA"] || [marker.userData isEqual:@"UL"])) {
    [self.allMarkersFromMap addObject:marker];
    // NSLog(@"All markers count: %li", self.allMarkersFromMap.count);

  } else {

    if ([marker.userData isEqual:@"NA"]) {
      [self.systemData addObject:marker];
    }
  }

  [self ShowAllMarkersOnMap];
}

- (void)addStreetViewPanoramaToPosition:(CLLocationCoordinate2D)position {

  // Just to be clean
  for (UIView *subview in mapView_.subviews) {

    if ([subview isKindOfClass:GMSPanoramaView.class]) {
      [subview removeFromSuperview];
    }
  }
  self.isStreetViewShown = NO;

  GMSPanoramaView *panoramaView = [[GMSPanoramaView alloc]
      initWithFrame:CGRectMake(mapView_.center.x, mapView_.center.y, 400, 300)];

  panoramaView.center = CGPointMake(mapView_.center.x, mapView_.center.y - 201);

  panoramaView.layer.cornerRadius = 25;

  [panoramaView moveNearCoordinate:position];

  [mapView_ addSubview:panoramaView];
  self.isStreetViewShown = YES;
}

- (void)setMapCameraWithLatitude:(CLLocationDegrees)latitude
                   andLongtitude:(CLLocationDegrees)longtitude
                          toZoom:(float)zoom
                           onMap:(GMSMapView *)map {

  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                          longitude:longtitude
                                                               zoom:zoom];
  map.camera = camera;
}

- (void)getCinemasNearCoordinates:(CLLocationCoordinate2D)coordinates {

  [[MOAServerManager sharedServerManager] getPlaces:coordinates.latitude
      andLongtitude:coordinates.longitude
      onSuccess:^(NSArray *places) {

        [self.placesArray removeAllObjects];
        [self.placesArray addObjectsFromArray:places];

        for (NSDictionary *place in self.placesArray) {

          NSString *placeName =
              [NSString stringWithFormat:@"%@", place[@"name"]];
          NSString *placeAdress =
              [NSString stringWithFormat:@"%@", place[@"vicinity"]];
          NSDictionary *placeGeometry = place[@"geometry"];
          NSNumber *placeLAT =
              [[placeGeometry objectForKey:@"location"] objectForKey:@"lat"];
          NSNumber *placeLON =
              [[placeGeometry objectForKey:@"location"] objectForKey:@"lng"];

          NSArray *photos = place[@"photos"];
          NSDictionary *placePictures = [photos firstObject];
          NSString *placePhotoReference = [NSString
              stringWithFormat:@"%@", placePictures[@"photo_reference"]];
          __block UIImage *placeImage;

          [[MOAServerManager sharedServerManager]
              getPlacePictureWithReference:placePhotoReference
              andMaxWidth:400
              andMaxHeigth:248
              getPicture:^(id picture) {
                placeImage = picture;

                [self addMarkerToPosition:CLLocationCoordinate2DMake(
                                              [placeLAT doubleValue],
                                              [placeLON doubleValue])
                                withTitle:placeName
                                 subtitle:placeAdress
                                    onMap:mapView_
                                 dragable:NO
                               markerData:placeImage
                                  andIcon:@"MOAMapIconCut"
                       streetViewPanorama:nil];

              }
              onFailure:^(NSError *error, NSInteger statusCode){
                  // NSLog(@"error = %@, code = %li", [error
                  // localizedDescription], (long)statusCode);

              }];
        }
      }
      onFailure:^(NSError *error, NSInteger statusCode){
          // NSLog(@"error = %@, code = %li", [error localizedDescription],
          // (long)statusCode);

      }];

  // Should change it to adjust map for all visible markers
  [self setMapCameraWithLatitude:coordinates.latitude
                   andLongtitude:coordinates.longitude
                          toZoom:13
                           onMap:mapView_];
}

#pragma mark - Working with controls

- (IBAction)showSearchBarButton:(id)sender {

  [UIView transitionWithView:self.searchBar
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    if (self.searchBar.hidden == YES) {
                      self.searchBar.hidden = NO;
                      [self.searchBar becomeFirstResponder];
                    } else {
                      [self.searchBar resignFirstResponder];
                      self.searchBar.hidden = YES;
                    }
                  }
                  completion:NULL];
}

- (IBAction)showStreetViewFromLocation:(id)sender {

  if (self.isStreetViewShown) {
    // Just to be clean
    for (UIView *subview in mapView_.subviews) {

      if ([subview isKindOfClass:GMSPanoramaView.class]) {
        [subview removeFromSuperview];
      }
    }
    self.isStreetViewShown = NO;
  } else {

    [self addStreetViewPanoramaToPosition:mapView_.selectedMarker.position];
  }
}

- (IBAction)mapTypeChanged:(id)sender {
  if (self.mapTypeSwitcher.selectedSegmentIndex == 0) {
    mapView_.mapType = kGMSTypeNormal;
    self.mapTypeSwitcher.tintColor = [UIColor grayColor];
  } else if (self.mapTypeSwitcher.selectedSegmentIndex == 1) {
    mapView_.mapType = kGMSTypeSatellite;
    self.mapTypeSwitcher.tintColor = [UIColor whiteColor];
  } else if (self.mapTypeSwitcher.selectedSegmentIndex == 2) {
    mapView_.mapType = kGMSTypeHybrid;
    self.mapTypeSwitcher.tintColor = [UIColor whiteColor];
  }
}

- (IBAction)showMenu:(id)sender {

  if (![self.presentedViewController
          isKindOfClass:MOASearchTableViewController.class]) {
    self.menuTablePopover.modalPresentationStyle = UIModalPresentationPopover;
    self.menuTablePopover.popoverPresentationController.sourceView =
        self.menuButton;

    self.menuTablePopover.preferredContentSize = CGSizeMake(300, 900);

    [self.menuTablePopover.popoverPresentationController
        setPermittedArrowDirections:0];

    [self presentViewController:self.menuTablePopover
                       animated:YES
                     completion:nil];

    [self.menuTablePopover provideData:self.allMarkersFromMap];
    self.menuTablePopover.userLocationCoordinate = self.userLocationCoordinate;

    if (self.searchBar.hidden == NO) {
      [self.searchBar resignFirstResponder];
      self.searchBar.hidden = YES;
    }

  } else {
  }
}

#pragma mark - Working with GooglePlaces

- (void)placeAutocomplete:(NSString *)textToAutocomplete {

  GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];

  filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;

  [self.placesClient
      autocompleteQuery:textToAutocomplete
                 bounds:nil
                 filter:filter
               callback:^(NSArray *results, NSError *error) {
                 if (error != nil) {
                   //                   NSLog(@"Autocomplete error %@",
                   //                         [error localizedDescription]);
                   return;
                 }

                 [self.locationSearchMatches removeAllObjects];

                 for (GMSAutocompletePrediction *result in results) {

                   [self.locationSearchMatches addObject:result];
                   [self.searchTablePopover
                       provideData:self.locationSearchMatches];
                 }
               }];
}

#pragma mark - Working with user's location

- (void)askForUserLocationUsage {

  self.locationManager = [[CLLocationManager alloc] init];
  if ([CLLocationManager authorizationStatus] ==
      kCLAuthorizationStatusNotDetermined) {
    NSLog(@"Access to location services not determined, asking for "
          @"permission");
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:
                                   @"NSLocationWhenInUseUsageDescription"] &&
        [self.locationManager
            respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
      [self.locationManager requestWhenInUseAuthorization];
    }
  } else if ([CLLocationManager authorizationStatus] ==
             kCLAuthorizationStatusDenied) {
    NSLog(@"Access to location services denied");
  } else if ([CLLocationManager authorizationStatus] ==
             kCLAuthorizationStatusRestricted) {
    NSLog(@"Access to location services restricted");
  }
  if ([CLLocationManager authorizationStatus] ==
      kCLAuthorizationStatusAuthorizedAlways) {
    NSLog(@"Access to location services always allowed");
  } else if ([CLLocationManager authorizationStatus] ==
             kCLAuthorizationStatusAuthorizedWhenInUse) {
    NSLog(@"Access to location services when in use allowed");
  }
}

@end
