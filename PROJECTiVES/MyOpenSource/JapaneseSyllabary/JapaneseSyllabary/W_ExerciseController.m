//
//  W-ExerciseController.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/10.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "W_ExerciseController.h"
#import "WrittingViewController.h"
#import "NavBarButtonView.h"
#import "PrefixHeader.pch"
#import "GanaExhibitionView.h"
#import "UIView+MiNiFrame.h"
#import "LineAndArrowView.h"
#import "ClearButtonView.h"
#import "Masonry.h"
#import "HideLineView.h"
#import "GuideWordView.h"
//#import "UpArrow.h"
//#import "DownArrow.h"
//#import "LeftArrow.h"
//#import "RightArrow.h"
#import "WaveView.h"
#import "KanaCoverView.h"
#import "GuideGanaModel.h"
#import "DrawingBoard.h"

@interface W_ExerciseController ()<WritingViewClickDelegate,ClearButtonClick>
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property(nonatomic,weak)UIView* navView;
@property(nonatomic,weak)UIView* ganaView;
@property(nonatomic,weak)UIView* drawView;
@property(nonatomic,weak)UIView* clearView;
@property(nonatomic,weak)UIView* hideLineView;
@property(nonatomic,weak)UIView* guidWordView;
@property(nonatomic,weak)UIView* waveView;
@property(nonatomic,weak)UIView* kanaCoverView;
@property(nonatomic,weak)UIView* drawingBoard;
@end

