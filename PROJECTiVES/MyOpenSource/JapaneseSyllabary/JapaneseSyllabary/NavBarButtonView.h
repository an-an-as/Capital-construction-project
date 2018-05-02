//
//  NavBarButtonView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/11.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WritingViewClickDelegate <NSObject>
@optional
-(void)backBtnClick;

-(void)showHide;
-(void)showDisplay;
-(void)guideHide;
-(void)guideShow;
-(void)lineDisplay;
-(void)lineHide;
@end

@interface NavBarButtonView : UIView
@property (nonatomic,weak)id<WritingViewClickDelegate>delegate;
@property (nonatomic,copy)void(^ganaChangeBtn)(int);
@property (nonatomic,copy)void(^ganaCoverBtn)(int);
@property (nonatomic,copy)void(^ganaGuideBtn)(int);
@end
