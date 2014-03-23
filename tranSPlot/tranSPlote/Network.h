//
//  Network.h
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "Position.h"

@interface Network : MKNetworkEngine

+ (id)shared;

- (MKNetworkOperation *)requestRegistrationWithUID:(NSString *)uid;
- (MKNetworkOperation *)requestSendDataWithUID:(NSString *)uid position:(Position *)p velocity:(double)vel andOrientation:(double)ort;
- (MKNetworkOperation *)requestTrafficWithInitialPosition:(Position *)i final:(Position *)f andScale:(unsigned)s;

- (void)runOperation:(MKNetworkOperation *)op withSuccess:(void (^)(NSDictionary * data))s andError:(void (^)(NSError * err))e;

@end
