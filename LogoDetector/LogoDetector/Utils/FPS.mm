//
//  FPS.m
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 24/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import "FPS.h"
#import <sys/time.h>
#import "ImageUtils.h"

@implementation FPS

static long long last;

+(int) tick
{
    struct timeval t;
    gettimeofday(&t, NULL);
    
    long long now = (((long long) t.tv_sec) * 1000) + (((long long) t.tv_usec) / 1000);
    
    int result = (int)(1000.0 / (now - last));
    last = now;
    
    return result;
}

+(void) draw: (cv::Mat) rgb;
{
    int fps = [FPS tick];
    const char* str_fps = [[NSString stringWithFormat: @"FPS: %d", fps] cStringUsingEncoding: NSUTF8StringEncoding];
    
    cv::putText(rgb, str_fps, cv::Point(10, 20), CV_FONT_HERSHEY_PLAIN, 1.0, RED);
}

@end
