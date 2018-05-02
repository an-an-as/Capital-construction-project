//
//  ClearButtonView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/11.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClearButtonClick <NSObject>
-(void)clearButtonClick;
@end

@interface ClearButtonView : UIView
@property (nonatomic,weak) id<ClearButtonClick>delegate;
@end
