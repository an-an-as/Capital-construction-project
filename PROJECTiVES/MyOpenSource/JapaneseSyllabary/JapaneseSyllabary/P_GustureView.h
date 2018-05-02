//
//  P_GustureView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol P_PushNextControllerWithGustureDelegate <NSObject>
@required
-(void)p_swipeToNextController;
@end
@interface P_GustureView : UIView
@property (nonatomic,weak)id<P_PushNextControllerWithGustureDelegate>delegate;
+(instancetype)loadGustureView;
@end
