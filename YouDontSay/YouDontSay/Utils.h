//
//  Utils.h
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-30.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (UIImage *) renderAtSize:(const CGSize) size;
- (UIImage *) maskWithImage:(const UIImage *) maskImage;
- (UIImage *) maskWithColor:(UIColor *) color;

@end