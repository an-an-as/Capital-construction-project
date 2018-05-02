//
//  KanaExhibitionView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/11.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "GanaExhibitionView.h"
#import "UIView+MiNiFrame.h"
#import "NavBarButtonView.h"
#import "DownArrow.h"
#import "GanaModel.h"
#import "PrefixHeader.pch"


@interface GanaExhibitionView ()
@property(nonatomic,strong)NSArray* ganaModelArray;
@property (nonatomic,weak)UILabel* ganaLable;
//@property(nonatomic,strong)UIImageView* imageView;
@end

@implementation GanaExhibitionView


//-(void)layoutIfNeeded{
//    [super layoutIfNeeded];
//    [self.imageView removeFromSuperview];
//    self.imageView=nil;
//}

-(void)setNeedsDisplay{
    [super setNeedsDisplay];
    for (UILabel* lable in self.subviews) {
        [lable removeFromSuperview];
    }
    
}
- (void)drawRect:(CGRect)rect {
    if (self.ganaChange==0) {
        [self loadHiranaLable];
        for (UILabel* lable in self.subviews) {
            if (lable.tag==self.ganaIndex) {
                lable.textColor=[UIColor redColor];
            }
        }
    }
    if (self.ganaChange==1) {
        [self loadKataganaLable];
        for (UILabel* lable in self.subviews) {
            if (lable.tag==self.ganaIndex) {
                lable.textColor=[UIColor redColor];
            }
        }
    }
}
-(NSArray *)ganaModelArray{
    if (_ganaModelArray==nil) {
        NSMutableArray* tempArray=[NSMutableArray new];
        NSArray* plistArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"GanaExhibitionList.plist" ofType:nil]];
        for (NSDictionary* dict in plistArray) {
            GanaModel* model=[[GanaModel alloc]initWithDictionary:dict];
            [tempArray addObject:model];
        }
        _ganaModelArray=tempArray;
    }
    return _ganaModelArray;
}
-(void)layoutSubviews{
    [super layoutSubviews];

    for (int i=0; i<self.subviews.count; i++) {
        UILabel* lable=self.subviews[i];
        lable.w=self.w/11;
        lable.h=self.h/5;
        lable.x=i%11*lable.w;
        lable.y=i/11*lable.h;
        lable.frame=CGRectMake(lable.x, lable.y, lable.w, lable.h);
    }
}
-(void)loadHiranaLable{
    for (int i=0; i<self.ganaModelArray.count; i++) {
        UILabel* lable=[UILabel new];
        [self addSubview:lable];
        lable.tag=i;
        GanaModel* model=self.ganaModelArray[i];
        lable.text=model.hiragana;
        lable.font=[UIFont fontWithName:@"CourierNewPSMT" size:12];
        lable.textColor=[UIColor blackColor];
        lable.textAlignment=NSTextAlignmentCenter;
    }
}
-(void)loadKataganaLable{
    for (int i=0; i<self.ganaModelArray.count; i++) {
        UILabel* lable=[UILabel new];
        lable.tag=i;
        [self addSubview:lable];
        GanaModel* model=self.ganaModelArray[i];
        lable.text=model.katagana;
        lable.textColor=[UIColor blackColor];
        lable.font=[UIFont fontWithName:@"CourierNewPSMT" size:12];
        lable.textAlignment=NSTextAlignmentCenter;
    }
}

@end
