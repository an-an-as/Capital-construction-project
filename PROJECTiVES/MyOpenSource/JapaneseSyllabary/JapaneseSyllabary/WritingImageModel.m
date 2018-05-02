//
//  WritingImageModel.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/10.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "WritingImageModel.h"

@implementation WritingImageModel
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
