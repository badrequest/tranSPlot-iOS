//
//  MonitorViewController.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "MonitorViewController.h"
#import "VelocityMonitor.h"

#define UPDATE_DELAY 0.3 /* s */

@interface MonitorViewController ()

@property (weak, nonatomic) IBOutlet UILabel * velocityLabel;
@property (weak, nonatomic) IBOutlet UILabel * orientationLabel;
@property (weak, nonatomic) IBOutlet UILabel * gridPositionLabel;

@end

@implementation MonitorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self performSelector:@selector(updateLabels) withObject:nil afterDelay:UPDATE_DELAY];
}

- (void)updateLabels {
    
    VelocityMonitor * monitor = [VelocityMonitor shared];
    
    self.velocityLabel.text = [NSString stringWithFormat:@"Velocidade: %.2lf km/h", [monitor currentVelocity]];
    
    self.orientationLabel.text = [NSString stringWithFormat:@"Orientação: %.0lfº", [monitor currentOrientation]];
    
    Position * p = [monitor currentPosition];
    
    self.gridPositionLabel.text = [NSString stringWithFormat:@"Posição no Grid: (%d, %d)", p.x, p.y];
    
    [self performSelector:@selector(updateLabels) withObject:nil afterDelay:UPDATE_DELAY];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
