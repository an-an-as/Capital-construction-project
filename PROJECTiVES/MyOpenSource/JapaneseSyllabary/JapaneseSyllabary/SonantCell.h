//
//  sonantCell.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/28.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceModel.h"

@interface SonantCell : UITableViewCell
@property(nonatomic,strong)VoiceModel* model;
@property(nonatomic,assign,getter=kanaChanged) BOOL kanaIndex;
@property(nonatomic,assign,getter=voiceChanged) BOOL voice;
@end
