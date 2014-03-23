//
//  ViewController.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "ViewController.h"
#import "Session.h"
#import "VelocityMonitor.h"
#import "Network.h"

#include "Constants.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.logoView setFrame:CGRectMake(self.view.frame.size.width/2.0 - self.logoView.frame.size.width/2.0, self.view.frame.size.height/2.0 - self.logoView.frame.size.height/2.0, self.logoView.frame.size.width, self.logoView.frame.size.height)];
    
    [self.activity startAnimating];
    
    /* Forca inicio da conexao */
    [Network shared];
    
    [self performSelector:@selector(beginSession) withObject:nil afterDelay:1.0];
}

- (void)beginSession {
    
    [Session beginSessionWithSuccess:^{
        
        /* Forca inicio do monitoramento */
        [VelocityMonitor shared];
        
        [self animate];
        
    } andError:^(NSError *err) {
        
        [self.activity stopAnimating];
        self.activity.hidden = YES;
        
        ERROR_ALERT(@"Não foi possível registrar seu dispositivo. Está conectado à internet?");
    }];
}

- (void)animate {
    
    [self.activity stopAnimating];
    self.activity.hidden = YES;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         [self.logoView setFrame:CGRectMake(self.view.frame.size.width/2.0 - self.logoView.frame.size.width/2.0, self.view.frame.size.height/5.0 - self.logoView.frame.size.height/2.0, self.logoView.frame.size.width, self.logoView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         
                         static BOOL done = NO;
                         
                         if(finished && !done) {
                         
                             [self performSegueWithIdentifier:@"InitialToMainSegue" sender:self];
                             
                             done = YES;
                         }
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
