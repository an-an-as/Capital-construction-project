//
//  UIButton+EnlargeTouchSize.m
//  AAA
//
//  Created by oOPiKACHUoO on 2017/9/18.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//


#import "UIButton+EnlargeTouchSize.h"

static const char topNameKey;
static const char rightNameKey;
static const char bottomNameKey;
static const char leftNameKey;

@implementation UIButton (EnlargeTouchSize)
-(void)setEnlargeEdge:(CGFloat)size{
    objc_setAssociatedObject(self, &topNameKey,    [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey,  [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,   [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left{
    objc_setAssociatedObject(self, &topNameKey,     [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey,   [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey,  [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey,    [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGRect)enlargedRect{
    NSNumber* topEdge    = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge  = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge   = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else{
        return self.bounds;
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)){
        return [super pointInside:point withEvent:event];
    }
    //判定触控点是否在指定矩形内
    return CGRectContainsPoint(rect, point) ? YES : NO;
}
/*
 - (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event{
 CGRect rect = [self enlargedRect];
 if (CGRectEqualToRect(rect, self.bounds)){
 return [super hitTest:point withEvent:event];
 }
 return CGRectContainsPoint(rect, point) ? self : nil;
 }*/
@end
