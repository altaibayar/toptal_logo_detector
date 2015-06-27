//
//  CameraViewController.m
//  LogoDetector
//
//  Created by altaibayar tseveenbayar on 13/05/15.
//  Copyright (c) 2015 altaibayar tseveenbayar. All rights reserved.
//

#import "CameraViewController.h"
#import <opencv2/highgui/ios.h>

#import "MSERManager.h"
#import "MLManager.h"
#import "ImageUtils.h"
#import "GeometryUtil.h"

#ifdef DEBUG
#import "FPS.h"
#endif

//this two values are dependant on defaultAVCaptureSessionPreset
#define W (480)
#define H (640)

@interface CameraViewController()
{
    CvVideoCamera *camera;
    BOOL started;
}

@end

@implementation CameraViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //UI
    [_btn setTitle: @" " forState: UIControlStateNormal];
    
    //Camera
    camera = [[CvVideoCamera alloc] initWithParentView: _img];
    camera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    camera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    camera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    camera.defaultFPS = 30;
    camera.grayscaleMode = NO;
    camera.delegate = self;
    
    started = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    //[self test];
    [camera start];
}

- (void) test 
{
    UIImage *logo = [UIImage imageNamed: @"toptal logo"];    
    cv::Mat image = [ImageUtils cvMatFromUIImage: logo];

    //get gray image
    cv::Mat gray;
    cvtColor(image, gray, CV_BGRA2GRAY);
    
    //mser with maximum area is
    std::vector<cv::Point> mser = [ImageUtils maxMser: &gray];
    
    //get 4 vertices of the maxMSER minrect
    cv::RotatedRect rect = cv::minAreaRect(mser);    
    cv::Point2f points[4];
    rect.points(points);
    
    //normalize image
    cv::Mat M = [GeometryUtil getAffineMatrix: points toSize: rect.size];
    cv::Mat normalizedImage = [GeometryUtil normalizeImage: &gray withTranformationMatrix: &M withSize: rect.size.width];

    //get maxMser from normalized image
    std::vector<cv::Point> normalizedMser = [ImageUtils maxMser: &normalizedImage];
    
    _img.backgroundColor = [UIColor greenColor];
    _img.contentMode = UIViewContentModeCenter;
    _img.image = [ImageUtils UIImageFromCVMat: normalizedImage];
}

- (IBAction)btn_TouchUp:(id)sender 
{
    started = !started;
}

-(void)processImage:(cv::Mat &)image
{    
    if (!started) { [FPS draw: image]; return; }
    
    cv::Mat gray;
    cvtColor(image, gray, CV_BGRA2GRAY);
    
    std::vector<std::vector<cv::Point>> msers;
    [[MSERManager sharedInstance] detectRegions: gray intoVector: msers];
    if (msers.size() == 0) { return; };
    
    int logoCount = 0;

    std::vector<cv::Point> *bestMser = nil;
    double bestPoint = 10.0;
    
    //std::vector<cv::Point> mser = [ImageUtils maxMser: &gray];
    std::for_each(msers.begin(), msers.end(), [&] (std::vector<cv::Point> &mser) 
    {
        MSERFeature *feature = [[MSERManager sharedInstance] extractFeature: &mser];
    
        if(feature != nil)            
        {
            if([[MLManager sharedInstance] isToptalLogo: feature] )
            {
                double tmp = [[MLManager sharedInstance] distance: feature ];
                if ( bestPoint > tmp ) {
                    bestPoint = tmp;
                    bestMser = &mser;
                }
                
                logoCount ++;
                //[ImageUtils drawMser: &mser intoImage: &image withColor: GREEN];
            }
            else 
            {
                //NSLog(@"%@", [feature toString]);
                //[ImageUtils drawMser: &mser intoImage: &image withColor: RED];
            }
        }
        else 
        {
            //[ImageUtils drawMser: &mser intoImage: &image withColor: BLUE];
        }
    });

    if (bestMser)
    {
        NSLog(@"minDist: %f", bestPoint);
                
        cv::Rect bound = cv::boundingRect(*bestMser);
        cv::rectangle(image, bound, GREEN, 3);
    }
    else 
    {
        cv::rectangle(image, cv::Rect(0, 0, W, H), RED, 3);
    }

#if DEBUG    
    const char* str_fps = [[NSString stringWithFormat: @"MSER: %d / %ld", logoCount, msers.size()] cStringUsingEncoding: NSUTF8StringEncoding];
    cv::putText(image, str_fps, cv::Point(10, H - 10), CV_FONT_HERSHEY_PLAIN, 1.0, RED);
#endif
    
    [FPS draw: image]; 
}

@end
