//
//  DrawingBoard.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/21.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "DrawingBoard.h"
#import "UIView+MiNiFrame.h"
@interface DrawingBoard()
@property (nonatomic,strong)NSMutableArray* pathArray;
@end
@implementation DrawingBoard

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
}
-(NSMutableArray *)pathArray{
    if (!_pathArray) {
        _pathArray=[NSMutableArray array];
    }
    return _pathArray;
}

-(void)setNeedsDisplay{
    [super setNeedsDisplay];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch=touches.anyObject;
    CGPoint touchPoint=[touch locationInView:touch.view];
    UIBezierPath* path=[UIBezierPath bezierPath];
    [path moveToPoint:touchPoint];
    [self.pathArray addObject:path];
    
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touchNow = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touchNow locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    int btnW=self.w*0.08;
    int btnH=btnW;
  
    if (x>self.w*0.5-btnW&&x<self.w*0.5+btnW&&y>0&&y<btnH) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"up" object:nil];
        
        
    }
//    else if (x>self.w*0.5-btnW&&x<self.w*0.5+btnW&&y>self.h-btnH&&y<self.h) {
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"down" object:nil];
//    }
//    else if (x>0&&x<btnW&&self.h*0.5-btnH&&self.h*0.5+btnH) {
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"left" object:nil];
//    }
//    else if (x>self.w-btnW&&x<self.w&&self.h*0.5-btnH&&self.h*0.5+btnH) {
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"right" object:nil];
//    }
//    else{
//          NSLog(@"touch (x, y) is (%d, %d)", x, y);
//    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch=touches.anyObject;
    CGPoint touchPoint=[touch locationInView:touch.view];
    [self.pathArray.lastObject addLineToPoint:touchPoint];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    for (UIBezierPath* path in self.pathArray) {
        path.lineWidth=21.8;
        path.lineCapStyle=kCGLineCapSquare;
        path.lineJoinStyle=kCGLineJoinRound;
        [path stroke];
    }
}

@end
