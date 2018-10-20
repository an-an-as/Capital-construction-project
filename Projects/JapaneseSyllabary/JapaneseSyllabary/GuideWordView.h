//
//  GuideWordView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/15.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideWordView : UIView
@property (nonatomic,assign) int guideganaIndex;
@property (nonatomic,assign,getter=guideKanaIsChanged) BOOL guideKanaChange;
@property(nonatomic,strong)NSArray* guideGanaModelArray;
@end
