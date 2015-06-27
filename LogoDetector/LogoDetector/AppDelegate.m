//
//  AppDelegate.m
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 13/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import "AppDelegate.h"

#import "MLManager.h"

#define FIRST_START_KEY @"FIRST_START"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    if (true || [self isFirstStart])
    {   
        [[MLManager sharedInstance] learn: [UIImage imageNamed: @"toptal logo"]];        
        [self setFirstStartFlag];
    }
    
    return YES;
}

#pragma mark - first start 

- (BOOL) isFirstStart
{
#if DEBUG
    return YES;
#else    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    return [defaults objectForKey: FIRST_START_KEY] != nil;
#endif
}

- (void) setFirstStartFlag
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: @":)" forKey: FIRST_START_KEY];
    [defaults synchronize];
}

@end
