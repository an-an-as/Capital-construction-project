//
//  sonantCell.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/28.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "SonantCell.h"
#import "UIView+MiNiFrame.h"
#import <AVFoundation/AVFoundation.h>

@interface SonantCell ()
@property (nonatomic,strong)NSArray* buttonArray;
@property (nonatomic,strong)NSArray* playerArray;
@property (nonatomic,strong)AVAudioPlayer* audioPlayer;
@property (nonatomic,strong)NSArray* wordArray;
@property(nonatomic,weak)UIButton* cureentBtn;
@property (nonatomic,strong)CAGradientLayer* gradient;
@end

@implementation SonantCell
-(void)dealloc{
    self.buttonArray=nil;
    self.playerArray=nil;
    self.wordArray=nil;
    self.audioPlayer=nil;
    self.cureentBtn=nil;
    self.gradient=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cellBtn2" object:nil];
}
-(NSArray *)playerArray{
    if (!_playerArray) {
        _playerArray=[NSArray new];
    }
    return _playerArray;
}
-(NSArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray=[NSArray new];
    }
    return _buttonArray;
}
-(NSArray *)wordArray{
    if (!_wordArray) {
        _wordArray=[NSArray new];
    }
    return _wordArray;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatNewButtonWithCount:5];
        self.gradient=[CAGradientLayer layer];
        self.gradient.frame=self.bounds;
        [self.layer addSublayer:self.gradient];
        self.gradient.startPoint=CGPointMake(0, 0);
        self.gradient.endPoint=CGPointMake(0, 1);
        self.gradient.colors=@[(__bridge id)[UIColor clearColor].CGColor,
                               (__bridge id)[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.1].CGColor];
        self.gradient.locations = @[@(0.5f) ,@(1.0f)];
        
    }
    return self;
    
}
- (void)setFrame:(CGRect)frame{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
    
}
-(void)creatNewButtonWithCount:(int)num{
    NSMutableArray* tempArray=[NSMutableArray new];
    for (int i=0; i<num; i++) {
        UIButton* button=[UIButton new];
        CGFloat w=self.w/num;
        CGFloat h=self.h;
        CGFloat x=w*i;
        CGFloat y=0;
        button.frame=CGRectMake(x, y, w, h);
        
        [tempArray addObject:button];
        [self.contentView addSubview:button];
    }
    self.buttonArray=tempArray;

}

-(void)setModel:(VoiceModel *)model{
    _model=model;
    NSMutableArray* tempArray=[NSMutableArray new];
     NSMutableArray* tempArray2=[NSMutableArray new];
    for (int i=0; i<self.buttonArray.count; i++) {
        UIButton*btn=self.buttonArray[i];
        btn.tag=i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor  colorWithRed:204.0/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(basicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
       
        
        NSString* voiceWord=model.voice[i];
        [tempArray2 addObject:voiceWord];
        
        if (self.voiceChanged) {
            self.playerArray=nil;
            NSString* str=model.boySound[i];
            [tempArray addObject:str];
        }
        else{
            self.playerArray=nil;
            NSString* str=model.girlSound[i];
            [tempArray addObject:str];
        }
        if (self.kanaChanged) {
            [btn setTitle:nil forState:UIControlStateNormal];
            NSString*str=model.katakana[i];
            [btn setTitle:str forState:UIControlStateNormal];
        }
        else{
            [btn setTitle:nil forState:UIControlStateNormal];
            NSString*str=model.hiragana[i];
            [btn setTitle:str forState:UIControlStateNormal];
        }
    }
    self.playerArray=tempArray;
    self.wordArray=tempArray2;
}
-(void)basicButtonClick:(UIButton*) button{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBtnState:) name:@"cellBtn2" object:nil];
    NSDictionary*btn=@{@"button2":button};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellBtn2" object:nil userInfo:btn];
    
    NSString* str=self.playerArray[button.tag];
    NSString* str3=self.wordArray[button.tag];
    NSDictionary* dict=@{@"sonantKana":str3};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kanaWord2" object:nil userInfo:dict];

    
    if ([str isEqualToString:@"0"] ) {
        [self.audioPlayer stop];
    }
    else{
        NSString* path=[[NSBundle mainBundle]pathForResource:str ofType:@"mp3"];
        NSURL *url=[NSURL fileURLWithPath:path];
        NSError* error;
        AVAudioPlayer*  player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        self.audioPlayer=player;
        self.audioPlayer.volume=0.5;
        [self.audioPlayer play];
    }
}
-(void)setBtnState:(NSNotification*)notification{
    UIButton*btn=notification.userInfo[@"button2"];
    self.cureentBtn.selected=NO;
    btn.selected=YES;
    self.cureentBtn=btn;
}
@end
