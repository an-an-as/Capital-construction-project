//
//  DownArrow.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/13.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "DownArrow.h"
#import "UIView+MiNiFrame.h"

@interface DownArrow ()
@property(nonatomic,assign)int index;
@end

@implementation DownArrow

-(void)drawRect:(CGRect)rect{
    UIBezierPath* path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.w,0)];
    [path addLineToPoint:CGPointMake(self.w*0.5, self.h)];
    [path addLineToPoint:CGPointMake(0, 0)];
  
    UIColor* write=[UIColor whiteColor];
    [write setFill];
    [path fill];
    
    
    UITapGestureRecognizer* tapGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self addGestureRecognizer:tapGesutre];
}

-(void)click:(UITapGestureRecognizer*)tapGesutre{
    self.index=-11;
    if (self.downBtnClick) {
        self.downBtnClick(self.index);
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downPoint) name:@"down" object:nil];
    if (self=[super initWithFrame:frame]) {
        self.x=frame.size.width*0.5-frame.size.width*0.04*0.5;
        self.y=frame.size.height*0.5;
        self.w=frame.size.width*0.04;
        self.h=frame.size.height*0.05;
    }
    return self;
}
-(void)downPoint{
    self.index=-11;
    if (self.downBtnClick) {
        self.downBtnClick(self.index);
    }
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.bounds;
    
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    
    CGFloat widthDelta = MAX(100.0 - bounds.size.width, 0);
    
    CGFloat heightDelta = MAX(100.0 - bounds.size.height, 0);
    
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    
    return CGRectContainsPoint(bounds, point);
}


+(instancetype)loadUpArrowWithFrame:(CGRect)frame{
    DownArrow* view=[[DownArrow alloc]initWithFrame:frame];
   
    return view;
}
//-(void)layoutIfNeeded{
//    [super layoutIfNeeded];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"down" object:nil];
//    NSLog(@"ddddddd");
//}
@end
