//
//  W_GustureView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "W_GustureView.h"

@implementation W_GustureView

-(void)drawRect:(CGRect)rect{
    UISwipeGestureRecognizer* swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipe];
}

+(instancetype)loadGustureView{
    W_GustureView* view=[W_GustureView new];
    view.backgroundColor=[UIColor clearColor];
    return view;
}


-(void)swipeLeft{
    if ([self.delegate respondsToSelector:@selector(swipeToNextController)]) {
        [self.delegate swipeToNextController];
    }
    else{
        return;
    }
}
@end
