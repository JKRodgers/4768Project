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
    self.editPhotoBtn.enabled = NO;
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

- (IBAction)editButtonTapped:(id)sender; {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.addTextVC = [storyboard instantiateViewControllerWithIdentifier:@"TextAddViewController"];
    self.addTextVC.delegate = self;
    
    self.addTextVC.editImage = imageView.image;
    
    [self.navigationController pushViewController:self.addTextVC animated:YES];
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
    if (imageView.image != nil) {
        self.editPhotoBtn.enabled = YES;
    }
}

- (void)dataFromTextViewController:(UIImage *)image{
    //Recieve Image back from TextAddViewController and set it to the imageView.
    self.imageView.image = image;
}

@end