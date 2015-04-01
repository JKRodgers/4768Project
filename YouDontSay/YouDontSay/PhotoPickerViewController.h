//
//  PhotoPickerViewController.h
//  YouDontSay
//
//  Created by Christopher John Healey on 2015-03-30.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TextAddViewController.h"

@protocol ImageDelegate <NSObject>
- (void)dataFromPhotoViewController:(UIImage*) image;
@end
@interface PhotoPickerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MemeImageDelegate> {
    UIImageView * imageView;
    UIButton * choosePhotoBtn;
    UIButton * takePhotoBtn;
    
    id <ImageDelegate> _delegate;
}

@property (nonatomic, strong) id delegate;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * sendPhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *editPhotoBtn;

@property (strong, nonatomic) TextAddViewController *addTextVC;

-(IBAction) getPhoto:(id) sender;
-(IBAction) sendPhoto:(id) sender;
@end