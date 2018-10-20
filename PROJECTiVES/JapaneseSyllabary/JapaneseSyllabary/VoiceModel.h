//
//  VoiceModel.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/27.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceModel : NSObject
@property (nonatomic,copy)NSArray* voice;
@property (nonatomic,copy)NSArray* hiragana;
@property (nonatomic,copy)NSArray* katakana;
@property (nonatomic,copy)NSArray* boySound;
@property (nonatomic,copy)NSArray* girlSound;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)modelWithDict:(NSDictionary*)dict;
@end
