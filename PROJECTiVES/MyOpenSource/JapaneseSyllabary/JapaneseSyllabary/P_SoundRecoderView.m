//
//  P_SoundRecoderView.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.

#import "P_SoundRecoderView.h"
#import "UIView+MiNiFrame.h"
#import "RecordModel.h"
#import "PrefixHeader.pch"
#import <AVFoundation/AVFoundation.h>

@interface P_SoundRecoderView ()
@property (nonatomic,strong)NSArray* recordModelArray;
@property (nonatomic,weak)UIImageView* imageView;
@property (nonatomic,weak)UIButton* recordBtn;
@property (nonatomic,weak)UIButton* recordBtn2;
@property (nonatomic,weak)UILabel* changLable;
@property (nonatomic,weak)UILabel* changLable2;
@property (nonatomic,weak)   UIImageView* recAniIcon;
//@property (nonatomic,assign) NSInteger countNum;
//@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic,copy)NSString* filePath;
@property (nonatomic, strong) NSURL *recordFileUrl;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic,strong) CABasicAnimation* rotationAnimation;
@end

@implementation P_SoundRecoderView

-(CABasicAnimation *)anirotationAnimationmation{
    if (!_rotationAnimation) {
       CABasicAnimation*rotationAnimation=[CABasicAnimation new];
        _rotationAnimation=rotationAnimation;
    }
    return _rotationAnimation;
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self.imageView removeFromSuperview];
    [self.recordBtn removeFromSuperview];
    [self.recordBtn2 removeFromSuperview];
    [self.changLable removeFromSuperview];
    [self.recAniIcon removeFromSuperview];
    [self.changLable2 removeFromSuperview];
    
    self.rotationAnimation=nil;
    
    self.changLable2=nil;
    self.recordModelArray=nil;
    self.changLable=nil;
    self.recordBtn2=nil;
    self.recordBtn=nil;
    self.imageView=nil;
    self.recAniIcon=nil;
    [self removeA];
}

-(void)drawRect:(CGRect)rect{
    RecordModel* model=self.recordModelArray[0];
    if (self.voiceChanged) {
        [self loadVoicestyleImageWithName:model.voiceWord2];
    }
    else{
        [self loadVoicestyleImageWithName:model.voiceWord];
    }
    
    switch (self.index) {
        case 0:
            [self loadChangeLableWithString:@"" andWithLableString:@"Basic characters"];
            break;
        case 1:
            [self loadChangeLableWithString:@"" andWithLableString:@"Voiced consonant"];
            break;
        case 2:
            [self loadChangeLableWithString:@"" andWithLableString:@"Contracted sound"];
            break;
        default:
            break;
    }
    
    UIButton* btn=[UIButton new];
    self.recordBtn=btn;
    CGFloat btnW=(self.w-self.imageView.w)*0.5;
    CGFloat btnH=self.h*0.5*0.83464566929;
    CGFloat btnX=self.imageView.w;
    CGFloat btnY=self.h*0.5;
    btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
    NSString* btnPath=[[NSBundle mainBundle]pathForResource:model.voiceGreen ofType:nil];
    UIImage* btnImage=[UIImage imageWithContentsOfFile:btnPath];
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton*btn2=[UIButton new];
    self.recordBtn2=btn2;
    CGFloat btn2W=btnW*0.78142076502;
    CGFloat btn2H=self.h*0.5*0.8346456692;
    CGFloat btn2X=self.imageView.w+btnW;
    CGFloat btn2Y=btnY;
    self.recordBtn2.frame=CGRectMake(btn2X, btn2Y, btn2W, btn2H);
    NSString* btn2Path=[[NSBundle mainBundle]pathForResource:model.voicePlay ofType:nil];
    UIImage* btn2Image=[UIImage imageWithContentsOfFile:btn2Path];
    [btn2 setBackgroundImage:btn2Image forState:UIControlStateNormal];
    [self addSubview:btn2];
    [btn2 addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView* recordAnimation=[UIImageView new];
    self.recAniIcon=recordAnimation;
    recordAnimation.frame=self.recordBtn2.frame;
    NSString* btnIconPath=[[NSBundle mainBundle]pathForResource:model.voiceGo ofType:nil];
    UIImage* btnAni=[UIImage imageWithContentsOfFile:btnIconPath];
    self.recAniIcon.image=btnAni;
    [self addSubview:recordAnimation];
}




-(void)loadVoicestyleImageWithName:(NSString*)imageName{
    self.imageView.image=nil;
    NSString* wordPath=[[NSBundle mainBundle]pathForResource:imageName ofType:nil];
    UIImage* wordImage=[UIImage imageWithContentsOfFile:wordPath];
    self.imageView.image=wordImage;
}

-(void)loadChangeLableWithString:(NSString*)string andWithLableString:(NSString*)string2{
    [self.changLable removeFromSuperview];
    [self.changLable2 removeFromSuperview];
    
    UILabel* changLable=[UILabel new];
    self.changLable=changLable;
    changLable.textAlignment=NSTextAlignmentLeft;
    changLable.font=[UIFont systemFontOfSize:14];
    CGFloat clW=self.w-self.imageView.w;
    CGFloat clH=self.h*0.5;
    CGFloat clX=self.imageView.w;
    CGFloat clY=0;
    changLable.frame=CGRectMake(clX, clY, clW, clH);
    changLable.text=string;
    [self addSubview:changLable];
    
    
    
    UILabel* lable2=[[UILabel alloc]initWithFrame:CGRectMake(clX, clH*0.4, clW, clH*0.5)];
    self.changLable2=lable2;
    if (self.voiceWord) {
        lable2.text=[NSString stringWithFormat:@"%@ [%@]",string2,self.voiceWord] ;
    }
    else{
        
        lable2.text=[NSString stringWithFormat:@"%@  %@",string2,@""];
    }

    lable2.textColor=[UIColor colorWithRed:204.0/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    lable2.font=[UIFont systemFontOfSize:17];
    lable2.textAlignment=NSTextAlignmentLeft;
    [self addSubview:lable2];

   
    self.voiceWord=nil;
}
-(void)playRecord{
    [self PlayRecord:nil];
}
-(void)startRecord{
    
    RecordModel* model=self.recordModelArray[0];
    NSString* btn2Path=[[NSBundle mainBundle]pathForResource:model.voiceRed ofType:nil];
    UIImage* btn2Image=[UIImage imageWithContentsOfFile:btn2Path];
    [self.recordBtn setBackgroundImage:btn2Image forState:UIControlStateNormal];
    
    
    
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    self.rotationAnimation.duration = 2;
    [self.recAniIcon.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
   
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }
    else{
        [session setActive:YES error:nil];
        
    }
    
    self.session = session;
    
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.filePath = [path stringByAppendingString:@"/RRecord.wav"];
    
    self.recordFileUrl = [NSURL fileURLWithPath:self.filePath];
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   //采样率  8000/11025/22050/44100/96000（影响音频的质量）
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
                                   // 音频格式
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   //采样位数  8、16、24、32 默认为16
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                   // 音频通道数 1 或 2
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   //录音质量
                                   [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                   nil];
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self stopRecord:nil];
            [self PlayRecord:nil];
            NSString* btn2Path=[[NSBundle mainBundle]pathForResource:model.voiceGreen ofType:nil];
            UIImage* btn2Image=[UIImage imageWithContentsOfFile:btn2Path];
            [self.recordBtn setBackgroundImage:btn2Image forState:UIControlStateNormal];
            
        });

    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}
