//
//  UIColor+String.m
//  tranSPlot
//
//  Created by Fabio Dela Antonio on 3/22/14.
//  Copyright (c) 2014 Bad Request. All rights reserved.
//

#import "UIColor+String.h"

@implementation UIColor (String)

- (NSString *)toString {
    
    CGColorRef colorRef = self.CGColor;
    return [CIColor colorWithCGColor:colorRef].stringRepresentation;
}

+ (UIColor *)fromString:(NSString *)str {

    return [UIColor colorWithCIColor:[CIColor colorWithString:str]];
}

@end
