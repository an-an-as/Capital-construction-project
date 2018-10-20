//
//  WrittingViewController.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/9.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "WrittingViewController.h"
#import "W_ExerciseController.h"
#import "WritingImageModel.h"
#import "W_HomeNavView.h"
#import "W_HeadImageView.h"
#import "W_GustureView.h"
#import "UIView+MiNiFrame.h"
#import "PrefixHeader.pch"
#import "Masonry.h"


@import GoogleMobileAds;
@interface WrittingViewController ()<PushNextControllerDelegate,PushNextControllerWithGustureDelegate,GADInterstitialDelegate>
@property (nonatomic,weak)UIView* homeNavView;
@property (nonatomic,weak)UIView* headImageView;
@property (nonatomic,weak)UIView* gestureView;
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation WrittingViewController

-(void)loadView{
    [super loadView];
   
    W_HomeNavView* homeNavView=[W_HomeNavView loadHomeViewWithFrame:self.view.frame];
    W_HeadImageView* headImageView=[W_HeadImageView headImageView];
    W_GustureView* guesture=[W_GustureView loadGustureView];
    
    self.gestureView=guesture;
    self.headImageView=headImageView;
    self.homeNavView=homeNavView;

    [self.view addSubview:self.homeNavView];
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.gestureView];
    
    headImageView.delegate=self;
    guesture.delegate=self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnclick) name:@"backBtn" object:nil];
    
    self.interstitial = [self createAndLoadInterstitial];

    
    self.view.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:51.0/255 alpha:1.0];
   
    [self.homeNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.11267605633));
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeNavView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.400528169014));
    }];
    
    [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.400528169014));
    }];
    
}
- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:GOOGLE_APP_ID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}
-(void)backBtnclick{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.headImageView layoutIfNeeded];
    [self.homeNavView removeFromSuperview];
    [self.headImageView removeFromSuperview];
    [self.gestureView removeFromSuperview];
    self.homeNavView=nil;
    self.headImageView=nil;
    self.gestureView=nil;
    self.view=nil;
}
-(void)dealloc{
 [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backBtn" object:nil];
}
-(void)pushToNextController{
    W_ExerciseController* w1=[W_ExerciseController new];
    w1.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:w1 animated:YES];
}
-(void)swipeToNextController{
    W_ExerciseController* w1=[W_ExerciseController new];
    w1.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:w1 animated:YES];
}



@end
