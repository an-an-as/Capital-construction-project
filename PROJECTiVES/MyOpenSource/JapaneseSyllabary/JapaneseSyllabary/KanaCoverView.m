//
//  KanaCoverView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/20.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "KanaCoverView.h"

@interface KanaCoverView ()
@property(nonatomic,weak)UILabel* lable;
@end

@implementation KanaCoverView

-(void)setNeedsDisplay{
    [super setNeedsDisplay];
    [self.lable removeFromSuperview];
    self.lable=nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.lable.frame=self.bounds;
}
-(void)drawRect:(CGRect)rect{
    if (self.coverindex==1&&self.guideindex==0) {
        [self loadLableTextWithString:@"DICTATION"];
    }
    if (self.coverindex==1&&self.guideindex==1&&self.ganaindex==0){
        [self loadLableTextWithString:@"HIRAGANA"];
    }
    if (self.coverindex==1&&self.guideindex==1&&self.ganaindex==1){
        [self loadLableTextWithString:@"KATAKANA"];
    }
}

-(void)loadLableTextWithString:(NSString*)str{
    UILabel* lable=[UILabel new];
    self.lable=lable;
    [self addSubview:lable];
    lable.textColor=[UIColor blackColor];
    lable.font=[UIFont fontWithName:@"Arial-BoldMT" size:35];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.text=str;
}
@end