-(void)stopRecord:(id)sender {
//    [self removeTimer];
    NSLog(@"停止录音");
    
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
}

//-(void)removeTimer{
//    [self.timer invalidate];
//    self.timer = nil;
//}

//- (void)addTimer{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//}
////-(void)refreshLabelText{
////    NSLog(@"animation action!");
////    self.countNum--;
////}

-(void)PlayRecord:(id)sender {
    
    [self.recorder stop];
    if ([self.player isPlaying])return;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    
   
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];

    [self.player play];
    
}




-(void)layoutSubviews{
    [super layoutSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKana:) name:@"kanaWord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSonantKana:) name:@"kanaWord2" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractedKana:) name:@"kanaWord3" object:nil];
    CGFloat wordW=self.h;
    CGFloat wordH=self.h;
    CGFloat wordX=0;
    CGFloat wordY=0;
    self.imageView.frame=CGRectMake(wordX, wordY, wordW, wordH);
}
-(void)changeKana:(NSNotification*)notification{
    NSString*string=notification.userInfo[@"kana"];
    self.voiceWord=string;
//    NSLog(@"%@",self.voiceWord);
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self removeA];
}
-(void)changeSonantKana:(NSNotification*)notification{
    NSString*string=notification.userInfo[@"sonantKana"];
    self.voiceWord=string;
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self removeA];
//    NSLog(@"%@",self.voiceWord);
}
-(void)contractedKana:(NSNotification*)notification{
    NSString*string=notification.userInfo[@"contracted"];
    self.voiceWord=string;
    [self layoutIfNeeded];
    [self setNeedsDisplay];
    [self removeA];
//NSLog(@"%@",self.voiceWord);
}

-(UIImageView *)imageView{
    if (!_imageView) {
        UIImageView* imageView=[UIImageView new];
        [self addSubview:imageView];
        _imageView=imageView;
    }
    return _imageView;
}

-(NSArray *)recordModelArray{
    if (!_recordModelArray) {
        NSMutableArray* tempArray=[NSMutableArray new];
        NSArray* plistArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"RecordList.plist" ofType:nil]];
        for (NSDictionary* dict in plistArray) {
            RecordModel* model=[[RecordModel alloc]initWithDict:dict];
            [tempArray addObject:model];
        }
        _recordModelArray=tempArray;
    }
    return _recordModelArray;
}

-(void)removeA{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kanaWord" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kanaWord2" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kanaWord3" object:nil];
//    NSLog(@"xxxx");
    
}
@end









