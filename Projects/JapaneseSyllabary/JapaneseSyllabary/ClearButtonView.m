//
//  ClearButtonView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/11.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "ClearButtonView.h"

@interface ClearButtonView ()
@property(nonatomic,weak)UILabel* imageView;
@end

@implementation ClearButtonView
-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self.imageView removeFromSuperview];
    self.imageView=nil;
}


-(void)drawRect:(CGRect)rect{
    UILabel* lable=[UILabel new];
    self.imageView=lable;
    lable.frame=self.bounds;
    lable.text=@"CLEAR";
    lable.backgroundColor=[UIColor whiteColor];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.textColor=[UIColor  colorWithRed:204.0/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    lable.font=[UIFont systemFontOfSize:20];
    [self addSubview:lable];


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(clearButtonClick)]) {
        [self.delegate clearButtonClick];
    }
}
@end
