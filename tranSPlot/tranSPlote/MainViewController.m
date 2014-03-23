//
//  MainViewController.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "MainViewController.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MapKit/MapKit.h>

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextView *twitterFeed;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *monitorButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIImageView *twitterIcon;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView * viewOverMap;

@end

@implementation MainViewController

- (void)getInfo {
    
    // Request access to the Twitter accounts
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            // Check if the users has setup at least one Twitter account
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                // Creating a request to get the info about a user on Twitter
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:@"@CETSP_" forKey:@"screen_name"]];
                
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Check if we reached the reate limit
                        if ([urlResponse statusCode] == 429) {
                        
                            NSLog(@"Rate limit reached");
                            return;
                        }
                        
                        // Check if there was an error
                        if (error) {
                            
                            NSLog(@"Error: %@", error.localizedDescription);
                            return;
                        }
                        
                        // Check if there is some response data
                        if (responseData) {
                            
                            NSError *error = nil;
                            NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                            
                            // Update the interface with the loaded data
                            NSString *lastTweet = [[(NSDictionary *)TWData objectForKey:@"status"] objectForKey:@"text"];
                            
                            if(error == nil) {
                                
                                self.twitterFeed.text = lastTweet;
                            }
                            
                            else {
                                
                                self.twitterFeed.text = @"Não foi possível obter as últimas notícias...";
                            }
                        }
                    });
                }];
            }
        }
        
        else {
            
            NSLog(@"No access granted");
            
            self.twitterFeed.text = @"Não foi possível obter as últimas notícias...";
            self.twitterFeed.textColor = [UIColor colorWithRed:0.812 green:0.169 blue:0.184 alpha:1.0];
        }
    }];
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self getInfo];
    
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial)
                                   context:nil];
    
    /* Parallax */
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                        type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                          type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);

    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.mapView addMotionEffect:group];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    [self makeVisible];
    [UIView commitAnimations];
}

- (void)makeVisible {
    
    [self.mapButton setAlpha:1.0];
    [self.monitorButton setAlpha:1.0];
    [self.aboutButton setAlpha:1.0];
    [self.twitterFeed setAlpha:0.7];
    [self.mapView setAlpha:0.7];
    [self.viewOverMap setAlpha:0.6];
    [self.twitterIcon setAlpha:1.0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 0.05;
    span.longitudeDelta = 0.05;
    region.span = span;
    
    [self.mapView setRegion:region animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}

@end
