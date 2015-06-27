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

@interface MLManager : NSObject

+ (MLManager *) sharedInstance;

- (void) learn: (UIImage *) templateImage;

- (double) distance: (MSERFeature *) feature;

- (BOOL) isToptalLogo: (MSERFeature *) feature;

@end
