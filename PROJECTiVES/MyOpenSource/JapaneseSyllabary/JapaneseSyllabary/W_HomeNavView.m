//
//  W_HomeNavView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "W_HomeNavView.h"
#import "UIView+MiNiFrame.h"

@implementation W_HomeNavView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.layer.shadowOffset=CGSizeMake(0, 1);
    self.layer.shadowColor=[UIColor whiteColor].CGColor;
    self.layer.shadowRadius=0.1;
    self.layer.shadowOpacity=0.1;
}


+(instancetype)loadHomeViewWithFrame:(CGRect)frame{
    W_HomeNavView* view =[[W_HomeNavView alloc]initWithFrame:frame];
    view.backgroundColor=[UIColor blackColor];
    view.alpha=0.88;
    return view;
}
@end
