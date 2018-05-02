//
//  P_Wave_View.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "P_Wave_View.h"

@interface P_Wave_View ()
@property (nonatomic,weak)UIImageView* imageView;
@end

@implementation P_Wave_View

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self.imageView removeFromSuperview];
    self.imageView=nil;
}
-(void)drawRect:(CGRect)rect{
    UIImageView* view=[[UIImageView alloc]initWithFrame:self.bounds];
    view.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wave1@3x.png" ofType:nil]];
    self.imageView=view;
    [self addSubview:view];
}
@end

