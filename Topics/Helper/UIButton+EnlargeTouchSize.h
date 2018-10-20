//
//  UIButton+EnlargeTouchSize.h
//  AAA
//
//  Created by oOPiKACHUoO on 2017/9/18.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UIButton (EnlargeTouchSize)

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
