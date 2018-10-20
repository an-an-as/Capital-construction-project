//
//  LeftArrow.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/13.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "LeftArrow.h"
#import "UIView+MiNiFrame.h"

@interface LeftArrow ()
@property(nonatomic,assign)int index;
@end

@implementation LeftArrow
-(void)drawRect:(CGRect)rect{
    UIBezierPath* path=[UIBezierPath new];
    [path moveToPoint:CGPointMake(0, self.h*0.5)];
    [path addLineToPoint:CGPointMake(self.w, 0)];
    [path addLineToPoint:CGPointMake(self.w, self.h)];
    [path addLineToPoint:CGPointMake(0, self.h*0.5)];
    
    UIColor* writeColour=[UIColor whiteColor];
    [writeColour setFill];
    [path fill];
    
    UITapGestureRecognizer* tapGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self addGestureRecognizer:tapGesutre];
}

-(void)click:(UITapGestureRecognizer*)tapGesutre{
    self.index=-1;
    if (self.leftBtnClick) {
        self.leftBtnClick(self.index);
    }
}
-(instancetype)initWithFrame:(CGRect)frame{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftPoint) name:@"left" object:nil];
    if (self=[super initWithFrame:frame]) {
        self.x=frame.size.width*0.5;
        self.y=frame.size.height*0.5-frame.size.height*0.04*0.5;
        self.w=frame.size.width*0.05;
        self.h=frame.size.height*0.04;
    }
    return self;
}
-(void)leftPoint{
    self.index=-1;
    if (self.leftBtnClick) {
        self.leftBtnClick(self.index);
    }
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(100.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(100.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
    
}


+(instancetype)loadUpArrowWithFrame:(CGRect)frame{
    LeftArrow* view=[[LeftArrow alloc]initWithFrame:frame];
  
    return view;
}
//-(void)layoutIfNeeded{
//    [super layoutIfNeeded];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"left" object:nil];
//    NSLog(@"llllllll");
//}

@end
