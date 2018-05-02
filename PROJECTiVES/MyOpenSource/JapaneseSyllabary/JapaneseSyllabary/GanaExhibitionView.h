//
//  KanaExhibitionView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/11.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GanaExhibitionView : UIView
@property (nonatomic,assign) int ganaIndex;
@property (nonatomic,assign,getter=ganaIsChanged) BOOL ganaChange;


@end