@implementation W_ExerciseController
-(void)loadView{
    [super loadView];
    NavBarButtonView* nav=[NavBarButtonView new];
    GanaExhibitionView* gana=[GanaExhibitionView new];
    LineAndArrowView* draw=[LineAndArrowView new];
    ClearButtonView* clear=[ClearButtonView new];
    HideLineView*hideLine =[HideLineView new];
    GuideWordView*guide=[GuideWordView new];
    WaveView*wave=[WaveView new];
    KanaCoverView* kanaCover=[KanaCoverView new];
    DrawingBoard* drawing=[DrawingBoard new];
    
    
    
    
    self.navView=nav;
    self.ganaView=gana;
    self.drawView=draw;
    self.clearView=clear;
    self.hideLineView=hideLine;
    self.guidWordView=guide;
    self.waveView=wave;
    self.kanaCoverView=kanaCover;
    self.drawingBoard=drawing;
    
    [self.view addSubview:self.navView];
    [self.view addSubview:self.ganaView];
    [self.view addSubview:self.drawView];
    [self.view addSubview:self.clearView];
    [self.view addSubview:self.hideLineView];
    [self.view addSubview:self.guidWordView];
    [self.view addSubview:self.waveView];
    [self.view addSubview:self.kanaCoverView];
    [self.view addSubview:self.drawingBoard];
    
    nav.ganaChangeBtn = ^(int boolIndex) {
        [self.drawingBoard layoutIfNeeded];
        gana.ganaChange=boolIndex;
        guide.guideKanaChange=boolIndex;
        kanaCover.ganaindex=boolIndex;
        
        [gana setNeedsDisplay];
        [guide setNeedsDisplay];
        [kanaCover setNeedsDisplay];
    };
    nav.ganaCoverBtn = ^(int index5) {
        [self.drawingBoard layoutIfNeeded];
        kanaCover.coverindex=index5;
        [kanaCover setNeedsDisplay];
        };
    nav.ganaGuideBtn = ^(int index6) {
        [self.drawingBoard layoutIfNeeded];
        kanaCover.guideindex=index6;
        [kanaCover setNeedsDisplay];
        
    };
    
    draw.downBtnClickIndex = ^(int index1) {
        [self.drawingBoard layoutIfNeeded];
        gana.ganaIndex=gana.ganaIndex-index1;
        guide.guideganaIndex=guide.guideganaIndex-index1;
        if (gana.ganaIndex&&guide.guideganaIndex==55) {
            gana.ganaIndex=1;
            guide.guideganaIndex=1;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==56) {
            gana.ganaIndex=2;
            guide.guideganaIndex=2;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==57) {
            gana.ganaIndex=3;
            guide.guideganaIndex=3;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==58) {
            gana.ganaIndex=4;
            guide.guideganaIndex=4;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==59) {
            gana.ganaIndex=5;
            guide.guideganaIndex=5;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==60) {
            gana.ganaIndex=6;
            guide.guideganaIndex=6;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==61) {
            gana.ganaIndex=7;
            guide.guideganaIndex=7;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==62) {
            gana.ganaIndex=8;
            guide.guideganaIndex=8;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==63) {
            gana.ganaIndex=9;
            guide.guideganaIndex=9;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==64) {
            gana.ganaIndex=10;
            guide.guideganaIndex=10;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        
        if (gana.ganaIndex&&guide.guideganaIndex==18) {
            gana.ganaIndex=29;
            guide.guideganaIndex=29;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
            
        }
        if (gana.ganaIndex&&guide.guideganaIndex==40) {
            gana.ganaIndex=51;
            guide.guideganaIndex=51;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==20) {
            gana.ganaIndex=53;
            guide.guideganaIndex=53;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex&&guide.guideganaIndex==21) {
            gana.ganaIndex=0;
            guide.guideganaIndex=0;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
        [self loadAudioWithModel:model];
        [gana setNeedsDisplay];
        [guide setNeedsDisplay];
    };
    draw.upBtnClickIndex = ^(int index2) {
        [self.drawingBoard layoutIfNeeded];
        gana.ganaIndex=gana.ganaIndex+index2;
        guide.guideganaIndex=guide.guideganaIndex+index2;
        if (gana.ganaIndex==-11) {
            gana.ganaIndex=10;
            guide.guideganaIndex=10;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-1) {
            gana.ganaIndex=53;
            guide.guideganaIndex=53;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==42) {
            gana.ganaIndex=9;
            guide.guideganaIndex=9;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-2) {
            gana.ganaIndex=52;
            guide.guideganaIndex=52;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-3) {
            gana.ganaIndex=51;
            guide.guideganaIndex=51;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==40) {
            gana.ganaIndex=29;
            guide.guideganaIndex=29;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==18) {
            gana.ganaIndex=7;
            guide.guideganaIndex=7;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-4) {
            gana.ganaIndex=50;
            guide.guideganaIndex=50;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-5) {
            gana.ganaIndex=49;
            guide.guideganaIndex=49;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-6) {
            gana.ganaIndex=48;
            guide.guideganaIndex=48;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-7) {
            gana.ganaIndex=47;
            guide.guideganaIndex=47;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-8) {
            gana.ganaIndex=46;
            guide.guideganaIndex=46;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-9) {
            gana.ganaIndex=45;
            guide.guideganaIndex=45;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==-10) {
            gana.ganaIndex=44;
            guide.guideganaIndex=44;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
        [self loadAudioWithModel:model];
        [gana setNeedsDisplay];
        [guide setNeedsDisplay];
    };
    draw.rightBtnClickIndex = ^(int index3) {
        [self.drawingBoard layoutIfNeeded];
        gana.ganaIndex=gana.ganaIndex-index3;
        guide.guideganaIndex=guide.guideganaIndex-index3;
        
        if (gana.ganaIndex==18) {
            gana.ganaIndex=19;
            guide.guideganaIndex=19;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
            
        }
        if (gana.ganaIndex==20) {
            gana.ganaIndex=22;
            guide.guideganaIndex=22;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==31) {
            gana.ganaIndex=33;
            guide.guideganaIndex=33;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==40) {
            gana.ganaIndex=41;
            guide.guideganaIndex=41;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==42) {
            gana.ganaIndex=44;
            guide.guideganaIndex=44;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==54) {
            gana.ganaIndex=0;
            guide.guideganaIndex=0;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
        [self loadAudioWithModel:model];
        [gana setNeedsDisplay];
        [guide setNeedsDisplay];
    };
    draw.leftBtnClickIndex = ^(int index4) {
        [self.drawingBoard layoutIfNeeded];
        gana.ganaIndex=gana.ganaIndex+index4;
        guide.guideganaIndex=guide.guideganaIndex+index4;
      
        if (gana.ganaIndex==-1) {
            gana.ganaIndex=53;
            guide.guideganaIndex=53;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==43) {
            gana.ganaIndex=41;
            guide.guideganaIndex=41;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==40) {
            gana.ganaIndex=39;
            guide.guideganaIndex=39; GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
            
        }
        if (gana.ganaIndex==32) {
            gana.ganaIndex=30;
            guide.guideganaIndex=30;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==21) {
            gana.ganaIndex=19;
            guide.guideganaIndex=19;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        if (gana.ganaIndex==18) {
            gana.ganaIndex=17;
            guide.guideganaIndex=17;
            GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
            [self loadAudioWithModel:model];
        }
        GuideGanaModel* model=guide.guideGanaModelArray[guide.guideganaIndex];
        [self loadAudioWithModel:model];
        [gana setNeedsDisplay];
        [guide setNeedsDisplay];
    };
    
    nav.delegate=self;
    clear.delegate=self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1];
    self.navView.backgroundColor=[UIColor blackColor];
    self.navView.alpha=0.8;
    
    self.ganaView.backgroundColor=[UIColor whiteColor];
    self.drawView.backgroundColor=[UIColor clearColor];
    self.clearView.backgroundColor=[UIColor clearColor];
    self.hideLineView.backgroundColor=self.view.backgroundColor;
    self.guidWordView.backgroundColor=[UIColor clearColor];
    self.waveView.backgroundColor=[UIColor clearColor];
    self.kanaCoverView.backgroundColor=self.ganaView.backgroundColor;
    self.drawingBoard.backgroundColor=[UIColor clearColor];
    
    self.hideLineView.hidden=YES;
    self.guidWordView.hidden=YES;
    self.guidWordView.alpha=0.65;
    self.kanaCoverView.hidden=YES;


    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.11267605633));
    }];
    
    [self.ganaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.23767605633-self.view.h*0.56338028169*0.05*0.5));
    }];
    
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ganaView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.56338028169*0.05*0.5));
    }];
    
    [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.waveView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w , self.view.h*0.56338028169));
    }];
    
    [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.drawView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w , self.view.h*0.08626760563));
    }];
    
    [self.hideLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.drawView.mas_centerX);
        make.centerY.equalTo(self.drawView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.view.w-self.view.w*0.05*2 , self.view.h*0.56338028169-self.view.h*0.56338028169*0.05*2));
    }];
    [self.guidWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.drawView.mas_centerX);
        make.centerY.equalTo(self.drawView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.view.w-self.view.w*0.05*2 , self.view.h*0.56338028169-self.view.h*0.56338028169*0.05*2));
    }];
    [self.kanaCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.23767605633-self.view.h*0.56338028169*0.05*0.5));
    }];
    
    [self.drawingBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.drawView.mas_centerX);
        make.centerY.equalTo(self.drawView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.view.w-self.view.w*0.05*2 , self.view.h*0.56338028169-self.view.h*0.56338028169*0.05*2));
    }];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.ganaView removeFromSuperview];
    [self.navView removeFromSuperview];
    [self.drawView removeFromSuperview];
    [self.clearView removeFromSuperview];
    [self.hideLineView removeFromSuperview];
    [self.waveView removeFromSuperview];
    [self.kanaCoverView removeFromSuperview];
    [self.drawingBoard removeFromSuperview];
    self.audioPlayer=nil;
    self.waveView=nil;
    self.ganaView=nil;
    self.navView=nil;
    self.drawView=nil;
    self.clearView=nil;
    self.hideLineView=nil;
    self.kanaCoverView=nil;
    self.drawingBoard=nil;
