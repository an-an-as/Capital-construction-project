//
//  UIView+MyConstraintTools.m
//  VisualFormat
//
//  Created by oOPiKACHUoO on 2017/8/15.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "UIView+MyConstraintTools.h"

@implementation UIView (MyConstraintTools)
#pragma mark- 比较和删除约束
/**两个约束是否相同（忽略优先级)*/
- (BOOL) _constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2{
    if (constraint1.firstItem != constraint2.firstItem) return NO;
    if (constraint1.secondItem != constraint2.secondItem) return NO;
    if (constraint1.firstAttribute != constraint2.firstAttribute) return NO;
    if (constraint1.secondAttribute != constraint2.secondAttribute) return NO;
    if (constraint1.relation != constraint2.relation) return NO;
    if (constraint1.multiplier != constraint2.multiplier) return NO;
    if (constraint1.constant != constraint2.constant) return NO;
    
    return YES;
}

/**比较该视图和父识图内的约束，如果相同返回原有约束，不同返回nil*/
- (NSLayoutConstraint *)_constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint{
    //遍历该视图内所有约束如果相同返回原有约束
    for (NSLayoutConstraint *constraint in self.constraints){
        if ([self _constraint:constraint matches:aConstraint])
            return constraint;
    }
    //便利该视图的父类内约束如果相同返回原有约束
    for (NSLayoutConstraint *constraint in self.superview.constraints){
        if ([self _constraint:constraint matches:aConstraint])
            return constraint;
    }
    return nil;
}

/**删除一条约束*/
- (void)_removeMatchingConstraint:(NSLayoutConstraint *)aConstraint{
    NSLayoutConstraint *match = [self _constraintMatchingConstraint:aConstraint];
    if (match){
        [self removeConstraint:match];
        [self.superview removeConstraint:match];
    }
}

/**通过数组删除约束*/
- (void)_removeMatchingConstraints:(NSArray *)anArray{
    //遍历数组内的约束，如果存在内存地址相同的约束对其进行删除
    for (NSLayoutConstraint *constraint in anArray)
        [self _removeMatchingConstraint:constraint];
}



#pragma mark- 令视图出现在上级视图的范围内
- (NSArray *)_constraintsLimitingViewToSuperviewBounds{
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    
    return array;
}

- (void)_constrainWithinSuperviewBounds{
    
    if (!self.superview) return;
    [self.superview addConstraints:[self _constraintsLimitingViewToSuperviewBounds]];
}

/**控制子视图范围使其不超出边界*/
- (void)_addSubviewAndConstrainLessThanBounds:(UIView *)view{
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view _constrainWithinSuperviewBounds];
}




#pragma mark- 限定视图的尺寸、位置
- (NSArray *)_sizeConstraints:(CGSize)aSize{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[self(theWidth@750)]" options:0 metrics:@{@"theWidth":@(aSize.width)} views:NSDictionaryOfVariableBindings(self)]];
    [array addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(theHeight@750)]" options:0 metrics:@{@"theHeight":@(aSize.height)} views:NSDictionaryOfVariableBindings(self)]];
    return array;
}

- (NSArray *)_positionConstraints:(CGPoint)aPoint{
    if (!self.superview) return nil;
    NSMutableArray *array = [NSMutableArray array];
    
    // X position
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:aPoint.x]];
    
    // Y position
    [array addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0f constant:aPoint.y]];
    
    return array;
}

/**视图的尺寸*/
- (void)_constrainSize:(CGSize)aSize{
    [self addConstraints:[self _sizeConstraints:aSize]];
}

/**视图的位置*/
- (void)_constrainPosition:(CGPoint)aPoint{
    if (!self.superview) return;
    [self.superview addConstraints:[self _positionConstraints:aPoint]];
}





#pragma mark - 对齐
- (NSLayoutConstraint *)_horizontalCenteringConstraint{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
}
- (NSLayoutConstraint *)_verticalCenteringConstraint{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
}

