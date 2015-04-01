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
    
    self.title = @"Add Text";
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView.image = self.editImage;
    if (self.editImage == nil) {
        NSLog(@"Empty");
    }
    self.topTextField.delegate = self;
    self.bottomTextField.delegate = self;
}

-(IBAction)confirmMeme:(id)sender{
    if ([_delegate respondsToSelector:@selector(dataFromTextViewController:)])
    {
        if (imageView.image != nil) {
            NSLog(@"Sent data");
            // Add text to photo and send, Maybe add a "Are you sure?" prompt.
            
            // Get top point and draw top text.
            CGPoint top = CGPointMake(imageView.image.size.width/4, 0);
            imageView.image = [self drawText:self.topTextField.text inImage:imageView.image atPoint:top];
            
            // get bottom point and draw bottom text.
            CGPoint bottom = CGPointMake(imageView.image.size.width/4, imageView.image.size.height - (imageView.image.size.width / self.bottomTextField.text.length));
            imageView.image = [self drawText:self.bottomTextField.text inImage:imageView.image atPoint:bottom];
            
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}



@end