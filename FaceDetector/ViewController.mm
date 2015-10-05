//
//  ViewController.m
//  FaceDetector
//
//  Created by Mujtaba Hassanpur on 10/3/15.
//  Copyright © 2015 Mujtaba Hassanpur. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/highgui/cap_ios.h>
using namespace cv;

#import "ViewController.h"

@interface ViewController () {
    BOOL _cameraInitialized;
    CvVideoCamera *_videoCamera;
    CascadeClassifier _faceDetector;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupVideoCamera];
    [self setupFaceDetector];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_videoCamera start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_videoCamera stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupVideoCamera {
    if (_cameraInitialized) {
        // already initialized
        return;
    }
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:self.view];
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    _videoCamera.grayscaleMode = NO;
    _videoCamera.rotateVideo = YES;
    _videoCamera.delegate = self;
}

- (void)setupFaceDetector {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"];
    const char *filePath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    _faceDetector = CascadeClassifier(filePath);
}

#pragma mark - CvVideoCameraDelegate

- (void)processImage:(cv::Mat &)image {
    Mat gray;
    vector<cv::Rect> faces;
    Scalar color = Scalar(0, 255, 0);
    cvtColor(image, gray, COLOR_BGR2GRAY);
    _faceDetector.detectMultiScale(gray, faces, 1.15, 2, 0, cv::Size(30, 30));
    for (int i = 0; i < faces.size(); i++) {
        rectangle(image, faces[i], color, 1);
    }
}

@end
