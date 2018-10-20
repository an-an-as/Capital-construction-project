//
//  HomeImageModel.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/9.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "HomeImageModel.h"

@implementation HomeImageModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)modelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initWithDictionary:dict];
}

@end
