//
//  P_Change.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "P_Change.h"
#import "UIView+MiNiFrame.h"

#define WORD_SELEECTED_COLOUR [UIColor  colorWithRed:204.0/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define WORD_DEFAULT_COLOUR [UIColor blackColor]
@interface P_Change ()
@property(nonatomic,weak)UILabel* lable1;
@property(nonatomic,weak)UILabel* lable2;
@property(nonatomic,weak)UILabel* lable3;
@end

@implementation P_Change

-(UILabel *)lable1{
    if (!_lable1) {
        UILabel* lable=[UILabel new];
        self.lable1=lable;
        lable.text=@"清音せいおん";
        lable.textColor=WORD_SELEECTED_COLOUR;
        lable.backgroundColor=[UIColor clearColor];
        lable.layer.borderColor=[UIColor  blackColor].CGColor;
        lable.layer.borderWidth=0.5;
        lable.textAlignment=NSTextAlignmentCenter;
        lable.font=[UIFont systemFontOfSize:13];
        lable.userInteractionEnabled=YES;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lable1Click)];
        [lable addGestureRecognizer:tap];
        [self addSubview:lable];
    }
    return _lable1;
}
-(UILabel *)lable2{
    if (!_lable2) {
        UILabel* lable=[UILabel new];
        self.lable2=lable;
        lable.text=@"濁音だくおん";
        lable.textColor=[UIColor blackColor];
        lable.backgroundColor=[UIColor clearColor];
        lable.layer.borderColor=[UIColor blackColor].CGColor;
        lable.layer.borderWidth=0.5;
        lable.textAlignment=NSTextAlignmentCenter;
        lable.font=[UIFont systemFontOfSize:13];
        lable.userInteractionEnabled=YES;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lable2Click)];
        [lable addGestureRecognizer:tap];
        [self addSubview:lable];
    }
    return _lable2;
}

-(UILabel *)lable3{
    if (!_lable3) {
        UILabel* lable=[UILabel new];
        self.lable3=lable;
        lable.text=@"拗音ようおん";
        lable.textColor=[UIColor blackColor];
        lable.backgroundColor=[UIColor clearColor];
        lable.layer.borderColor=[UIColor blackColor].CGColor;
        lable.layer.borderWidth=0.5;
        lable.textAlignment=NSTextAlignmentCenter;
        lable.font=[UIFont systemFontOfSize:13];
        lable.userInteractionEnabled=YES;
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lable3Click)];
        [lable addGestureRecognizer:tap];
        [self addSubview:lable];
    }
    return _lable3;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat lable1W=(self.w*0.9609375)/3;
    CGFloat lable1H=self.h*0.51020408;
    CGFloat leftMargin=(self.w-self.w*0.9609375)*0.5;
    CGFloat topMargin=(self.h-lable1H)*0.5;
    CGFloat lable1X=leftMargin;
    CGFloat lable1Y=topMargin;

    CGFloat lable2W=lable1W;
    CGFloat lable2H=lable1H;
    CGFloat lable2X=leftMargin+lable1W;
    CGFloat lable2Y=lable1Y;
    
    CGFloat lable3W=lable2W;
    CGFloat lable3H=lable2H;
    CGFloat lable3X=leftMargin+lable1W+lable2W;
    CGFloat lable3Y=lable2Y;
    self.lable1.frame=CGRectMake(lable1X, lable1Y, lable1W, lable1H);
    self.lable2.frame=CGRectMake(lable2X, lable2Y, lable2W, lable2H);
    self.lable3.frame=CGRectMake(lable3X, lable3Y, lable3W, lable3H);
    
}


-(void)lable1Click{
    
    
    self.lable1.textColor=WORD_SELEECTED_COLOUR;
    self.lable2.textColor=WORD_DEFAULT_COLOUR;
    self.lable3.textColor=WORD_DEFAULT_COLOUR;
    if (self.changeBlock) {
        self.changeBlock(0);
    }
}
-(void)lable2Click{
    
   
    self.lable1.textColor=WORD_DEFAULT_COLOUR;
    self.lable2.textColor=WORD_SELEECTED_COLOUR;
    self.lable3.textColor=WORD_DEFAULT_COLOUR;
    if (self.changeBlock) {
        self.changeBlock(1);
    }
}
-(void)lable3Click{
    self.lable1.textColor=WORD_DEFAULT_COLOUR;
    self.lable2.textColor=WORD_DEFAULT_COLOUR;
    self.lable3.textColor=WORD_SELEECTED_COLOUR;
    if (self.changeBlock) {
        self.changeBlock(2);
    }
}
-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self.lable1 removeFromSuperview];
    [self.lable2 removeFromSuperview];
    [self.lable3 removeFromSuperview];
    self.lable1=nil;
    self.lable2=nil;
    self.lable3=nil;
}


@end
