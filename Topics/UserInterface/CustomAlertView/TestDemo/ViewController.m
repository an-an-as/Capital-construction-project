//
//  ViewController.m
//  TestDemo
//
//  Created by oOPiKACHUoO on 2017/9/9.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "ViewController.h"
#import "CustomAlertView.h"
#import "Constraint.h"
@interface ViewController ()


@end

@implementation ViewController{
    CustomAlertView* view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ACTION" style:UIBarButtonItemStylePlain target:self action:@selector(action)];
    self.view.backgroundColor = [UIColor yellowColor];
}

-(void)action{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    view = [[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, 240, 200)];
    [self.view addSubview:view];
    
    view.lable.text=@"自定义提醒视图";
    [view.button setTitle:@"OK" forState:UIControlStateNormal];
    [view.button addTarget:self action:@selector(btn)   forControlEvents:UIControlEventTouchUpInside];
    [view show];
}
-(void)btn{
    
    self.navigationItem.rightBarButtonItem.enabled=YES;
    [view dismiss];
    
}


@end
