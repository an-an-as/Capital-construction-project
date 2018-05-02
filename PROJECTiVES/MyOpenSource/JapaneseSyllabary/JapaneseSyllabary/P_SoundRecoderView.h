//
//  P_SoundRecoderView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P_SoundRecoderView : UIView
@property (nonatomic,assign) int index;
@property (nonatomic,assign,getter=voiceChanged) BOOL voiceStyle;
@property (nonatomic,copy)NSString* voiceWord;
@end