//与上级视图水平对齐
- (void)_centerHorizontallyInSuperview{
    if (!self.superview) return;
    [self.superview addConstraint:[self _horizontalCenteringConstraint]];
}
//与上级视图垂直对齐
- (void)_centerVerticallyInSuperview{
    if (!self.superview) return;
    [self.superview addConstraint:[self _verticalCenteringConstraint]];
}



/**对齐上级视图中心点*/
- (void)_constrainCenterInSuperview{
    [self _centerHorizontallyInSuperview];
    [self _centerVerticallyInSuperview];
}


#pragma mark - Debugging & Logging

- (NSString *)nameForLayoutAttribute:(NSLayoutAttribute)anAttribute{
    switch (anAttribute)
    {
        case NSLayoutAttributeLeft: return @"left";
        case NSLayoutAttributeRight: return @"right";
        case NSLayoutAttributeTop: return @"top";
        case NSLayoutAttributeBottom: return @"bottom";
        case NSLayoutAttributeLeading: return @"leading";
        case NSLayoutAttributeTrailing: return @"trailing";
        case NSLayoutAttributeWidth: return @"width";
        case NSLayoutAttributeHeight: return @"height";
        case NSLayoutAttributeCenterX: return @"centerX";
        case NSLayoutAttributeCenterY: return @"centerY";
        case NSLayoutAttributeBaseline: return @"baseline";
        case NSLayoutAttributeNotAnAttribute: return @"not-an-attribute";
        default: return @"unknown-attribute";
    }
}

- (NSString *)nameForLayoutRelation:(NSLayoutRelation)aRelation{
    switch (aRelation)
    {
        case NSLayoutRelationLessThanOrEqual: return @"<=";
        case NSLayoutRelationEqual: return @"==";
        case NSLayoutRelationGreaterThanOrEqual: return @">=";
        default: return @"not-a-relation";
    }
}

- (NSString *)nameForItem:(id)anItem{
    if (!anItem) return @"nil";
    if (anItem == self) return @"[self]";
    if (anItem == self.superview) return @"[superview]";
    return [NSString stringWithFormat:@"[%@:%d]", [anItem class], (int) anItem];
}

//展示当前约束
- (NSString *)_constraintRepresentation:(NSLayoutConstraint *)aConstraint{
    NSString *item1 = [self nameForItem:aConstraint.firstItem];
    NSString *item2 = [self nameForItem:aConstraint.secondItem];
    NSString *relationship = [self nameForLayoutRelation:aConstraint.relation];
    NSString *attr1 = [self nameForLayoutAttribute:aConstraint.firstAttribute];
    NSString *attr2 = [self nameForLayoutAttribute:aConstraint.secondAttribute];
    
    NSString *result;
    
    if (!aConstraint.secondItem)
    {
        result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ %0.3f", aConstraint.priority, item1, attr1, relationship, aConstraint.constant];
    }
    else if (aConstraint.multiplier == 1.0f)
    {
        if (aConstraint.constant == 0.0f)
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ %@.%@", aConstraint.priority, item1, attr1, relationship, item2, attr2];
        else
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ (%@.%@ + %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.constant];
    }
    else
    {
        if (aConstraint.constant == 0.0f)
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ (%@.%@ * %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.multiplier];
        else
            result = [NSString stringWithFormat:@"(%4.0f) %@.%@ %@ ((%@.%@ * %0.3f) + %0.3f)", aConstraint.priority, item1, attr1, relationship, item2, attr2, aConstraint.multiplier, aConstraint.constant];
    }
    
    return result;
}

//显示所有约束
- (void)_showConstraints{
    NSString *viewName = [NSString stringWithFormat:@"[%@:%d]", [self class], (int) self];
    NSLog(@"View %@ has %lu constraints", viewName, (unsigned long)self.constraints.count);
    for (NSLayoutConstraint *constraint in self.constraints)
        NSLog(@"%@", [self _constraintRepresentation:constraint]);
}

@end
