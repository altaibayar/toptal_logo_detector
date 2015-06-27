//
//  FPS.h
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 24/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPS : NSObject

+(int) tick;
+(void) draw: (cv::Mat) rgb;

@end
