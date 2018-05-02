//
//  UpArrow.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/12.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpArrow : UIView
@property(nonatomic,copy)void(^upBtnClick)(int);
-(instancetype)initWithFrame:(CGRect)frame;
+(instancetype)loadUpArrowWithFrame:(CGRect)frame;

@end
