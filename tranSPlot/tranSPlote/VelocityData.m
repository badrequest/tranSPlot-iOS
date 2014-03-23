//
//  VelocityData.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "VelocityData.h"
#import "GeodeticUTMConverter.h"

#include "Constants.h"

@implementation VelocityData

- (id)initWithDictionary:(NSDictionary *)data andScale:(unsigned)k {
    
    if(self = [super init]) {
        
        _pos = [[Position alloc] initWithDictionary:data[@"position"]];
        _meanVelocity = [(NSNumber *)data[@"meanVelocity"] doubleValue];
        _k = k;
    }
    
    return self;
}

- (BOOL)isNull {
    
    return _meanVelocity < 0;
}

- (UIColor *)colourFromData {
    
    if([self isNull]) {
        
        return [UIColor clearColor];
    }
    
    CGFloat hue = (_meanVelocity > 100.0) ? (100.0/360.0):(_meanVelocity/360.0);
    
    return [[UIColor alloc] initWithHue:hue saturation:1.0 brightness:1.0 alpha:0.5];
}

- (CLLocationCoordinate2D)centreCoordinate {
    
    double deltaX = self.dimension * (double)_pos.x;
    double deltaY = self.dimension * (double)_pos.y;
    
    UTMCoordinates utm = [GeodeticUTMConverter latitudeAndLongitudeToUTMCoordinates:CLLocationCoordinate2DMake(COORD_I_Y, COORD_I_X)];
    
    utm.easting += deltaX + self.dimension/2.0;
    utm.northing += deltaY + self.dimension/2.0;
    
    return [GeodeticUTMConverter UTMCoordinatesToLatitudeAndLongitude:utm];
}

- (CLLocationCoordinate2D)bottomLeftCoordinate {
    
    double deltaX = self.dimension * (double)_pos.x;
    double deltaY = self.dimension * (double)_pos.y;
    
    UTMCoordinates utm = [GeodeticUTMConverter latitudeAndLongitudeToUTMCoordinates:CLLocationCoordinate2DMake(COORD_I_Y, COORD_I_X)];
    
    utm.easting += deltaX;
    utm.northing += deltaY;
    
    return [GeodeticUTMConverter UTMCoordinatesToLatitudeAndLongitude:utm];
}

- (CLLocationCoordinate2D)bottomRightCoordinate {
    
    double deltaX = self.dimension * (double)_pos.x;
    double deltaY = self.dimension * (double)_pos.y;
    
    UTMCoordinates utm = [GeodeticUTMConverter latitudeAndLongitudeToUTMCoordinates:CLLocationCoordinate2DMake(COORD_I_Y, COORD_I_X)];
    
    utm.easting += deltaX + self.dimension/2.0;
    utm.northing += deltaY;
    
    return [GeodeticUTMConverter UTMCoordinatesToLatitudeAndLongitude:utm];
}

- (CLLocationCoordinate2D)topRightCoordinate {
    
    double deltaX = self.dimension * (double)_pos.x;
    double deltaY = self.dimension * (double)_pos.y;
    
    UTMCoordinates utm = [GeodeticUTMConverter latitudeAndLongitudeToUTMCoordinates:CLLocationCoordinate2DMake(COORD_I_Y, COORD_I_X)];
    
    utm.easting += deltaX + self.dimension/2.0;
    utm.northing += deltaY + self.dimension/2.0;
    
    return [GeodeticUTMConverter UTMCoordinatesToLatitudeAndLongitude:utm];
}

- (CLLocationCoordinate2D)topLeftCoordinate {
    
    double deltaX = self.dimension * (double)_pos.x;
    double deltaY = self.dimension * (double)_pos.y;
    
    UTMCoordinates utm = [GeodeticUTMConverter latitudeAndLongitudeToUTMCoordinates:CLLocationCoordinate2DMake(COORD_I_Y, COORD_I_X)];
    
    utm.easting += deltaX;
    utm.northing += deltaY + self.dimension/2.0;
    
    return [GeodeticUTMConverter UTMCoordinatesToLatitudeAndLongitude:utm];
}

- (double)dimension {
    
    return _k * BLOCK_SIZE;
}

@end
