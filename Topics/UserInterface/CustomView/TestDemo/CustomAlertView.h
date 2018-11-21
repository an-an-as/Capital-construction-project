//
//  CustomAlertView.h
//  TestDemo
//
//  Created by oOPiKACHUoO on 2017/9/9.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UINavigationBar
@property (nonatomic,readonly) UILabel* lable;
@property (nonatomic,readonly) UIButton* button;
-(void) show;
-(void) dismiss;

@end
