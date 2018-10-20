//
//  NSString+Hash.h
//  模拟用户登陆
//
//  Created by oOPiKACHUoO on 2017/7/13.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//
/*
 计算MD5散列结果
 终端测试命令：
 @code
 md5 -s "String"
 @endcode
 */
#import <Foundation/Foundation.h>


@interface NSString (Hash)
-(NSString*)md5String;  
@end
