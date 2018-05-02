//
//  P_HomeNavView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "P_HomeNavView.h"
#import "UIView+MiNiFrame.h"

@implementation P_HomeNavView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.layer.shadowOffset=CGSizeMake(0, 3);
    self.layer.shadowColor=[UIColor whiteColor].CGColor;
    self.layer.shadowRadius=1;
    self.layer.shadowOpacity=0.2;
}



+(instancetype)loadHomeViewWithFrame:(CGRect)frame{
    P_HomeNavView* view =[[P_HomeNavView alloc]initWithFrame:frame];
    view.backgroundColor=[UIColor blackColor];
    view.alpha=0.88;
    return view;
}
@end
