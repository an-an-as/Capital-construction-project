//
//  P_Change.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface P_Change : UIView
@property(nonatomic,copy)void (^changeBlock)(int);
@end
