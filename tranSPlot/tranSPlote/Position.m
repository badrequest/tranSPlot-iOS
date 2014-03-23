//
//  Position.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "Position.h"
#import "GeodeticUTMConverter.h"
#include "Constants.h"

@implementation Position

- (id)initWithX:(int)x andY:(int)y {
    
    if(self = [super init]) {
        
        _x = x;
        _y = y;
        
        if(_x < 0 || _y < 0) {
            
            return nil;
        }
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    
    if(self = [super init]) {
        
        _x = [(NSNumber *)dict[@"x"] intValue];
        _y = [(NSNumber *)dict[@"y"] intValue];
        
        if(_x < 0 || _y < 0) {
            
            return nil;
        }
    }
    
    return self;
}

- (id)initWithLocation:(CLLocation *)loc {
    
    if(self = [super init]) {
        
        CLLocationCoordinate2D coord = [loc coordinate];
        
        if(coord.longitude > COORD_F_X || coord.longitude < COORD_I_X) {
            
            return nil;
        }
        
        if(coord.latitude > COORD_F_Y || coord.latitude < COORD_I_Y) {
            
            return nil;
        }
        
        UTMCoordinates origin = [GeodeticUTMConverter latitudeAndLongitudeToUTMCoordinates:CLLocationCoordinate2DMake(COORD_I_Y, COORD_I_X)];
        UTMCoordinates current = [GeodeticUTMConverter latitudeAndLongitudeToUTMCoordinates:coord];
        
        _x = (int)floor(fabs(current.easting - origin.easting)/(double)BLOCK_SIZE);
        _y = (int)floor(fabs(current.northing - origin.northing)/(double)BLOCK_SIZE);
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    
    return @{ @"x":[NSNumber numberWithInt:self.x], @"y":[NSNumber numberWithInt:self.y] };
}

@end
