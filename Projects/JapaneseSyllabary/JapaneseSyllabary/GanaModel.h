//
//  ganaModel.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/16.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GanaModel : NSObject
@property (nonatomic,copy)NSString* hiragana;
@property (nonatomic,copy)NSString* katagana;


-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)ModelWithDictionary:(NSDictionary*)dict;

@end
