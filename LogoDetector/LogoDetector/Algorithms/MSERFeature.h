//
//  MSERFeature.h
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 14/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSERFeature : NSObject

@property NSInteger numberOfHoles;
@property double convexHullAreaRate;
@property double minRectAreaRate;
@property double skeletLengthRate;
@property double contourAreaRate;

-(double) distace: (MSERFeature *) other;

-(NSString *)description;

-(NSString *)toString;

@end
