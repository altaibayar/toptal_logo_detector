//
//  MLManager.h
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 15/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MSERFeature.h"

/*
 This singleton class wraps object recognition function
 */
@interface MLManager : NSObject

+ (MLManager *) sharedInstance;

/*
 Stores feature from the biggest MSER in the templateImage
 */
- (void) learn: (UIImage *) templateImage;

/*
 Sum of differences between logo feature and given feature
 */
- (double) distance: (MSERFeature *) feature;

/*
 Return boolean if the given feature is near to learned on
 */
- (BOOL) isToptalLogo: (MSERFeature *) feature;

@end
