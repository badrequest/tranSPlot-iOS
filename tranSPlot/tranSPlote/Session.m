//
//  Session.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "Session.h"
#import "Network.h"
#import "VelocityData.h"

@implementation Session

+ (BOOL)isRegistered {
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    return obj != nil && [obj isKindOfClass:[NSString class]];
}

+ (void)setUID:(NSString *)uid {
    
    [[NSUserDefaults standardUserDefaults] setValue:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)uid {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
}

+ (void)beginSessionWithSuccess:(void (^)(void))s andError:(void (^)(NSError * err))e {
    
    if([self isRegistered]) {
        
        NSLog(@"Dispositivo ja registrado com UID: %@", self.uid);
        s();
        
        return;
    }
    
    NSString * uid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    MKNetworkOperation * op = [[Network shared] requestRegistrationWithUID:uid];
    
    [[Network shared] runOperation:op withSuccess:^(NSDictionary *data) {
       
        [self setUID:uid];
        NSLog(@"Registrou dispositivo com UID: %@", self.uid);
        
        s();
        
    } andError:^(NSError *err) {
        
        e(err);
    }];
}

+ (void)tryToSendVelocity:(double)vel orientation:(double)ort andPosition:(Position *)p {
    
    if([self isRegistered]) {
        
        if(p == nil) {
            
            NSLog(@"Fora do grid...");
            return;
        }
    
        MKNetworkOperation * op = [[Network shared] requestSendDataWithUID:[self uid]
                                                                  position:p
                                                                  velocity:vel
                                                            andOrientation:ort];
        
        [[Network shared] runOperation:op withSuccess:^(NSDictionary *data) {
        
            NSLog(@"Enviou: %.2lf km/h %.2lfº @ (%d, %d)", vel, ort, p.x, p.y);
            
        } andError:^(NSError *err){}];
    }
}

+ (void)retrieveTrafficDataFromStart:(Position *)i end:(Position *)f andScale:(unsigned)k withSuccess:(void (^)(NSArray * data, NSDate * time))s andError:(void (^)(NSError * err))e {
    
    if(i == nil || f == nil) {
        
        NSLog(@"Fora do grid...");
        e(nil);
        return;
    }
    
    MKNetworkOperation * op = [[Network shared] requestTrafficWithInitialPosition:i
                                                                            final:f
                                                                         andScale:k];
    
    [[Network shared] runOperation:op withSuccess:^(NSDictionary *data) {
        
        NSMutableArray * results = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)data[@"data"] count]];
        
        for(NSDictionary * d in data[@"data"]) {
            
            [results addObject:[[VelocityData alloc] initWithDictionary:d andScale:k]];
        }
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        s(results, [df dateFromString:data[@"time"]]);
        
    } andError:^(NSError *err) {
    
        e(err);
    }];
}

@end
