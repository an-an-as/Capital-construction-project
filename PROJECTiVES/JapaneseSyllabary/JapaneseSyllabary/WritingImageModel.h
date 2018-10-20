//
//  WritingImageModel.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/10.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WritingImageModel : NSObject
@property (nonatomic,copy)NSString* baseBackground;

-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)ModelWithDictionary:(NSDictionary*)dict;

@end
