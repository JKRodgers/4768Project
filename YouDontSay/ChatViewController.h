//
//  ChatViewController.h
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-26.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define SERVICE_TYPE @"YouDontSay"

@interface ChatViewController : UIViewController <UITextFieldDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate>

@end

