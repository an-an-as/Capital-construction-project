//
//  NSString+SandBox.m
//  AAA
//
//  Created by oOPiKACHUoO on 2017/9/6.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "NSString+SandBox.h"

@implementation NSString (SandBox)
-(instancetype)appendCachePath{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[self lastPathComponent]];
}
-(instancetype)appendTempPath{
    return [NSTemporaryDirectory() stringByAppendingString:[self lastPathComponent]];
}
-(instancetype)appendDocumentPath{
     return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[self lastPathComponent]];
}
@end
