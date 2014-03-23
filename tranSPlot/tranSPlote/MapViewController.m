//
//  MapViewController.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "MapViewController.h"
#import "Session.h"
#import "VelocityData.h"
#import "GeodeticUTMConverter.h"

#import "UIColor+String.h"
#import "MKMapView+Zoom.h"

#include "Constants.h"

#define SCROLL_THRESHOLD 50.0 /* m */
#define ZOOM_LEVEL 0.001

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;

@property (strong, nonatomic) NSDateFormatter * df;

@property (strong, nonatomic) NSArray * velocityData; // of Velocitydata

@property (strong, nonatomic) CLLocation * lastBottomLeftCoordinate;

@property (nonatomic) BOOL didGetFirstLocation;

@end

@implementation MapViewController

#warning TODO Corrigir Memory Leak!

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _velocityData = @[];
    
    _df = [[NSDateFormatter alloc] init];
    [_df setDateFormat:@"HH:mm:ss dd/MM/yyyy"];
    
    _didGetFirstLocation = NO;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [self setMapToUserLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/* Mapa começa na posição do usuário e com zoom considerável */

- (void)setMapToUserLocation {
    
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = ZOOM_LEVEL;
    span.longitudeDelta = ZOOM_LEVEL;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    
    NSLog(@"Localização: (%lf, %lf)", region.center.latitude, region.center.longitude);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

- (void)updateOverlay {
    
    CGPoint bottomLeftPoint = CGPointMake(CGRectGetMinX(self.mapView.bounds), CGRectGetMaxY(self.mapView.bounds));
    CGPoint topRightPoint = CGPointMake(CGRectGetMaxX(self.mapView.bounds), CGRectGetMinY(self.mapView.bounds));
    
    CLLocationCoordinate2D bottomLeftCoord = [self.mapView convertPoint:bottomLeftPoint toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D topRightCoord = [self.mapView convertPoint:topRightPoint toCoordinateFromView:self.mapView];
    
    Position * bottomLeftPos = [[Position alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:bottomLeftCoord.latitude longitude:bottomLeftCoord.longitude]];
    Position * topRightPos = [[Position alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:topRightCoord.latitude longitude:topRightCoord.longitude]];
    
    [Session retrieveTrafficDataFromStart:bottomLeftPos
                                      end:topRightPos
                                 andScale:1
                              withSuccess:^(NSArray *data, NSDate *time) {
                                  
                                  self.velocityData = data;
                                  self.lastUpdateLabel.text = [NSString stringWithFormat:@"Última atualização: %@", [_df stringFromDate:time]];
                                  
                                  for (VelocityData * vel in data) {
                                    
                                      if(![vel isNull]) {
                                      
                                          CLLocationCoordinate2D coordinates[4];
                                          
                                          coordinates[0] = [vel topLeftCoordinate];
                                          coordinates[1] = [vel topRightCoordinate];
                                          coordinates[2] = [vel bottomRightCoordinate];
                                          coordinates[3] = [vel bottomLeftCoordinate];
                                          
                                          MKPolygon * overlay = [MKPolygon polygonWithCoordinates:coordinates count:4];
                                          
                                          /* POG */
                                          [overlay setTitle:[[vel colourFromData] toString]];
                                          
                                          [self.mapView addOverlay:overlay];
                                      }
                                  }
                                  
                              } andError:^(NSError *err) {
                                  
                                  ERROR_ALERT(@"Não foi possível obter dados atualizados!");
                              }];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    MKPolygonView * pView = [[MKPolygonView alloc] initWithPolygon:overlay];
   
    UIColor * c = [UIColor fromString:[overlay title]];
    
    [pView setFillColor:c];
    [pView setStrokeColor:c];
    [pView setLineWidth:19.0];
    
    [pView setLineJoin:kCGLineJoinMiter];
    
    return pView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    CGPoint bottomLeftPoint = CGPointMake(CGRectGetMinX(self.mapView.bounds), CGRectGetMaxY(self.mapView.bounds));
    CLLocationCoordinate2D bottomLeftCoord = [self.mapView convertPoint:bottomLeftPoint toCoordinateFromView:self.mapView];
    CLLocation * bottomLeft = [[CLLocation alloc] initWithLatitude:bottomLeftCoord.latitude longitude:bottomLeftCoord.longitude];
    
    /* Calcula nivel de zoom para evitar requisicoes com zoom baixo */
    double zoomLevel = [self.mapView zoomLevel];
    
    if(!_didGetFirstLocation) {
        
        _lastBottomLeftCoordinate = bottomLeft;
        _didGetFirstLocation = YES;
        
        [self updateOverlay];
    }
    
    if([bottomLeft distanceFromLocation:_lastBottomLeftCoordinate] > SCROLL_THRESHOLD && zoomLevel > 14.0) {
        
        _lastBottomLeftCoordinate = [[CLLocation alloc] initWithLatitude:bottomLeftCoord.latitude longitude:bottomLeftCoord.longitude];
        
        [self updateOverlay];
    }
    
    else {
        
        [self.mapView removeOverlays:self.mapView.overlays];
    }
}

@end
