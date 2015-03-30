//
//  SecondViewController.h
//  YouDontSay
//
//  Created by Joshua Kyle Rodgers on 2015-03-26.
//  Copyright (c) 2015 Joshua Kyle Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TableViewController : UITableViewController
@property (nonatomic, strong) NSArray *photos;
+ (ALAssetsLibrary *)defaultAssetsLibrary;
@end

