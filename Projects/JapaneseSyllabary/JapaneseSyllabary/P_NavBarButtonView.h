//
//  P_NavBarButtonView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PronunounceNavgitionButtonClickDelegate <NSObject>
@optional
-(void)backBtnClick;

@end

@interface P_NavBarButtonView : UIView
@property (nonatomic,weak)id<PronunounceNavgitionButtonClickDelegate>delegate;
@property (nonatomic,copy)void (^hiraganaClick)(int);
@property (nonatomic,copy)void (^katakanaClick)(int);
@property (nonatomic,copy)void (^femaleClick)(int);
@property (nonatomic,copy)void (^maleClick)(int);
@end

