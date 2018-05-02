//
//  RightArrow.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/13.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "RightArrow.h"
#import "UIView+MiNiFrame.h"

@interface RightArrow ()
@property(nonatomic,assign)int index;
@end

@implementation RightArrow
-(void)drawRect:(CGRect)rect{
    UIBezierPath* path=[UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.w, self.h*0.5)];
    [path addLineToPoint:CGPointMake(0, self.h)];
    [path addLineToPoint:CGPointMake(0, 0)];
    

    UIColor* writeColour=[UIColor whiteColor];
    [writeColour setFill];
    [path fill];
    
    UIColor* upFillColour=[UIColor whiteColor];
    [upFillColour setFill];
    [path fill];
   
    UITapGestureRecognizer* tapGesutre=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self addGestureRecognizer:tapGesutre];
}

-(void)click:(UITapGestureRecognizer*)tapGesutre{
    self.index=-1;
    if (self.rightBtnClick) {
        self.rightBtnClick(self.index);
    }
}
-(instancetype)initWithFrame:(CGRect)frame{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightOption) name:@"right" object:nil];
    if (self=[super initWithFrame:frame]) {
        self.x=frame.size.width*0.5;
        self.y=frame.size.height*0.5-frame.size.height*0.04*0.5;
        self.w=frame.size.width*0.05;
        self.h=frame.size.height*0.04;
    }
    return self;
}
-(void)rightOption{
    self.index=-1;
    if (self.rightBtnClick) {
        self.rightBtnClick(self.index);
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
    RightArrow* view=[[RightArrow alloc]initWithFrame:frame];
    return view;
}
//-(void)layoutIfNeeded{
//    [super layoutIfNeeded];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"right" object:nil];
//    NSLog(@"rrrrrrrr");
//}

@end
