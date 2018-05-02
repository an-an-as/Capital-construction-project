//
//  NavImageModel.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/12.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "NavImageModel.h"

@implementation NavImageModel
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
