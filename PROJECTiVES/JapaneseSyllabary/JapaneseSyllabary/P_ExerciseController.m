//
//  P_ExerciseController.m
//  JapaneseSyllabary
//
//  Created by oOPiKACHUoO on 2017/4/23.
//  Copyright © 2017年 LittlePrince. All rights reserved.
//

#import "P_ExerciseController.h"
#import "UIView+MiNiFrame.h"
#import "Masonry.h"
#import "P_NavBarButtonView.h"
#import "P_SoundRecoderView.h"
#import "P_Wave_View.h"
#import "P_SoundStyle.h"
#import "P_Change.h"
#import "VoiceModel.h"
#import "BasicCell.h"
#import "SonantCell.h"
#import "ContractedCell.h"




@interface P_ExerciseController ()<PronunounceNavgitionButtonClickDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UIView* navView;
@property (nonatomic,weak) UIView* soundRecoderView;
@property (nonatomic,weak) UIView* waveView;
@property (nonatomic,weak) UITableView* soundStyleView;
@property (nonatomic,weak) UIView* changeView;

@property (nonatomic,strong)NSArray* basicModelArray;
@property (nonatomic,strong)NSArray* sonantModelArray;
@property (nonatomic,strong)NSArray* contractedModelArray;

@property (nonatomic,assign) int changeIndex;
@property (nonatomic,assign) NSInteger rowNum;
@property (nonatomic,weak) UITableViewCell* cell;

@property (nonatomic,assign) int kanaIndex;
@property (nonatomic,assign) int voice;

@property (nonatomic,copy)NSString* voiceWord;


@end

@implementation P_ExerciseController

-(void)loadView{
    [super loadView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeKana:) name:@"kanaWord" object:nil];
    
    
    P_NavBarButtonView* nav=[P_NavBarButtonView new];
    P_SoundRecoderView* rec=[P_SoundRecoderView new];
    P_Wave_View* wav=[P_Wave_View new];
    P_SoundStyle* stl=[P_SoundStyle new];
    P_Change* chg=[P_Change new];

   
    
    chg.changeBlock=^(int index) {
        self.changeIndex=index;
        rec.index=index;
        [rec layoutIfNeeded];
        [rec setNeedsDisplay];
        [stl reloadData];
    };
    nav.katakanaClick = ^(int kanaNum) {
        self.kanaIndex=kanaNum;
        [stl reloadData];
    };
    nav.hiraganaClick = ^(int ganaNum) {
        self.kanaIndex=ganaNum;
        [stl reloadData];
    };
    nav.femaleClick = ^(int femaleVoice) {
        self.voice=femaleVoice;
        rec.voiceStyle=femaleVoice;
         [rec layoutIfNeeded];
        [rec setNeedsDisplay];
        [stl reloadData];
    };
    nav.maleClick = ^(int maleVoice) {
        self.voice=maleVoice;
        rec.voiceStyle=maleVoice;
        [rec layoutIfNeeded];
        [rec setNeedsDisplay];
        [stl reloadData];
    };
    
    
    self.navView=nav;
    self.soundRecoderView=rec;
    self.waveView=wav;
    self.soundStyleView=stl;
    self.changeView=chg;
    
//    if ([self.voiceWord isEqualToString:@"a"]) {
//        rec.voiceWord=self.voiceWord;
//        [rec setNeedsDisplay];
//        NSLog(@"xxx");
//    }
    
    [self.view addSubview:nav];
    [self.view addSubview:rec];
    [self.view addSubview:wav];
    [self.view addSubview:stl];
    [self.view addSubview:chg];
    

    nav.delegate=self;
    stl.delegate=self;
    stl.dataSource=self;
}
//-(void)changeKana:(NSNotification*)notification{
//    NSString*string=notification.userInfo[@"kana"];
//    self.voiceWord=string;
//    NSLog(@"%@",self.voiceWord);
//}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    self.navView.backgroundColor=[UIColor blackColor];
    self.navView.alpha=0.8;
    self.soundRecoderView.backgroundColor=[UIColor whiteColor];
    self.waveView.backgroundColor=[UIColor clearColor];
    self.soundStyleView.backgroundColor=[UIColor whiteColor];
    self.changeView.backgroundColor=[UIColor whiteColor];
  
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.11267605633));
    }];
    [self.soundRecoderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.23767605633-self.view.h*0.56338028169*0.05*0.5));
    }];
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.soundRecoderView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w, self.view.h*0.56338028169*0.05*0.5));
    }];
    [self.soundStyleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.waveView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w , self.view.h*0.56338028169));
    }];
    [self.changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.soundStyleView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(self.view.w , self.view.h*0.08626760563));
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.waveView layoutIfNeeded];
    [self.navView removeFromSuperview];
    [self.soundRecoderView removeFromSuperview];
    [self.waveView removeFromSuperview];
    [self.soundStyleView removeFromSuperview];
    [self.changeView removeFromSuperview];
    self.changeView=nil;
    self.navView=nil;
    self.soundRecoderView=nil;
    self.waveView=nil;
    self.soundStyleView=nil;
    self.soundStyleView=nil;
}


