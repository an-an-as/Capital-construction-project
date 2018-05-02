//
//  DrawingBoardView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/10.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarButtonView.h"

@interface LineAndArrowView: UIView
@property(nonatomic,copy)void(^downBtnClickIndex)(int);
@property(nonatomic,copy)void(^upBtnClickIndex)(int);
@property(nonatomic,copy)void(^rightBtnClickIndex)(int);
@property(nonatomic,copy)void(^leftBtnClickIndex)(int);
@end
