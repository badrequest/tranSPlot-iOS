//
//  MKMapView+Zoom.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/23/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "MKMapView+Zoom.h"

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@implementation MKMapView (Zoom)

- (double)zoomLevel {
    
    CLLocationDegrees longitudeDelta = self.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = self.bounds.size.width;
    
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    
    double zoomer = MAX_GOOGLE_LEVELS - log2(zoomScale);

    return zoomer < 0 ? 0:zoomer;
}

@end
