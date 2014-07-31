//
//  ViewController.h
//  ScrollStatusBar
//
//  Created by Zach Orr on 7/2/14.
//  Copyright (c) 2014 Zachary Orr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *headerView;
@end
