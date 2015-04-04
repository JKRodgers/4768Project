//
//  TextAddViewController.m
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-04-01.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import "PhotoPickerViewController.h"


@implementation TextAddViewController

@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Add Text"; // set Title
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView.image = self.editImage; // set image
    self.topLabel.text = nil; // set default to no text
    self.bottomLabel.text = nil; // set default to no text
    if (self.editImage == nil) {
        NSLog(@"Empty");
    }
}

// edit bottom button and get text from user
- (IBAction)editBottomButtonTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Text"
                                                    message:@"Enter Text Bottom:"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    alert.tag = 2;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

// edit top button and get text from user
- (IBAction)editTopButtonTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Text"
                                                message:@"Enter Text Top:"
                                                delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    alert.tag = 1;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
}

// check alerts to respond to
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) { // edit top and change label
        if (buttonIndex == 1) { // OK selected
            self.topLabel.text = [alertView textFieldAtIndex:0].text;
        }
    }
    else if( alertView.tag == 2){ // edit bottom and change label
        if (buttonIndex == 1) { // OK selected
            self.bottomLabel.text = [alertView textFieldAtIndex:0].text;

        }
    }
    else if( alertView.tag == 3){ // confirm alert
        if (buttonIndex == 1) { // Yes selected
            if ([_delegate respondsToSelector:@selector(dataFromTextViewController:)])
            {
                if (imageView.image != nil) {
                    NSLog(@"Sending to PhotoPicker");
                    // Add text to photo and send, Maybe add a "Are you sure?" prompt.
                    
                    // Get top point and draw top text.
                    CGPoint top = CGPointMake(imageView.image.size.width/4, 0);
                    imageView.image = [self drawText:self.topLabel.text inImage:imageView.image atPoint:top];
                    
                    // get bottom point and draw bottom text.
                    CGPoint bottom = CGPointMake(imageView.image.size.width/4, imageView.image.size.height - (imageView.image.size.width / self.bottomLabel.text.length));
                    imageView.image = [self drawText:self.bottomLabel.text inImage:imageView.image atPoint:bottom];
                    
                    [_delegate dataFromTextViewController:imageView.image];
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
    }
}

// confirm button tapped
-(IBAction)confirmMeme:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Photo"
                                                    message: @"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    alert.tag = 3;
    [alert addButtonWithTitle:@"Yes"];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}


// add text to the image given
-(UIImage *) drawText:(NSString *) text
                inImage:(UIImage *) image
                atPoint:(CGPoint) point
{
    float fs = (image.size.width/text.length);
    UIFont *font = [UIFont boldSystemFontOfSize:fs];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end