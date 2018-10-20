//
//  UIView+MyConstraintTools.h
//  VisualFormat
//
//  Created by oOPiKACHUoO on 2017/8/15.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MyConstraintTools)
// 比较和删除约束
- (BOOL) _constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2;
- (NSLayoutConstraint *)_constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint;//
- (void)_removeMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (void)_removeMatchingConstraints:(NSArray *)anArray;

// 控制在上级视图范围内
- (void)_addSubviewAndConstrainLessThanBounds:(UIView *)view;

//尺寸和位置
- (void)_constrainSize:(CGSize)aSize;
- (void)_constrainPosition:(CGPoint)aPoint;


//中心点对齐上级视图
- (void)_constrainCenterInSuperview;

//调试
- (NSString *)_constraintRepresentation:(NSLayoutConstraint *)aConstraint;
- (void)_showConstraints;
@end