#pragma mark- tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.changeIndex) {
        case 0:
            self.rowNum=self.basicModelArray.count;
            break;
        case 1:
            self.rowNum=self.sonantModelArray.count;
            break;
        case 2:
            self.rowNum=self.contractedModelArray.count;
            break;
        default:
            break;
    }
    return self. rowNum;
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* ID=@"mark";
    static NSString* ID2=@"mark2";
    static NSString* ID3=@"mark3";
    
    BasicCell* cell0=[tableView dequeueReusableCellWithIdentifier:ID];
   
    
    cell0.kanaIndex=self.kanaIndex;
    cell0.voice=self.voice;
   
    
    if (cell0==nil) {
        cell0=[[BasicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    VoiceModel* model=nil;
    if (indexPath.row<self.basicModelArray.count){
        model=self.basicModelArray[indexPath.row];
        cell0.model=model;
    }
    
    
    SonantCell* cell1=[tableView dequeueReusableCellWithIdentifier:ID2];
    cell1.kanaIndex=self.kanaIndex;
    cell1.voice=self.voice;
    
    if (cell1==nil) {
        cell1=[[SonantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
    }
   
    if (indexPath.row<self.sonantModelArray.count) {
        model=self.sonantModelArray[indexPath.row];
        cell1.model=model;
    }
   
    ContractedCell * cell2=[tableView dequeueReusableCellWithIdentifier:ID3];
    cell2.kanaIndex=self.kanaIndex;
    cell2.voice=self.voice;
    if (cell2==nil) {
        cell2=[[ContractedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID3];
    }
    
    if (indexPath.row<self.contractedModelArray.count) {
        model=self.contractedModelArray[indexPath.row];
        cell2.model=model;
    }

    switch (self.changeIndex) {
        case 0:
            [cell1 removeFromSuperview];
            [cell2 removeFromSuperview];
            self.cell=cell0;
           
            break;
        case 1:
            [cell0 removeFromSuperview];
            [cell2 removeFromSuperview];
            self.cell=cell1;
           
            break;
        case 2:
            [cell0 removeFromSuperview] ;
            [cell1 removeFromSuperview];
            self.cell=cell2;
          
            break;
        default:
            break;
    }
    
    return self.cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self.soundRecoderView layoutIfNeeded];
    [self.waveView layoutIfNeeded];
//    [self.changeView layoutIfNeeded];
    [self.navView layoutIfNeeded];
}


-(NSArray *)basicModelArray{
    return [self modelValueForKeyWithArray:_basicModelArray ArrayIndex:0];
}
-(NSArray *)sonantModelArray{
    return [self modelValueForKeyWithArray:_sonantModelArray ArrayIndex:1];
}
-(NSArray *)contractedModelArray{
    return [self modelValueForKeyWithArray:_contractedModelArray ArrayIndex:2];
}
-(NSArray*)modelValueForKeyWithArray:(NSArray*)array ArrayIndex:(int)index{
    if (!array) {
        NSMutableArray* tempArray=[NSMutableArray new];
        NSString* path=[[NSBundle mainBundle]pathForResource:@"VoiceList.plist" ofType:nil];
        NSArray* plistArray=[NSArray arrayWithContentsOfFile:path];
        for (NSDictionary* dict in plistArray[index] ) {
            VoiceModel* model=[VoiceModel modelWithDict:dict];
            [tempArray addObject:model];
        }
        array=tempArray;
    }
    return array;
}

@end










