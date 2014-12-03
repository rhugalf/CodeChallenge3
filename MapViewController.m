//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *myLocationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addPinToMap];
    [self setRegion];
    
    self.myLocationManager = [[CLLocationManager alloc] init];
    [self.myLocationManager requestAlwaysAuthorization];
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];

}

-(void) addPinToMap{
       MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
       annotation.title = self.divvyBikesSt.name;
       CLLocationCoordinate2D coord;
       coord.latitude = [self.divvyBikesSt.latitude doubleValue];
       coord.longitude = [self.divvyBikesSt.longitude doubleValue];

       annotation.coordinate = coord;

       [self.mapView addAnnotation:annotation];
    
       [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Locator FAiled %@",error);
}

- (void)setRegion {
    MKCoordinateSpan startingSpan;
    startingSpan.latitudeDelta = 0.05;
    startingSpan.longitudeDelta = 0.05;
    
    CLLocationCoordinate2D startingCenter;
    startingCenter.latitude = [self.divvyBikesSt.latitude doubleValue];
    startingCenter.longitude = [self.divvyBikesSt.longitude doubleValue];
    
    MKCoordinateRegion startingRegion;
    startingRegion.center = startingCenter;
    startingRegion.span = startingSpan;
    
    [self.mapView setRegion:startingRegion animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"bikeImage"];
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CLLocationCoordinate2D center = view.annotation.coordinate;
    
    MKCoordinateSpan span;
    span.longitudeDelta = 0.01;
    span.latitudeDelta = 0.01;
    
    MKCoordinateRegion region;
    region.center = center;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = [NSString stringWithFormat:@"Go to %@", self.divvyBikesSt.name];
    alertView.message = @"Information";
    [alertView addButtonWithTitle:@"Ok"];
    [alertView show];
}

@end
