//
//  GeometryUtil.m
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 21/06/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import "GeometryUtil.h"

@implementation GeometryUtil

#define PYTHAGOR(p1,p2) (sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y)))

+ (cv::Mat) getAffineMatrix: (cv::Point2f[]) points toSize: (cv::Size2f) size
{
    cv::Point2f dst[] = { 
        cv::Point2f(0, 0), 
        cv::Point2f(size.width, 0), 
        cv::Point2f(size.width, size.width), 
        cv::Point2f(0, size.width) 
    };
    BOOL first = PYTHAGOR(points[0], points[1]) < PYTHAGOR(points[1], points[2]);
    cv::Point2f src[] = {
        first ? points[0] : points[1],
        first ? points[1] : points[2],
        first ? points[2] : points[3],
        first ? points[3] : points[0]
    };
    
    cv::Mat result = cv::getPerspectiveTransform(src, dst);
    return result;
}

+ (cv::Mat) normalizeImage: (cv::Mat *) image withTranformationMatrix: (cv::Mat *) M withSize: (float) size
{
    cv::Mat dst(cv::Size(size, size), image->type());
    cv::warpPerspective(*image, dst, *M, dst.size(), cv::INTER_LINEAR, cv::BORDER_DEFAULT, cv::Scalar(1, 1, 1));

    return dst;
}

@end
