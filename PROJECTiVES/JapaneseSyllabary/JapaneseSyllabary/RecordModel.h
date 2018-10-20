//
//  RecordModel.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/5/5.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject
@property (nonatomic,copy)NSString* voiceWord;
@property (nonatomic,copy)NSString* voiceRed;
@property (nonatomic,copy)NSString* voiceGreen;
@property (nonatomic,copy)NSString* voicePlay;
@property (nonatomic,copy)NSString* voiceGo;
@property (nonatomic,copy)NSString* voiceWord2;
-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)modelWithDict:(NSDictionary*)dict;
@end
