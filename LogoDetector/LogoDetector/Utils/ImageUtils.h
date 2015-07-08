////////
// This sample is published as part of the blog article at www.toptal.com/blog 
// Visit www.toptal.com/blog and subscribe to our newsletter to read great posts
////////

//
//  ImageUtils.h
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 15/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <opencv2/opencv.hpp>

@interface ImageUtils : NSObject

extern const cv::Scalar RED;
extern const cv::Scalar GREEN;
extern const cv::Scalar BLUE;
extern const cv::Scalar BLACK;
extern const cv::Scalar WHITE;
extern const cv::Scalar YELLOW;
extern const cv::Scalar LIGHT_GRAY;

+ (cv::Mat) cvMatFromUIImage: (UIImage *) image;
+ (cv::Mat) cvMatGrayFromUIImage: (UIImage *)image;

+ (UIImage *) UIImageFromCVMat: (cv::Mat)cvMat;

+ (cv::Mat) mserToMat: (std::vector<cv::Point> *) mser;

+ (void) drawMser: (std::vector<cv::Point> *) mser intoImage: (cv::Mat *) image withColor: (cv::Scalar) color;

+ (std::vector<cv::Point>) maxMser: (cv::Mat *) gray;

@end
