////////
// This sample is published as part of the blog article at www.toptal.com/blog 
// Visit www.toptal.com/blog and subscribe to our newsletter to read great posts
////////

//
//  GeometryUtil.h
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 21/06/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 This static class provides perspective transformation function
 */
@interface GeometryUtil : NSObject

/*
 Return perspective transformation matrix for given points to square with 
 origin [0,0] and with size (size.width, size.width)
 */
+ (cv::Mat) getPerspectiveMatrix: (cv::Point2f[]) points toSize: (cv::Size2f) size;

/*
 Returns new perspecivly transformed image with given size
 */
+ (cv::Mat) normalizeImage: (cv::Mat *) image withTranformationMatrix: (cv::Mat *) M withSize: (float) size;

@end
