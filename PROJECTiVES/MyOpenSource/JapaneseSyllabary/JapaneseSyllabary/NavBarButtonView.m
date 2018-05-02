//
//  NavBarButtonView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/11.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "NavBarButtonView.h"
#import "UIView+MiNiFrame.h"
#import "NavImageModel.h"

@interface NavBarButtonView ()
@property (nonatomic,strong)NSArray* imageModelArray;
@property(nonatomic,getter=ganaIsChanged) BOOL ganaChangeIndex;
@property(nonatomic,getter=showIsChanged) BOOL showChangeIndex;
@property(nonatomic,getter=guideIsChanged)BOOL guideChangeIndex;
@property(nonatomic,getter=lineIsChanged) BOOL lineChangeIndex;
@end

@implementation NavBarButtonView
- (void)drawRect:(CGRect)rect {
    NavImageModel* model =self.imageModelArray[0];
    for (int i=0; i<5; i++) {
        UIButton* button=[UIButton new];
        button.tag=i;
        button.frame=CGRectMake(self.w*0.2*i, 0, self.w*0.2, self.h);
        NSString* imageNor=model.w_navBtnSelected[i];
        NSString* pathNor=[[NSBundle mainBundle]pathForResource:imageNor ofType:nil];
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:pathNor] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    [self NavButtonsActions];
    [self btn2Click:nil];
}

-(void)NavButtonsActions{
  
    for (UIButton* button in self.subviews) {
        
        switch (button.tag) {
            case 0: [button addTarget:self action:@selector(btn0Click) forControlEvents:UIControlEventTouchDown];
                
                    break;
            case 1: [button addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchDown];
                
                    break;
            case 2: [button addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchDown];
                
                    break;
            case 3: [button addTarget:self action:@selector(btn3Click:) forControlEvents:UIControlEventTouchDown];
                
                    break;
            case 4: [button addTarget:self action:@selector(btn4Click:) forControlEvents:UIControlEventTouchDown];
            
                    break;
            default:break;
        }
    }
}
-(void)btn0Click{
    NSDictionary* dict=@{@"index":@"1"};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backBtn" object:nil userInfo:dict];
    
    if ([self.delegate respondsToSelector:@selector(backBtnClick)]) {
        [self.delegate backBtnClick];
    }
    else{
        return;
    }
}

-(void)btn1Click:(UIButton*)sender{
    self.ganaChangeIndex=!self.ganaChangeIndex;
    
    if (self.ganaIsChanged) {
        [self loadImageWithButtonTag:sender andWithModelIndex:0];
        if (self.ganaChangeBtn) {
            self.ganaChangeBtn(1);
        }
    }
    else{
        [self loadImageWithButtonTag:sender andWithModelIndex:1];
        if (self.ganaChangeBtn) {
            self.ganaChangeBtn(0);
        }
    }
}

-(void)btn2Click:(UIButton*)sender{
    self.showChangeIndex=!self.showChangeIndex;
   
    if (self.showIsChanged) {
        [self loadImageWithButtonTag:sender andWithModelIndex:1];
        if ([self.delegate respondsToSelector:@selector(showHide)]) {
            [self.delegate showHide];
        }
        else{
            return;
        }
        if (self.ganaCoverBtn) {
            self.ganaCoverBtn(1);
        }
    }
    else{
        [self loadImageWithButtonTag:sender andWithModelIndex:0];
        if ([self.delegate respondsToSelector:@selector(showDisplay)]) {
            [self.delegate showDisplay];
        }
        else{
            return;
        }
        if (self.ganaCoverBtn) {
            self.ganaCoverBtn(0);
        }
    }
}

-(void)btn3Click:(UIButton*)sender{
    self.guideChangeIndex=!self.guideChangeIndex;
   
  
    if (self.guideIsChanged) {
         [self loadImageWithButtonTag:sender andWithModelIndex:0];
        if ([self.delegate respondsToSelector:@selector(guideHide)]) {
            [self.delegate guideHide];
           
        }
        else{
            return;
        }
        if (self.ganaGuideBtn) {
            self.ganaGuideBtn(1);
        }
    }
    else{
        [self loadImageWithButtonTag:sender andWithModelIndex:1];
        if ([self.delegate respondsToSelector:@selector(guideShow)]) {
            [self.delegate guideShow];
            
        }
        else{
            return;
        }
        if (self.ganaGuideBtn) {
            self.ganaGuideBtn(0);
        }
    }
}
-(void)btn4Click:(UIButton*)sender{
    self.lineChangeIndex=!self.lineChangeIndex;
   
    if (self.lineIsChanged) {
        [self loadImageWithButtonTag:sender andWithModelIndex:0];
        if ([self.delegate respondsToSelector:@selector(lineHide)]) {
            [self.delegate lineHide];
        }
        else{
            return;
        }
    }
    else{

        [self loadImageWithButtonTag:sender andWithModelIndex:1];
        if ([self.delegate respondsToSelector:@selector(lineDisplay)]) {
            [self.delegate lineDisplay];
             NSLog(@"");
        }
        else{
            return;
        }
    }
}
-(NSArray *)imageModelArray{
    if (_imageModelArray==nil) {
        NSMutableArray* tempArray=[NSMutableArray new];
        NSArray* plistArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"NavImageList.plist" ofType:nil]];
        for (NSDictionary* dict in plistArray) {
            NavImageModel* model=[[NavImageModel alloc]initWithDictionary:dict];
            [tempArray addObject:model];
        }
        _imageModelArray=tempArray;
    }
    return _imageModelArray;
}
-(void)loadImageWithButtonTag:(UIButton*)sender andWithModelIndex:(BOOL)index{
    NavImageModel*model=self.imageModelArray[0];
    NSString* image1=model.w_navBtn[sender.tag];
    NSString* image2=model.w_navBtnSelected[sender.tag];
    if (index==0) {
        NSString* path=[[NSBundle mainBundle]pathForResource:image1 ofType:nil];
        [sender setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    }
    else{
        NSString* path=[[NSBundle mainBundle]pathForResource:image2 ofType:nil];
        [sender setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    }
}
@end
