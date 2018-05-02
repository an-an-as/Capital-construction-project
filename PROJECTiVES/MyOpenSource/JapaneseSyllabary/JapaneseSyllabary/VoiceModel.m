//
//  VoiceModel.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/27.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "VoiceModel.h"

@implementation VoiceModel
-(instancetype)initWithDict:(NSDictionary*)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)modelWithDict:(NSDictionary*)dict{
    return [[self alloc]initWithDict:dict];
}
@end
