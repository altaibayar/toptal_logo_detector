//
//  MLManager.m
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 15/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import "MLManager.h"
#import "ImageUtils.h"
#import <opencv2/highgui/ios.h>
#import "MSERManager.h"
#import "GeometryUtil.h"

#define KEY_NUMBER_OF_HOLES @"KEY_NUMBER_OF_HOLES"
#define KEY_CONVEX_AREA_RATE @"KEY_CONVEX_AREA_RATE"
#define KEY_MIN_RECT_AREA_RATE @"KEY_MIN_RECT_AREA_RATE"
#define KEY_SKELET_LENGTH_RATE @"KEY_SKELET_LENGTH_RATE"
#define KEY_CONTOUR_AREA_RATE @"KEY_CONTOUR_AREA_RATE"

#define AVERAGE 0.113544
#define STDEV 0.063218

@interface MLManager()

@property MSERFeature *logoTemplate;

@end

@implementation MLManager

+ (MLManager *) sharedInstance
{
    static MLManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MLManager alloc] init];        
        [instance loadTemplate];
    });
    
    return instance;
}

- (void) learn: (UIImage *) templateImage;
{
    cv::Mat logo = [ImageUtils cvMatFromUIImage: templateImage];
    
    //get gray image
    cv::Mat gray;
    cvtColor(logo, gray, CV_BGRA2GRAY);
    
    //mser with maximum area is 
    std::vector<cv::Point> maxMser = [ImageUtils maxMser: &gray];

    //get 4 vertices of the maxMSER minrect
    cv::RotatedRect rect = cv::minAreaRect(maxMser);    
    cv::Point2f points[4];
    rect.points(points);

    //normalize image
    cv::Mat M = [GeometryUtil getAffineMatrix: points toSize: rect.size];
    cv::Mat normalizedImage = [GeometryUtil normalizeImage: &gray withTranformationMatrix: &M withSize: rect.size.width];

    //get maxMser from normalized image
    std::vector<cv::Point> normalizedMser = [ImageUtils maxMser: &normalizedImage];
    
    //remember the template
    self.logoTemplate = [[MSERManager sharedInstance] extractFeature: &normalizedMser];
    
    //store the feature
    [self storeTemplate];
}

- (double) distance: (MSERFeature *) feature
{
    return [self.logoTemplate distace: feature];
}

- (BOOL) isToptalLogo: (MSERFeature *) feature;
{
    if (_logoTemplate.numberOfHoles != feature.numberOfHoles) { 
        return NO; 
    }
    
    if ( fabs(_logoTemplate.convexHullAreaRate - feature.convexHullAreaRate) > 0.05) { // 0.1) {
        //NSLog(@"convexHullAreaRate \t\t\t\t %f", fabs(_logoTemplate.convexHullAreaRate - feature.convexHullAreaRate));
        return NO;
    }
    if ( fabs(_logoTemplate.minRectAreaRate - feature.minRectAreaRate) > 0.05) { // 0.1) {
        //NSLog(@"minRectAreaRate \t\t\t\t %f", fabs(_logoTemplate.minRectAreaRate - feature.minRectAreaRate));
        return NO;
    }
    if ( fabs(_logoTemplate.skeletLengthRate - feature.skeletLengthRate) > 0.02) {
        //NSLog(@"skeletLengthRate \t\t\t\t %f", fabs(_logoTemplate.skeletLengthRate - feature.skeletLengthRate));
        return NO;
    }
    if ( fabs(_logoTemplate.contourAreaRate - feature.contourAreaRate) > 0.1) {//0.2) {
        //NSLog(@"contourAreaRate \t\t\t\t %f", fabs(_logoTemplate.contourAreaRate - feature.contourAreaRate));
        return NO;
    }

//    NSLog(@"------------------------------------------");
//    NSLog(@"%@", [_logoTemplate description]);
//    NSLog(@"%@", [feature description]);
//    NSLog(@"%@", [feature toString]);
//    NSLog(@"%f \t %f \t %f \t %f", 
//          fabs(_logoTemplate.convexHullAreaRate - feature.convexHullAreaRate),
//          fabs(_logoTemplate.minRectAreaRate - feature.minRectAreaRate),
//          fabs(_logoTemplate.skeletLengthRate - feature.skeletLengthRate),
//          fabs(_logoTemplate.contourAreaRate - feature.contourAreaRate)
//          );
    
    return YES;
}

#pragma mark - helper

- (void) loadTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _logoTemplate = [[MSERFeature alloc] init];
    
    _logoTemplate.numberOfHoles = [defaults integerForKey: KEY_NUMBER_OF_HOLES];
    _logoTemplate.convexHullAreaRate = [defaults doubleForKey: KEY_CONVEX_AREA_RATE];
    _logoTemplate.minRectAreaRate = [defaults doubleForKey: KEY_MIN_RECT_AREA_RATE];
    _logoTemplate.skeletLengthRate = [defaults doubleForKey: KEY_SKELET_LENGTH_RATE];
    _logoTemplate.contourAreaRate = [defaults doubleForKey: KEY_CONTOUR_AREA_RATE];
}

- (void) storeTemplate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    [defaults setInteger: _logoTemplate.numberOfHoles forKey: KEY_NUMBER_OF_HOLES];
    [defaults setDouble: _logoTemplate.convexHullAreaRate forKey: KEY_CONVEX_AREA_RATE];
    [defaults setDouble: _logoTemplate.minRectAreaRate forKey: KEY_MIN_RECT_AREA_RATE];
    [defaults setDouble: _logoTemplate.skeletLengthRate forKey: KEY_SKELET_LENGTH_RATE];
    [defaults setDouble: _logoTemplate.contourAreaRate forKey: KEY_CONTOUR_AREA_RATE];
    
    [defaults synchronize];
}

@end
