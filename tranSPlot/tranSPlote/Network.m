//
//  Network.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "Network.h"
#include "Constants.h"

@implementation Network

/* Singleton */

+ (id)shared {
    
    static Network * shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (id)init {
    
    return self = [super initWithHostName:WEB_SERVICE_SERVER];
}

/* Requisicoes ao servidor */

- (MKNetworkOperation *)requestRegistrationWithUID:(NSString *)uid {
    
    NSDictionary * data = @{ @"uid": uid, @"os": @"ios" };
    
    MKNetworkOperation * ret = [self operationWithPath:@"registrar"
                                                params:data
                                            httpMethod:@"POST"];
    
    [ret setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    return ret;
}

- (MKNetworkOperation *)requestSendDataWithUID:(NSString *)uid position:(Position *)p velocity:(double)vel andOrientation:(double)ort {
    
    NSDictionary * data = @{
                            @"os": @"ios",
                            @"uid": uid,
                            @"velocity": [NSNumber numberWithDouble:vel],
                            @"orientation": [NSNumber numberWithDouble:ort],
                            @"position": [p toDictionary]
                          };
    
    MKNetworkOperation * ret = [self operationWithPath:@"traffic/send"
                                                params:data
                                            httpMethod:@"POST"];
    
    [ret setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    return ret;
}

- (MKNetworkOperation *)requestTrafficWithInitialPosition:(Position *)i final:(Position *)f andScale:(unsigned)s {
    
    NSDictionary * data = @{
                            @"i": [i toDictionary],
                            @"f": [f toDictionary],
                            @"scale": [NSNumber numberWithUnsignedInt:s]
                          };
    
    MKNetworkOperation * ret = [self operationWithPath:@"traffic/status"
                                                params:data
                                            httpMethod:@"POST"];
    
    [ret setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    
    return ret;
}

/* Metodo auxiliar */

- (void)runOperation:(MKNetworkOperation *)op withSuccess:(void (^)(NSDictionary * data))s andError:(void (^)(NSError * err))e {
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        if(completedOperation.responseJSON != nil && [completedOperation.responseJSON isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary * resp = (NSDictionary *)completedOperation.responseJSON;
            
            if([resp[@"ans"] isEqualToString:@"ok"]) {
                
                s(resp);
            }
            
            else {
                
                e([NSError new]);
            }
        }
        
        else {
            
            e([NSError new]);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        e(error);
    }];
    
    [self enqueueOperation:op];
}

@end
