//
//  secondViewAppDelegate.h
//  YouDontSay
//
//  Created by Christopher John Healey on 2015-03-30.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@interface SecondViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window2;
    SecondViewController *tableViewController;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window2;
@property (nonatomic, retain) IBOutlet SecondViewController *tableViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end