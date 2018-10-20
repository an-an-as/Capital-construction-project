//
//  W_HeadNavView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PushNextControllerDelegate <NSObject>
@required
-(void)pushToNextController;
@end
@interface W_HeadImageView : UIView
@property (nonatomic,weak)id <PushNextControllerDelegate>delegate;
+(instancetype)headImageView;
@end
