//
//  ImageBubbleView.m
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-30.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import "ImageBubbleView.h"

#define IMAGE_INSETS UIEdgeInsetsMake(13, 13, 13, 21)

#define RIGHT_CONTENT_INSETS UIEdgeInsetsMake(8, 13, 8, 21)
#define LEFT_CONTENT_INSETS UIEdgeInsetsMake(8, 21, 8, 13)
#define RIGHT_CONTENT_OUTSETS UIEdgeInsetsMake(-8, -13, -8, -21)
#define LEFT_CONTENT_OUTSETS UIEdgeInsetsMake(-8, -21, -8, -13)

@interface ImageBubbleView ()

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIImage *backgroundImageNormal;
@property (nonatomic, retain) UIImage *backgroundImageHighlighted;
@property (nonatomic, assign) CGSize imageSize;

@end

@implementation ImageBubbleView

#define TWO_THIRDS_OF_PORTRAIT_WIDTH (320.0f * 0.66f)

- (CGSize)sizeThatFits:(CGSize)size
{
    return self.imageSize;
}

- (id) initWithImage:(UIImage *)image
              atSize:(CGSize)size
{
    if (self = [super init])
    {
        self.image = image;
        self.originalImage = image;
        self.imageSize = size;
        
    }
    
    return self;
}

-(void) didStartSelect
{
    self.backgroundImageView.image = self.backgroundImageHighlighted;
}

-(void) didEndSelect
{
    self.backgroundImageView.image = self.backgroundImageNormal;
}

@end