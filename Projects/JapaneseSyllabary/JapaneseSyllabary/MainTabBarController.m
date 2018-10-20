//
//  MainTabBarController.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/10.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "MainTabBarController.h"
#import "WrittingViewController.h"
#import "PronunciationViewController.h"
#import "NavgationController.h"
#import "UIView+MiNiFrame.h"
#import "MainTabBarView.h"

@interface MainTabBarController ()
@property(nonatomic,weak)UIView* tabBarView;
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavgationController* writNav=[[NavgationController alloc]initWithRootViewController:[WrittingViewController new]];
    NavgationController* prouncationNav=[[NavgationController alloc]initWithRootViewController:[PronunciationViewController new]];
    self.viewControllers=@[prouncationNav,writNav];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MainTabBarView* tabBarView=[MainTabBarView new];
    tabBarView.frame=self.tabBar.bounds;
    
    self.tabBarView.backgroundColor=[UIColor blackColor];
    self.tabBar.backgroundColor=[UIColor clearColor];
    self.tabBar.layer.shadowOffset=CGSizeMake(0, 2);
    self.tabBar.layer.shadowColor=[UIColor whiteColor].CGColor;
    self.tabBar.layer.shadowRadius=1;
    self.tabBar.layer.shadowOpacity=0.2;
    self.tabBar.alpha=1.0;
    
    self.tabBarView=tabBarView;
    tabBarView.changeClick=^(int index){
        self.selectedIndex=index;
    };
    [self.tabBar addSubview:tabBarView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tabBarView layoutIfNeeded];
    [self.tabBarView layoutIfNeeded];
    [self.tabBarView removeFromSuperview];
    self.tabBarView=nil;
    self.view=nil;
}
@end
