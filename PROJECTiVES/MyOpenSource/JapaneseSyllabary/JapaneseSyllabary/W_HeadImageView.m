//
//  W_HeadNavView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/14.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "W_HeadImageView.h"
#import "WritingImageModel.h"
#import "W_ExerciseController.h"

@interface W_HeadImageView ()
@property (nonatomic,strong)NSArray* imageModelArray;
@end


@implementation W_HeadImageView


-(void)drawRect:(CGRect)rect{
    WritingImageModel*model=self.imageModelArray[0];
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:model.baseBackground ofType:nil]];
    [self addSubview:imageView];
}
+(instancetype)headImageView{
    W_HeadImageView* view=[W_HeadImageView new];
    view.backgroundColor=[UIColor clearColor];
    return view;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(pushToNextController)]) {
        [self.delegate pushToNextController];
    }
    else{
        return;
    }
}
-(NSArray *)imageModelArray{
    if (_imageModelArray==nil) {
        NSMutableArray* tempArray=[NSMutableArray new];
        NSArray* plistArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"WritingImageList.plist" ofType:nil]];
        for (NSDictionary* dict in plistArray) {
            WritingImageModel* model=[[WritingImageModel alloc]initWithDictionary:dict];
            [tempArray addObject:model];
        }
        _imageModelArray=tempArray;
    }
    return _imageModelArray;
}
@end
