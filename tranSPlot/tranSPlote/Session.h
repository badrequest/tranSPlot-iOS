//
//  Session.h
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"

@interface Session : NSObject

+ (BOOL)isRegistered;
+ (NSString *)uid;
+ (void)beginSessionWithSuccess:(void (^)(void))s andError:(void (^)(NSError * err))e;
+ (void)tryToSendVelocity:(double)vel orientation:(double)ort andPosition:(Position *)p;
+ (void)retrieveTrafficDataFromStart:(Position *)i end:(Position *)f andScale:(unsigned)k withSuccess:(void (^)(NSArray * data, NSDate * time))s andError:(void (^)(NSError * err))e;

@end
