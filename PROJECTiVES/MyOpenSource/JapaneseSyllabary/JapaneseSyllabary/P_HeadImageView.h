//
//  HeadImageView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol P_PushNextControllerDelegate <NSObject>
@required
-(void)p_pushToNextController;
@end

@interface P_HeadImageView : UIView
@property (nonatomic,weak)id <P_PushNextControllerDelegate>delegate;
+(instancetype)headImageView;
@end
