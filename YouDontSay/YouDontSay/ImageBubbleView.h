//
//  ImageBubbleView.h
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-30.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBubbleView : UIImageView

@property (strong, nonatomic) UIImage *originalImage;

- (id) initWithImage:(UIImage *) image
              atSize:(CGSize) size;

@end
