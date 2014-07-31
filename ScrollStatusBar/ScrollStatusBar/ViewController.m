//
//  ViewController.m
//  ScrollStatusBar
//
//  Created by Zach Orr on 7/2/14.
//  Copyright (c) 2014 Zachary Orr. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *fakeStatusBar;
@end

#define kFakeStatusBarTop 50.0f

@implementation ViewController {
    CGFloat _snapshotLocation;
    CGFloat _oldScrollLocation;
    BOOL _statusBarHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _statusBarHidden = false;
    
    [self setupScrollView];
    [self setupHeaderView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return _statusBarHidden;
}

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.scrollView.alwaysBounceVertical = true;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), 900);
    [self.view addSubview:self.scrollView];
}

- (void)setupHeaderView
{
    if (!self.scrollView) {
        [self setupScrollView];
    }
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), 150)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.headerView.frame];
    [imageView setImage:[UIImage imageNamed:@"monkeyman"]];
    [self.headerView addSubview:imageView];
    [self.scrollView addSubview:self.headerView];
}

- (void)takeScreenshot
{
    _snapshotLocation = self.scrollView.contentOffset.y;
    UIView *statusBarView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:YES];
    
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
    statusBar.clipsToBounds = true;
    [statusBar addSubview:statusBarView];
    self.fakeStatusBar = statusBar;
    
    CGRect oldFrame = self.fakeStatusBar.frame;
    oldFrame.origin.y = _snapshotLocation;
    self.fakeStatusBar.frame = oldFrame;
    
    [self.headerView addSubview:self.fakeStatusBar];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat yDiff = yOffset - _oldScrollLocation;
    
    if (yOffset >= kFakeStatusBarTop && !self.fakeStatusBar && yDiff > 0) {
        [self takeScreenshot];
        _statusBarHidden = true;
        [self setNeedsStatusBarAppearanceUpdate];
    } else if (yOffset < _snapshotLocation && self.fakeStatusBar) {
        _statusBarHidden = false;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.fakeStatusBar removeFromSuperview];
        self.fakeStatusBar = nil;
    }
    _oldScrollLocation = yOffset;
}

@end
