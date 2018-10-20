//
//  ganaModel.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/16.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuideGanaModel : NSObject
@property (nonatomic,copy)NSString* hiragana;
@property (nonatomic,copy)NSString* katagana;
@property (nonatomic,copy)NSString* sound;


-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)ModelWithDictionary:(NSDictionary*)dict;

@end
