//
//  ImageBubbleView.h
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-30.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBubbleView : UIView

typedef enum
{
    ViewRight = 0,
    ViewLeft = 1
} ViewDirection;

@property (nonatomic, assign) UIImage *image;

- (id) initWithImage:(UIImage *) image
       withDirection:(ViewDirection) direction
              atSize:(CGSize) size;

@end
