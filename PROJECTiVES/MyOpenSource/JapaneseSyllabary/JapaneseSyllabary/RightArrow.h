//
//  RightArrow.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/13.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightArrow : UIView

@property(nonatomic,copy)void(^rightBtnClick)(int);
-(instancetype)initWithFrame:(CGRect)frame;
+(instancetype)loadUpArrowWithFrame:(CGRect)frame;
@end
