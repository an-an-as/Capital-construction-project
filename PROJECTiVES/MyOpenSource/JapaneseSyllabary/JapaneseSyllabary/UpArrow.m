//
//  UpArrow.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/12.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "UpArrow.h"
#import "UIView+MiNiFrame.h"

@interface UpArrow ()

@property(nonatomic,assign)int index;
@end

@implementation UpArrow
-(void)drawRect:(CGRect)rect{
    UIBezierPath* path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.w*0.5, 0)];
    [path addLineToPoint:CGPointMake(0, self.h)];
    [path addLineToPoint:CGPointMake(self.w, self.h)];
    [path addLineToPoint:CGPointMake(self.w*0.5, 0)];
    
    UIColor* upFillColour=[UIColor whiteColor];
    [upFillColour setFill];
    [path fill];
    UITapGestureRecognizer* tapGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self addGestureRecognizer:tapGesutre];
}


-(void)click:(UITapGestureRecognizer*)tapGesutre{
    self.index=-11;
    if (self.upBtnClick) {
        self.upBtnClick(self.index);
    }
}



-(instancetype)initWithFrame:(CGRect)frame{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upPoint) name:@"up" object:nil];
    if (self=[super initWithFrame:frame]) {
        self.x=frame.size.width*0.5-frame.size.width*0.04*0.5;
        self.y=frame.size.height*0.5;
        self.w=frame.size.width*0.04;
        self.h=frame.size.height*0.05;
    }
    return self;
}

-(void)upPoint{
    self.index=-11;
    if (self.upBtnClick) {
        self.upBtnClick(self.index);
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
    UpArrow* view=[[UpArrow alloc]initWithFrame:frame];
    return view;
}
//-(void)layoutIfNeeded{
//    [super layoutIfNeeded];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"up" object:nil];
//    NSLog(@"xxxxx");
//}

@end




