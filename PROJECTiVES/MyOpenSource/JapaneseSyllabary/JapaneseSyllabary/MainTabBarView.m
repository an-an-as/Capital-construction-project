//
//  MainTabBarView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/27.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "MainTabBarView.h"
#import "UIView+MiNiFrame.h"

@interface MainTabBarView ()
@property (nonatomic,assign)int changeIndex;
@property (nonatomic,weak)UILabel* leftImageView;
@property (nonatomic,weak)UILabel* rightImageView;
//@property (nonatomic,assign)int index;
@end

@implementation MainTabBarView
static int userIndex;
-(void)drawRect:(CGRect)rect{
    UIBezierPath* path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.w, 0)];
    path.lineWidth=0.4;
    UIColor* lineColour=[UIColor whiteColor];
    [lineColour setStroke];
    [path stroke];
   
}

-(UILabel *)leftImageView{
    if (!_leftImageView) {
        UILabel* imageView=[UILabel new];
        [self addSubview:imageView];
        _leftImageView=imageView;
        imageView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        imageView.text=@"はつおんのれんしゅう";
        imageView.textAlignment=NSTextAlignmentCenter;
        imageView.textColor=[UIColor blackColor];
        imageView.font=[UIFont systemFontOfSize:12];
        imageView.layer.borderColor=[UIColor whiteColor].CGColor;
        imageView.layer.borderWidth=0.25;
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer* tapLeft=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick)];
        [imageView addGestureRecognizer:tapLeft];
        
    }
    return _leftImageView;
}
-(UILabel *)rightImageView{
    if (!_rightImageView) {
        UILabel* rightImageView=[UILabel new];
        [self addSubview:rightImageView];
        _rightImageView=rightImageView;
        rightImageView.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:102.0/255.0 alpha:1.0];
        rightImageView.text=@"フォントのもしゃ";
        rightImageView.textColor=[UIColor whiteColor];
        rightImageView.textAlignment=NSTextAlignmentCenter;
        rightImageView.font=[UIFont systemFontOfSize:12];
        rightImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer* tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightClick)];
        [rightImageView addGestureRecognizer:tapRight];
    }
    return _rightImageView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
//        self.leftImageView.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
//        self.leftImageView.text=@"はつおんのれんしゅう";
//        self.leftImageView.textAlignment=NSTextAlignmentCenter;
//        self.leftImageView.textColor=[UIColor blackColor];
//        self.leftImageView.font=[UIFont systemFontOfSize:12];
//        self.leftImageView.layer.borderColor=[UIColor whiteColor].CGColor;
//        self.leftImageView.layer.borderWidth=0.25;
//        self.leftImageView.userInteractionEnabled=YES;
//        UITapGestureRecognizer* tapLeft=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick)];
//        [self.leftImageView addGestureRecognizer:tapLeft];
      
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnclick:) name:@"backBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnclick0:) name:@"backBtn0" object:nil];
  
    if (userIndex==1) {
        [self rightClick];
    }else{
        [self leftClick];
    }
    
    CGFloat leftW=self.w*0.4015625;
    CGFloat leftH=self.h*0.5102040;
    CGFloat leftMargin=(self.w-leftW*2)*0.5;
    CGFloat topMargin=(self.h-leftH)*0.5;
    CGFloat leftX=leftMargin;
    CGFloat leftY=topMargin;
    CGFloat rightW=leftW;
    CGFloat rightH=leftH;
    CGFloat rightX=leftMargin+leftW;
    CGFloat rightY=leftY;
    
    self.leftImageView.frame=CGRectMake(leftX, leftY, leftW, leftH);
    self.rightImageView.frame=CGRectMake(rightX, rightY, rightW, rightH);
}
-(void)backBtnclick:(NSNotification*)notification{
    NSString* str= notification.userInfo[@"index"];
    userIndex=str.intValue;
   
}
-(void)backBtnclick0:(NSNotification*)notification{
    NSString* str= notification.userInfo[@"index"];
    userIndex=str.intValue;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backBtn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backBtn0" object:nil];
}

-(void)leftClick{
    self.rightImageView.layer.borderColor=nil;
    self.rightImageView.layer.borderWidth=0;
    self.leftImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.leftImageView.layer.borderWidth=0.25;
    if (self.changeClick) {
        self.changeClick(0);
    }
}

-(void)rightClick{
    self.leftImageView.layer.borderColor=nil;
    self.leftImageView.layer.borderWidth=0;
    self.rightImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.rightImageView.layer.borderWidth=0.25;
    if (self.changeClick) {
        self.changeClick(1);
    }
}

-(void)layoutIfNeeded{
    [self.leftImageView removeFromSuperview];
    [self.rightImageView removeFromSuperview];
    self.leftImageView=nil;
    self.leftImageView=nil;
}
@end









