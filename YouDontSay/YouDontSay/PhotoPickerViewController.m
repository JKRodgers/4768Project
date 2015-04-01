//
//  PhotoPickerViewController.m
//  YouDontSay
//
//  Created by Christopher John Healey on 2015-03-30.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "ChatViewController.h"

@implementation PhotoPickerViewController

@synthesize imageView,choosePhotoBtn, takePhotoBtn, sendPhotoBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photos";
    self.view.backgroundColor = [UIColor whiteColor];
}

-(IBAction) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if((UIButton *) sender == choosePhotoBtn) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentModalViewController:picker animated:YES];
}

-(IBAction)sendPhoto:(id)sender{
    if ([_delegate respondsToSelector:@selector(dataFromPhotoViewController:)])
    {
        if (imageView.image != nil) {
            NSLog(@"Sent data");
            [_delegate dataFromPhotoViewController:imageView.image];
        }
        else{
            NSLog(@"No photo to send");
        }
    }
    else{
        NSLog(@"No data");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

@end