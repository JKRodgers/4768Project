//
//  ChatViewController.h
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-26.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PhotoPickerViewController.h"
#import "ViewImageViewController.h"

#define SERVICE_TYPE @"YouDontSay"

@interface ChatViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, ImageDelegate>

@property (strong, nonatomic) ViewImageViewController *viewImageVC;
@end

