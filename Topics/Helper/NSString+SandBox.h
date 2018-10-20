//
//  NSString+SandBox.h
//  AAA
//
//  Created by oOPiKACHUoO on 2017/9/6.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SandBox)
-(instancetype)appendCachePath;
-(instancetype)appendTempPath;
-(instancetype)appendDocumentPath;
@end
