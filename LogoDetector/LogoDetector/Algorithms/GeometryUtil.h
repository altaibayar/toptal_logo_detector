//
//  GeometryUtil.h
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 21/06/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeometryUtil : NSObject

+ (cv::Mat) getAffineMatrix: (cv::Point2f[]) points toSize: (cv::Size2f) size;

+ (cv::Mat) normalizeImage: (cv::Mat *) image withTranformationMatrix: (cv::Mat *) M withSize: (float) size;

@end
