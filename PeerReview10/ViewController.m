//
//  ViewController.m
//  PeerReview10
//
//  Created by Ananta Shahane on 7/12/17.
//  Copyright © 2017 Ananta Shahane. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"
@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapKit;

@property (strong, nonatomic) MKPointAnnotation *Apple;
@property (strong, nonatomic) MKPointAnnotation *Google;
@property (strong, nonatomic) MKPointAnnotation *SquareEnix;
@property (strong, nonatomic) MKPointAnnotation *Current;

@property (weak, nonatomic) IBOutlet UISwitch *Switchin;
@property (nonatomic, assign) BOOL mapMoving;
@property (weak, nonatomic) IBOutlet UIButton *Centre;

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addAnnotations];
    [self setNeedsStatusBarAppearanceUpdate];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapMoving = NO;
    self.mapKit.delegate = self;
    self.Centre.enabled = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Switch:(id)sender {
    [self.locationManager requestWhenInUseAuthorization];
    self.mapMoving = NO;
    if(self.Switchin.isOn)
    {
        self.mapKit.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
        self.Centre.enabled = YES;
    }
    else
    {
        self.mapKit.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
        self.Centre.enabled = NO;
    }
}

- (IBAction)Apple:(id)sender {
    [self viewAnnotation:self.Apple];
}

- (IBAction)SquareEnix:(id)sender {
    [self viewAnnotation:self.SquareEnix];
}

- (IBAction)Google:(id)sender {
    [self viewAnnotation:self.Google];
}

-(void)addAnnotations
{
    self.view.layer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0].CGColor;
    
    self.Apple = [[MKPointAnnotation alloc] init];
    self.Apple.coordinate = CLLocationCoordinate2DMake(37.3319068, -122.0323703);
    self.Apple.title = @"Apple Infinite Loop";
    
    self.SquareEnix = [[MKPointAnnotation alloc] init];
    self.SquareEnix.coordinate = CLLocationCoordinate2DMake(51.5065223, -0.106269);
    self.SquareEnix.title = @"Square Enix London";
    
    self.Google = [[MKPointAnnotation alloc] init];
    self.Google.coordinate = CLLocationCoordinate2DMake(37.4219999,-122.0840575);
    self.Google.title = @"GooglePlex";
    
    self.Current = [[MKPointAnnotation alloc] init];
    self.Current.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.Current.title = @"Me";
    
    [self.mapKit addAnnotations:@[self.Apple, self.SquareEnix, self.Google]];
}

-(void) viewAnnotation:(MKPointAnnotation *)centrePoint
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centrePoint.coordinate, 5000, 5000);
    MKCoordinateRegion adjusted = [self.mapKit regionThatFits:region];
    [self.mapKit setRegion:adjusted animated:YES];
}

-(UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    self.Current.coordinate = locations.lastObject.coordinate;
    if(self.mapMoving == NO)
    {
        [self viewAnnotation: self.Current];
    }
    NSLog(@"\nLocation Manager Working.");
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.mapMoving = YES;
}

- (IBAction)RegionChanged:(id)sender
{
    self.mapMoving = NO;
    [self viewAnnotation:self.Current];
    NSLog(@"Centre: %id", self.mapMoving);
}

@end
