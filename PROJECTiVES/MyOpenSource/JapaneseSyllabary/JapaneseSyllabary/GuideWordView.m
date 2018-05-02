//
//  GuideWordView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/15.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "GuideWordView.h"
#import "GuideGanaModel.h"
#import "UIView+MiNiFrame.h"


@interface GuideWordView ()

@property(nonatomic,strong)UIImageView* imageView;


@end

@implementation GuideWordView
-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self.imageView removeFromSuperview];
    self.imageView=nil;
}

-(void)setNeedsDisplay{
    [super setNeedsDisplay];
    [self.imageView removeFromSuperview];
    self.imageView=nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame=self.bounds;
}

-(void)drawRect:(CGRect)rect{
    GuideGanaModel* model=self.guideGanaModelArray[self.guideganaIndex];
    if (self.guideKanaChange==0) {
        [self loadImageViewWith:model.hiragana];
    }
    if (self.guideKanaChange==1) {
        [self loadImageViewWith:model.katagana];
    }
}

-(NSArray *)guideGanaModelArray{
    if (_guideGanaModelArray==nil) {
        NSMutableArray* tempArray=[NSMutableArray new];
        NSArray* plistArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"GuideGanaExhibitionList.plist" ofType:nil]];
        for (NSDictionary* dict in plistArray) {
            GuideGanaModel* model=[[GuideGanaModel alloc]initWithDictionary:dict];
            [tempArray addObject:model];
        }
        _guideGanaModelArray=tempArray;
    }
    return _guideGanaModelArray;
}

-(void)loadImageViewWith:(NSString*)modelStr{
    UIImageView* imageView=[UIImageView new];
    self.imageView=imageView;
    [self addSubview:self.imageView];
    NSString* path=[[NSBundle mainBundle]pathForResource:modelStr ofType:nil];
    self.imageView.image=[UIImage imageWithContentsOfFile:path];
}
@end









