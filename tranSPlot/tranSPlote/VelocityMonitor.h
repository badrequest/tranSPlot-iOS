//
//  VelocityMonitor.h
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/23/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Position.h"

@interface VelocityMonitor : NSObject<CLLocationManagerDelegate>

+ (id)shared;

- (id)init;

- (double)currentVelocity;
- (double)currentOrientation;
- (Position *)currentPosition;

@end
