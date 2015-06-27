//
//  MSERManager.m
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 13/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import "MSERManager.h"
#import "ImageUtils.h"

@implementation MSERManager

+ (MSERManager *) sharedInstance
{
    static MSERManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MSERManager alloc] init];
    });
    
    return instance;
}

cv::MserFeatureDetector mserDetector;

- (instancetype) init
{
    self = [super init];
    
    if(self) 
    {
        /* THESE ARE ALL DEFAULT VALUES */
        int delta = 5;                  //! delta, in the code, it compares (size_{i}-size_{i-delta})/size_{i-delta}
        //int minArea = 5120;            //! (640 * 480 / 60) ... max mser is 1/60 of the whole image
        //int maxArea = 10480;            //! (640 * 480 / 15) ... max mser is 1/15 of the whole image
        int minArea = 60;               //! prune the area which bigger than maxArea
        int maxArea = 14400;            //! prune the area which smaller than minArea
        double maxVariation = 0.25;     //! prune the area have simliar size to its children
        double minDiversity = 0.2;      //! trace back to cut off mser with diversity < min_diversity
        int maxEvolution = 200;         //! for color image, the evolution steps
        double areaThreshold = 1.01;    //! the area threshold to cause re-initialize
        double minMargin = 0.003;       //! ignore too small margin
        int edgeBlurSize = 0;           //! the aperture size for edge blur

        mserDetector = cv::MserFeatureDetector(
                                               delta, minArea, maxArea, 
                                               maxVariation, minDiversity, maxEvolution, 
                                               areaThreshold, minMargin, edgeBlurSize
                                               );        
    }
    
    return self;
}

- (void) detectRegions: (cv::Mat &) gray intoVector: (std::vector<std::vector<cv::Point>> &) vector;
{    
    mserDetector(gray, vector);
}

- (MSERFeature *) extractFeature: (std::vector<cv::Point> *) mser
{
    cv::Mat mserImg = [ImageUtils mserToMat: mser];
    if (mserImg.cols <= 2 || mserImg.rows <= 2) { return nil; }
        
    MSERFeature *result = [[MSERFeature alloc] init];
    cv::RotatedRect minRect = cv::minAreaRect(*mser);
        
    // numer of holes
    result.numberOfHoles = [self numberOfHoles: &mserImg];
    
    // MSER_AREA / CONVEX_HULL_AREA
    std::vector<cv::Point> convexHull;
    cv::convexHull(*mser, convexHull);
    result.convexHullAreaRate = (double)mser->size() / cv::contourArea( convexHull );   
    
    // MSER_AREA / MIN_RECT_AREA
    result.minRectAreaRate = (double)mser->size() / (double) minRect.size.area();
    
    // MSER_SKELET_LENGTH / MSER_AREA
    result.skeletLengthRate = (double)[self skeletLength: &mserImg ] / (double) mser->size();
    
    // MSER_AREA / CONTOUR_AREA
    double contourArea = [self contourArea: &mserImg];
    if (contourArea == 0.0) return nil;
    result.contourAreaRate = (double)mser->size() / contourArea;
    if (result.contourAreaRate > 1.0) return nil;
    
    return result;
}

#pragma mark - helper

// http://felix.abecassis.me/2011/09/opencv-morphological-skeleton/
- (int) skeletLength: (cv::Mat *) mserImg
{
    cv::Mat img;
    mserImg->copyTo(img);
    
    cv::threshold(img, img, 127, 255, cv::THRESH_BINARY); 
    cv::Mat skel(img.size(), CV_8UC1, cv::Scalar(0));
    cv::Mat temp;
    cv::Mat eroded;
    
    cv::Mat element = cv::getStructuringElement(cv::MORPH_CROSS, cv::Size(3, 3));
    bool done;		
    do
    {
        cv::erode(img, eroded, element);
        cv::dilate(eroded, temp, element); // temp = open(img)
        cv::subtract(img, temp, temp);
        cv::bitwise_or(skel, temp, skel);
        eroded.copyTo(img);
        
        done = (cv::countNonZero(img) == 0);
    } while (!done);
    
    return cv::countNonZero(skel);
}

// number of holes are obtained from number of contours
- (int) numberOfHoles: (cv::Mat *) img
{
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(*img, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_NONE);
    
    if (hierarchy.size() == contours.size()) return 1;
    
    int result = 0;
    for (size_t i = 0; i < hierarchy.size(); i++) { 
        if (hierarchy[i][3] != - 1) result++;
    }
    
    return result;
}

- (double) contourArea: (cv::Mat *) img 
{
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
    cv::findContours(*img, contours, hierarchy, cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE);
    
    for (size_t i = 0; i < hierarchy.size(); i++) { 
        if (hierarchy[i][3] == -1) {
            double area = cv::contourArea(contours[i]);
            if (area > 0) return area;
        }
    }
    
    return 0.0;
}

@end
