//
//  Constraint.h
//  NewObject
//
//  Created by oOPiKACHUoO on 2017/8/20.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#ifndef Constraint_h
#define Constraint_h
#endif /* Constraint_h */

//iPhone所有机型竖屏
#define _iPhonePortrait (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact && newCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
//iPhone手机所有机型横屏  Except iPhone6 plus && iPhone7 plus
#define _iPhoneLandscape (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact && newCollection.horizontalSizeClass ==UIUserInterfaceSizeClassCompact)
//iPhone6 plus && iPhone7 plus 的横屏状态
#define _iPhonePlusLandscape (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact && newCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
//表示 iPad 的横竖屏状态
#define _iPad (newCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular && newCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)



//关闭Autoresizing
#define _CLOSE_AUTORESZING(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]
//可视化格式字符串
#define _CONSTRAINT_FORMAT(PARENT, VIEW, FORMAT,METRICS) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:METRICS views:NSDictionaryOfVariableBindings(VIEW)]]
#define _CONSTRAINT_FORMAT_VIEWS(PARENT, FORMAT,METRICS,VIEWBINDINGS) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:METRICS views:VIEWBINDINGS]]

//中心点
#define _CONSTRAINT_CENTER_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define _CONSTRAINTT_CENTER(PARENT, VIEW) {_CONSTRAIN_CENTER_H(PARENT, VIEW); _CONSTRAIN_CENTER_V(PARENT, VIEW);}

#define _CONSTAIN_CENTER_X_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:CONSTANT]]
#define _CONSTAIN_CENTER_V_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:CONSTANT]]



//位置
#define _CONSTRAINT_LEFT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:CONSTANT]]
#define _CONSTRAINT_RIGHT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:CONSTANT]]
#define _CONSTRAINT_TOP(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]
#define _CONSTRAINT_BOTTOM(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]

//尺寸（基于Instrains）
#define _CONSTRAINT_SIZE(VIEW,PARENT_SIZE,WIDTH_MULTIPLY,HEIGHT_MULTIPLY)  [VIEW setExtendSize:CGSizeMake(PARENT_SIZE.width * WIDTH_MULTIPLY, PARENT_SIZE.height * HEIGHT_MULTIPLY)]
