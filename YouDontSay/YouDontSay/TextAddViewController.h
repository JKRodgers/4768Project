//
//  TextAddViewController.h
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-04-01.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol MemeImageDelegate <NSObject>
- (void)dataFromTextViewController:(UIImage*) image;
@end
@interface TextAddViewController : UIViewController <UITextFieldDelegate>{
    id <MemeImageDelegate> _delegate;
}

@property (nonatomic, strong) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *topTextField;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, weak) IBOutlet UIImage *editImage;
@property (nonatomic, retain) IBOutlet UIButton * confirmBtn;

-(IBAction) confirmMeme:(id) sender;
@end