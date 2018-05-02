//
//  P_NavBarButtonView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "P_NavBarButtonView.h"
#import "UIView+MiNiFrame.h"

@interface P_NavBarButtonView ()
@property (nonatomic,strong)NSArray* navImageArray;
@property (nonatomic,strong)NSArray* buttonArray;
@end
@implementation P_NavBarButtonView
-(void)drawRect:(CGRect)rect{
    NSMutableArray* temp=[NSMutableArray new];
    for (int i=0; i<self.navImageArray.count; i++) {
        UIButton* navBtn=[UIButton new];
        navBtn.tag=i;
        navBtn.frame=CGRectMake(self.w*0.2*i, 0, self.w*0.2, self.h);
        NSString* imageName=self.navImageArray[i];
        NSString* path=[[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        [navBtn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        [self addSubview:navBtn];
        [self navButtonsActions];
        [temp addObject:navBtn];
    }
    self.buttonArray=temp;
}

-(void)navButtonsActions{
    
    for (UIButton* button in self.subviews) {
        
        switch (button.tag) {
            case 0: [button addTarget:self action:@selector(btn0Click) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 1: [button addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 2: [button addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 3: [button addTarget:self action:@selector(btn3Click) forControlEvents:UIControlEventTouchUpInside];
                
                break;
            case 4: [button addTarget:self action:@selector(btn4Click) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:break;
        }
    }
}
-(void)btn0Click{
    if ([self.delegate respondsToSelector:@selector(backBtnClick)]) {
        [self.delegate backBtnClick];
        NSDictionary* dict=@{@"index":@"0"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"backBtn0" object:nil userInfo:dict];
    }
}
-(void)btn1Click{
    if (self.hiraganaClick) {
        self.hiraganaClick(0);
    }
}
-(void)btn2Click{
    if (self.katakanaClick) {
        self.katakanaClick(1);
    }
    
}
-(void)btn3Click{
    if (self.femaleClick) {
        self.femaleClick(0);
    }
    
}
-(void)btn4Click{
    if (self.maleClick) {
        self.maleClick(1);
    }
}

-(NSArray *)navImageArray{
    if (!_navImageArray) {
        _navImageArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"P_NavList.plist" ofType:nil]];
    }
    return _navImageArray;
}
-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    self.navImageArray=nil;
    for (UIButton*btn in self.buttonArray) {
        [btn removeFromSuperview];
    }
    self.buttonArray=nil;
}
@end
