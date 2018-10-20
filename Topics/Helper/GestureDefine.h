//
//  GestureDefine.h
//  测试
//
//  Created by oOPiKACHUoO on 2017/8/16.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#ifndef GestureDefine_h
#define GestureDefine_h


#endif /* GestureDefine_h */
#define _OPEN_INTERRACTION(VIEW) [VIEW setUserInteractionEnabled:YES]
//创建事件
//点击
#define  _TAP(VIEW)    [VIEW  addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]]
//按压
#define  _PRESS(VIEW)  [VIEW  addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(press:)]]
//滑动
#define  _SWIPE(VIEW)  [VIEW  addGestureRecognizer:[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)]]
//旋转
#define  _ROTA(VIEW)  [VIEW  addGestureRecognizer:[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rota:)]]
//捏合
#define  _PINCH(VIEW)  [VIEW  addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)]]
//拖拽
#define  _PAN(VIEW)  [VIEW  addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)]]
//代理（每个子视图都可以同时进行多个手势）
#define _SIMUL for (UIView* view in self.view.subviews) {for (UIGestureRecognizer* ges in view.gestureRecognizers) { ges.delegate=self;}}

