////////
// This sample is published as part of the blog article at www.toptal.com/blog 
// Visit www.toptal.com/blog and subscribe to our newsletter to read great posts
////////

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
 Returns true if the given feature is similar to the one learned from the template
 */
- (BOOL) isToptalLogo: (MSERFeature *) feature;

@end
