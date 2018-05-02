//
//  DrawingBoardView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/10.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "LineAndArrowView.h"
#import "UIView+MiNiFrame.h"
#import "UpArrow.h"
#import "DownArrow.h"
#import "LeftArrow.h"
#import "RightArrow.h"
#import "Masonry.h"

@implementation LineAndArrowView

- (void)drawRect:(CGRect)rect {

    UIBezierPath* path1=[UIBezierPath bezierPath];
    UIBezierPath* path2=[UIBezierPath bezierPath];
    UIBezierPath* path3=[UIBezierPath bezierPath];
    UIBezierPath* path4=[UIBezierPath bezierPath];
    
    [path1 moveToPoint:CGPointMake(self.w*0.5, self.h*0.5)];
    [path2 moveToPoint:CGPointMake(self.w*0.5, self.h*0.5)];
    [path3 moveToPoint:CGPointMake(self.w*0.5, self.h*0.5)];
    [path4 moveToPoint:CGPointMake(self.w*0.5, self.h*0.5)];
    
    [path1 addLineToPoint:CGPointMake(self.w*0.5, self.h*0.05*0.5)];//self.h*0.05-arrowButton
    [path2 addLineToPoint:CGPointMake(self.w*0.5, self.h-self.h*0.05*0.5)];
    [path3 addLineToPoint:CGPointMake(self.w*0.05*0.5, self.h*0.5)];
    [path4 addLineToPoint:CGPointMake(self.w-self.w*0.05*0.5,self.h*0.5)];
    
    
    CAShapeLayer* shapeLayer1=[CAShapeLayer layer];
    CAShapeLayer* shapeLayer2=[CAShapeLayer layer];
    CAShapeLayer* shapeLayer3=[CAShapeLayer layer];
    CAShapeLayer* shapeLayer4=[CAShapeLayer layer];
   
    
    [self shapeLayerSettingWith:shapeLayer1 andWithPath:path1 andPosiztionIndex:0];
    [self shapeLayerSettingWith:shapeLayer2 andWithPath:path2 andPosiztionIndex:1];
    [self shapeLayerSettingWith:shapeLayer3 andWithPath:path3 andPosiztionIndex:2];
    [self shapeLayerSettingWith:shapeLayer4 andWithPath:path4 andPosiztionIndex:3];
    
    CABasicAnimation* animation1=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    CABasicAnimation* animation2=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    CABasicAnimation* animation3=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    CABasicAnimation* animation4=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [self caBasicAnimationSetting:animation1 withShapeLayer:shapeLayer1 andWithAnimationKey:@"strokeEnd"];
    [self caBasicAnimationSetting:animation2 withShapeLayer:shapeLayer2 andWithAnimationKey:@"strokeEnd"];
    [self caBasicAnimationSetting:animation3 withShapeLayer:shapeLayer3 andWithAnimationKey:@"strokeEnd"];
    [self caBasicAnimationSetting:animation4 withShapeLayer:shapeLayer4 andWithAnimationKey:@"strokeEnd"];
    
 
    UpArrow* upArrow=[UpArrow loadUpArrowWithFrame:self.frame];
    DownArrow* downArrow=[[DownArrow alloc]initWithFrame:self.frame];
    LeftArrow* leftArrow=[[LeftArrow alloc]initWithFrame:self.frame];
    RightArrow* rightArrow=[[RightArrow alloc]initWithFrame:self.frame];
    upArrow.backgroundColor=[UIColor clearColor];
    downArrow.backgroundColor=[UIColor clearColor];
    leftArrow.backgroundColor=[UIColor clearColor];
    rightArrow.backgroundColor=[UIColor clearColor];
    

    [self addSubview:upArrow];
    [self addSubview:downArrow];
    [self addSubview:leftArrow];
    [self addSubview:rightArrow];
    
    upArrow.upBtnClick = ^(int index1) {
        if (self.upBtnClickIndex) {
            self.upBtnClickIndex(index1);
        }
    };
    downArrow.downBtnClick = ^(int index2) {
        if (self.downBtnClickIndex) {
            self.downBtnClickIndex(index2);
        }
    };
    
    rightArrow.rightBtnClick = ^(int index3) {
        if (self.rightBtnClickIndex) {
            self.rightBtnClickIndex(index3);
        };
    };
    leftArrow.leftBtnClick = ^(int index4) {
        if (self.leftBtnClickIndex) {
            self.leftBtnClickIndex(index4);
        };
    };
    
    [UIView animateWithDuration:0.9 animations:^{
        upArrow.y=0;
        upArrow.alpha=1.0;
        downArrow.y=self.h-downArrow.h;
        downArrow.alpha=1.0;
        leftArrow.x=0;
        leftArrow.alpha=1.0;
        rightArrow.x=self.w-rightArrow.w;
        rightArrow.alpha=1.0;
    }];
    
}



-(void)shapeLayerSettingWith:(CAShapeLayer*)shapeLayer andWithPath:(UIBezierPath*)path andPosiztionIndex:(int)index{
    shapeLayer.frame=self.bounds;
    shapeLayer.backgroundColor=[UIColor clearColor].CGColor;
    shapeLayer.strokeColor=[UIColor blackColor].CGColor;
    shapeLayer.lineWidth=0.5;
    shapeLayer.strokeStart=0;
    shapeLayer.strokeEnd=1;
    shapeLayer.lineDashPattern=@[@7,@7];
    shapeLayer.path=[path CGPath];
    [self.layer insertSublayer:shapeLayer atIndex:index];
}

-(void)caBasicAnimationSetting:(CABasicAnimation*)animation  withShapeLayer:(CAShapeLayer*)shapelayer andWithAnimationKey:(NSString*)key{
    animation.duration=0.8;
    animation.fromValue=@(0.0);
    animation.toValue=@(1.0);
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [shapelayer addAnimation:animation forKey:key];
}


@end




