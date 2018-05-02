//
//  WaveView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/18.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()
@property (nonatomic,weak)UIImageView* imageView;
@end

@implementation WaveView

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
