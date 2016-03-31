//
//  ViewController.m
//  WheresHere
//
//  Created by Ricky Kirkendall on 3/29/16.
//  Copyright © 2016 CodeLab. All rights reserved.
//


// Sources:

// For getting current location: http://stackoverflow.com/questions/4152003/how-can-i-get-current-location-from-user-in-ios

// For debugging location services: http://stackoverflow.com/questions/24062509/location-services-not-working-in-ios-8

// For zooming in to map region: http://stackoverflow.com/questions/2473706/how-do-i-zoom-an-mkmapview-to-the-users-current-location-without-cllocationmanag

// For displayling user location: http://stackoverflow.com/questions/2443342/how-to-display-user-location-in-mapkit


#import "ViewController.h"

@interface ViewController ()
//@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add NSLocationWhenInUseUsageDescription key to Info.plist
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        // Will open an confirm dialog to get user's approval
        [self.locationManager requestWhenInUseAuthorization];
        //[_locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager requestLocation]; //Will update location immediately
    }
    self.mapView.showsUserLocation = YES;
    
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"Not determined");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"Permission denied.");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.locationManager requestLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = [locations lastObject];
    MKCoordinateRegion region;
    region.center = newLocation.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta  = 10; // Change these values to change the zoom
    span.longitudeDelta = 10;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    
    self.label.text = [NSString stringWithFormat:@"%.03f, %.03f",newLocation.coordinate.latitude, newLocation.coordinate.longitude];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error{
    NSLog(@"Error: %@",error);
}


@end