//    [[UpArrow new] layoutIfNeeded];
//    [[DownArrow new] layoutIfNeeded];
//    [[LeftArrow new] layoutIfNeeded];
//    [[RightArrow new] layoutIfNeeded];
    
}

-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self.waveView layoutIfNeeded];
    [self.guidWordView layoutIfNeeded];
    [self.drawView layoutIfNeeded];
}
-(void)lineHide{
    self.hideLineView.hidden=NO;
}
-(void)lineDisplay{
    self.hideLineView.hidden=YES;
}

-(void)guideHide{
    self.guidWordView.hidden=NO;
}
-(void)guideShow{
    self.guidWordView.hidden=YES;
}
-(void)showHide{
    self.kanaCoverView.hidden=NO;
}
-(void)showDisplay{
    self.kanaCoverView.hidden=YES;
}

-(void)clearButtonClick{
    [self.drawingBoard layoutIfNeeded];
}

-(void)loadAudioWithModel:(GuideGanaModel*)model{
        NSString* path=[[NSBundle mainBundle]pathForResource:model.sound ofType:@"mp3"];
        NSURL *url=[NSURL fileURLWithPath:path];
        NSError* error;
        AVAudioPlayer* player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        self.audioPlayer=player;
        [self.audioPlayer play];
}

@end
