//
//  CustomAlertView.m
//  TestDemo
//
//  Created by oOPiKACHUoO on 2017/9/9.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "CustomAlertView.h"
#import "Constraint.h"
#import "UIView+MiNiFrame.h"

typedef void(^AnimationBlock)(void);
typedef void (^CompletionAnimationBlock)(BOOL finished);

@implementation CustomAlertView{
    UIView* contentView ;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self internalCustomAlertInitializer];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(!(self = [super initWithCoder:aDecoder])) return self;
    [self internalCustomAlertInitializer];
    return self;
}


-(void)show{
    self.transform = CGAffineTransformMakeScale(FLT_EPSILON , FLT_EPSILON);//最小精度
    [self centerInsuperView];
    
    AnimationBlock extend = ^{ self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);};//标准取值0-1
    AnimationBlock identity = ^{self.transform = CGAffineTransformIdentity;};//和初始值一致
    CompletionAnimationBlock  completion  = ^(BOOL finished){[UIView animateWithDuration:0.3f animations:identity];};
   
    [UIView animateWithDuration:0.5f animations:extend completion:completion];
}
-(void)dismiss{
    AnimationBlock expandBlock = ^{self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);};
    AnimationBlock shrinkBlock = ^{self.transform = CGAffineTransformMakeScale(FLT_EPSILON, FLT_EPSILON);};
    CompletionAnimationBlock completionBlock = ^(BOOL done){[UIView animateWithDuration:0.3f animations:shrinkBlock];};
    
    [UIView animateWithDuration:0.5f animations:expandBlock completion:completionBlock];
}




//初始化
-(void)internalCustomAlertInitializer{
    //根据比例缩放的宽度和高度来确定NavgationBar的宽度和高度|也可以根据Intrinic固有值来确定
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (NSString* visualFormat in @[@"V:[self(==height)]",@"H:[self(==width)]"]){
        NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:@{@"width":@(width),@"height":@(height)} views:NSDictionaryOfVariableBindings(self)];
        [self addConstraints:constraints];
    }
    [self layoutIfNeeded];
    
    //内容视图的尺寸
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];

    //添加子视图
    contentView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:contentView];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ; //自动调整宽高 保证与父视图的左右上下的边距不变
    
    //添加Bar的layer风格
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 20;
    self.clipsToBounds = YES;
    
    //添加Lable
    _lable = [UILabel new];
    [contentView addSubview:_lable];
    _lable.textAlignment = NSTextAlignmentCenter;
    _lable.numberOfLines = 0;
    [_lable setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //添加Button
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [contentView addSubview:_button];
    [_button setTranslatesAutoresizingMaskIntoConstraints:NO];
   

    for (NSString* format in @[@"V:|-[_lable]-[_button]-|",
                               @"H:|-[_lable]-|",
                               @"H:|-[_button]-|"]) {
        NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lable,_button)];
        [contentView addConstraints:constraints];
    }
}

//如果NavigationBar的bounds改变、内容视图也跟着改变 ／ 主要是观察比例变化过程
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([@"bounds" isEqualToString:keyPath]) {
        contentView.frame = self.bounds;
    }
}
-(void)centerInsuperView{
    if (!self.superview) {
        NSLog(@"Error:without superview");
        return;
    }
    
    //删除父视图原有约束
    NSArray* constraintsArray = [self.constraints copy];
    for (NSLayoutConstraint* constraint in constraintsArray) {
        if (constraint.firstItem == self | constraint.secondItem ==self) [self.superview removeConstraint:constraint];
    }
    //添加新的约束
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem: self attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: self.superview attribute: NSLayoutAttributeCenterX multiplier: 1.0f constant: 0.0f];
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem: self attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self.superview attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: 0.0f];
    [self.superview addConstraints:@[centerX,centerY]];
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"bounds"];
}
@end
