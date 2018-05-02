//
//  P_GustureView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "P_GustureView.h"

@implementation P_GustureView

-(void)drawRect:(CGRect)rect{
    UISwipeGestureRecognizer* swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipe];
    
}

+(instancetype)loadGustureView{
    P_GustureView* view=[P_GustureView new];
    view.backgroundColor=[UIColor clearColor];
    return view;
}


-(void)swipeLeft{
    if ([self.delegate respondsToSelector:@selector(p_swipeToNextController)]) {
        [self.delegate p_swipeToNextController];
    }
    else{
        return;
    }
}
@end
