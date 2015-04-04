//
//  ViewImageViewController.m
//  YouDontSay
//
//  Created by Christopher John Healey on 2015-04-01.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import "ChatViewController.h"
#import "ViewImageViewController.h"

@implementation ViewImageViewController

@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"View Image"; // set title
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView.image = self.viewImage; // set image
    if (self.viewImage == nil) {
        NSLog(@"Empty");
    }
}

// if save button is clicked
-(IBAction)saveImage:(id)sender{
    NSLog(@"Trying to save");
    if (imageView.image != nil) {
        NSLog(@"Saved data");
        //save image to phone
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
    }
    else{
        NSLog(@"No photo to save");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end