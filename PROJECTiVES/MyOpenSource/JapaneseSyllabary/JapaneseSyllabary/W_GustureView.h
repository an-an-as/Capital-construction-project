//
//  W_GustureView.h
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PushNextControllerWithGustureDelegate <NSObject>
@required
-(void)swipeToNextController;
@end

@interface W_GustureView : UIView
@property (nonatomic,weak)id<PushNextControllerWithGustureDelegate>delegate;
+(instancetype)loadGustureView;

@end
