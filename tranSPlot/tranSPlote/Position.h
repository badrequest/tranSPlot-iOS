//
//  Position.h
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Position : NSObject

@property (nonatomic) int x;
@property (nonatomic) int y;

- (id)initWithX:(int)x andY:(int)y;
- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithLocation:(CLLocation *)loc;
- (NSDictionary *)toDictionary;

@end
