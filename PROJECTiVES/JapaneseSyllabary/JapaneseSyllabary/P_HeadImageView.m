//
//  HeadImageView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "P_HeadImageView.h"
#import "HomeImageModel.h"


@interface P_HeadImageView ()
@property (nonatomic,strong)NSArray* homeImageArray;
@property (nonatomic,weak)UIImageView* imageView;
@end

@implementation P_HeadImageView
-(void)layoutIfNeeded{
    [self.imageView removeFromSuperview];
    self.imageView=nil;
    NSLog(@"xxx");
}
- (void)drawRect:(CGRect)rect {
    HomeImageModel* model=self.homeImageArray[0];
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView=imageView;
    imageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:model.background1 ofType:nil]];
    [self addSubview:imageView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(p_pushToNextController)]) {
        [self.delegate p_pushToNextController];
    }
    else{
        return;
    }
}
-(NSArray *)homeImageArray{
    if (_homeImageArray==nil) {
        NSMutableArray* tempArray=[NSMutableArray new];
        NSArray* plistArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeImageList.plist" ofType:nil]];
        for (NSDictionary* dict in plistArray) {
            HomeImageModel* model=[HomeImageModel modelWithDictionary:dict];
            [tempArray addObject:model];
        }
        _homeImageArray=tempArray;
    }
    return _homeImageArray;
}
+(instancetype)headImageView{
    P_HeadImageView* view=[P_HeadImageView new];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
@end
