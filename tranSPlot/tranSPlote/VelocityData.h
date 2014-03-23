//
//  VelocityData.h
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Position.h"

@interface VelocityData : NSObject

@property (strong, nonatomic) Position * pos;
@property (nonatomic) unsigned k;
@property (nonatomic) double meanVelocity; /* km/h */

- (id)initWithDictionary:(NSDictionary *)data andScale:(unsigned)k;
- (BOOL)isNull;

- (UIColor *)colourFromData;

- (CLLocationCoordinate2D)centreCoordinate;
- (CLLocationCoordinate2D)bottomLeftCoordinate;
- (CLLocationCoordinate2D)bottomRightCoordinate;
- (CLLocationCoordinate2D)topRightCoordinate;
- (CLLocationCoordinate2D)topLeftCoordinate;

- (double)dimension; /* m */

@end
