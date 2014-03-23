//
//  VelocityMonitor.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/23/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "VelocityMonitor.h"
#import "Session.h"

#include "Constants.h"

/* Precisão da localização para ser aceita */
#define ACCURACY 50.0

@interface VelocityMonitor()

@property (nonatomic) double currentVelocity;
@property (nonatomic) double currentOrientation;

@property (strong, nonatomic) Position * currentPosition;

@property (strong, nonatomic) CLLocationManager * manager;

@property (strong, nonatomic) NSDate * lastSent;

@end

@implementation VelocityMonitor

#warning TODO Fazer rodar em background...

/* Singleton */

+ (id)shared {
    
    static VelocityMonitor * shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

/* Construtor */

- (id)init {
    
    if(self = [super init]) {
        
        if(![CLLocationManager locationServicesEnabled]) {
            
            ERROR_ALERT(@"Não foi possível obter sua localização: Serviços de localização desligados!");
        }
           
        else if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            
            ERROR_ALERT(@"Não foi possível obter sua localização: Sem autorização!");
        }
        
        else {
            
            _manager = [[CLLocationManager alloc] init];
            _manager.delegate = self;
            [_manager startUpdatingLocation];
        }
    }
    
    return self;
}

/* Destrutor */

- (void)dealloc {
    
    [_manager stopUpdatingLocation];
}

#warning Não esta checando mudanças de data feitas fora do app durante a execução!

#warning TODO Implementar mecanismo para gerenciar envio de dados de acordo com o \
deslocamento, para evitar enviar muitos dados de congestionamento para a mesma posicao \
quando velocidade for muito baixa.

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation * newLocation = [locations lastObject];
    
    /* Evita enviar muitos dados para o servidor... (ao menos 1 vez a cada 1 segundos) */
    if([[NSDate date] timeIntervalSinceDate:_lastSent] < 1.0) {
        
        return;
    }
    
    /* Rejeita dados muito antigos: De mais de 20 segundos... */
    if([[NSDate date] timeIntervalSinceDate:newLocation.timestamp] > 20.0) {
        
        return;
    }

    if(newLocation.horizontalAccuracy < ACCURACY && newLocation.speed >= 0.0) {
        
        _currentVelocity = newLocation.speed * 3.6;
        
        NSLog(@"Velocidade: %.2lf km/h @ (%.5lf, %.5lf)", _currentVelocity, newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        
        _currentPosition = [[Position alloc] initWithLocation:newLocation];
        _currentOrientation = newLocation.course;
        
        if(_currentPosition != nil && [Session isRegistered]) {
            
            [Session tryToSendVelocity:_currentVelocity
                           orientation:_currentOrientation > 0 ? _currentOrientation:0
                           andPosition:_currentPosition];
            
            _lastSent = [NSDate date];
        }
    }
}

@end
