//
//  UIColor+String.h
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (String)

- (NSString *)toString;
+ (UIColor *)fromString:(NSString *)str;

@end
