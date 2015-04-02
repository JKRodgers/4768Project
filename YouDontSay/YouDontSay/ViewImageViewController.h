//
//  ViewImageViewController.h
//  YouDontSay
//
//  Created by Christopher John Healey on 2015-04-01.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
}

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, weak) IBOutlet UIImage *viewImage;
@property (nonatomic, retain) IBOutlet UIButton * saveBtn;

-(IBAction) saveImage:(id) sender;
@end