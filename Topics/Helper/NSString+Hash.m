//
//  NSString+Hash.m
//  模拟用户登陆
//
//  Created by oOPiKACHUoO on 2017/7/13.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "NSString+Hash.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Hash)
-(NSString *)md5String{
    const char *str = self.UTF8String; //转换成c语言字符串
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];//16字节
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

-(NSString*)stringFromBytes:(uint8_t*)bytes length:(int)length{
    NSMutableString* strM = [NSMutableString string];
    for (int i=0; i<length; i++) {
        [strM appendFormat:@"%02x",bytes[i]];//x表示16进制
    }
    return [strM copy];
}
@end
