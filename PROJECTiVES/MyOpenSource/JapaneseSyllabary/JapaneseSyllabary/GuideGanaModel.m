//
//  ganaModel.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/16.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//


#import "GuideGanaModel.h"
@implementation GuideGanaModel
-(instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+(instancetype)ModelWithDictionary:(NSDictionary*)dict{
    return [[self alloc]initWithDictionary:dict];
}
@end
