//
//  HomeImageModel.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/9.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeImageModel : NSObject
@property (nonatomic,copy)NSString* background1;

-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)modelWithDictionary:(NSDictionary*)dict;


@end
