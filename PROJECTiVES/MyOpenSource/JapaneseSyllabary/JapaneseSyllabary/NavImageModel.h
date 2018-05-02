//
//  NavImageModel.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/12.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavImageModel : NSObject
@property (nonatomic,strong)NSArray* w_navBtn;
@property (nonatomic,strong)NSArray* w_navBtnSelected;

-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)ModelWithDictionary:(NSDictionary*)dict;
@end
