//
//  ViewController.m
//  FTDemo
//
//  Created by iosDevelop on 16/10/29.
//  Copyright © 2016年 tonywang. All rights reserved.
//

#import "WordViewController.h"
#import<AVFoundation/AVSpeechSynthesis.h>
typedef NS_ENUM(NSInteger,FTAnimation) {
    FTAnimationTitleLabel = 80000,
    FTAnimationFirstLbael,
    FTAnimationSenconLbael,
    FTAnimationThirdLbael,
    FTAnimationFourthLbael
};

@interface WordViewController ()<AVSpeechSynthesizerDelegate>
@property(strong ,nonatomic) AVSpeechSynthesizer *av;
@property(strong ,nonatomic) AVSpeechUtterance *utterance;
@property(strong ,nonatomic) UILabel *titleLabel;
@property(strong ,nonatomic) UILabel *firstLabel;
@property(strong ,nonatomic) UILabel *secondLabel;
@property(strong ,nonatomic) UILabel *thirdLabel;
@property(strong ,nonatomic) UILabel *fourthLabel;

@property(strong ,nonatomic) NSTimer* animateViewTimer;

@property(assign ,nonatomic) NSInteger labelCount;

//动画类型
@property(assign ,nonatomic) NSInteger UIViewAnimationOptions;
//语音相关
@property(assign ,nonatomic) float pitchMultiplier;

@property(strong ,nonatomic) NSArray *dataArr;
@property(strong ,nonatomic) NSString *titleStr;


@end

#define pLabelSize 27

@implementation WordViewController

#pragma mark -- Getter and Setter
-(instancetype)initWithData:(NSString *)title des:(NSArray *)des{
    self = [super init];
    if (self) {
        self.titleStr = title;
        self.dataArr = [NSArray arrayWithArray:des];
    }
    return  self;
}
- (UILabel *)titleLabel{
    if (_titleLabel ==nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 50)];
        _titleLabel.text = @"诗名";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:30];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.alpha = 0;
        _titleLabel.tag = FTAnimationTitleLabel;
        
    }
    return _titleLabel;
}
- (UILabel *)firstLabel{
    if (_firstLabel ==nil) {
        _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 200, 50)];
        _firstLabel.text = @"白日依山尽";
        _firstLabel.textAlignment = NSTextAlignmentCenter;
        _firstLabel.font = [UIFont systemFontOfSize:pLabelSize];
        _firstLabel.textColor = [UIColor whiteColor];
        _firstLabel.alpha = 0;
        _firstLabel.tag = FTAnimationFirstLbael;
    }
    return _firstLabel;
}

- (UILabel *)secondLabel{
    if (_secondLabel ==nil) {
        _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 200, 50)];
        _secondLabel.text = @"黄河入海流";
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.font = [UIFont systemFontOfSize:pLabelSize];
        _secondLabel.textColor = [UIColor whiteColor];
        _secondLabel.alpha = 0;
        _secondLabel.tag = FTAnimationSenconLbael;

    }
    return _secondLabel;
}
- (UILabel *)thirdLabel{
    if (_thirdLabel ==nil) {
        _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,250, 200, 50)];
        _thirdLabel.text = @"欲穷千里目";
        _thirdLabel.textAlignment = NSTextAlignmentCenter;
        _thirdLabel.font = [UIFont systemFontOfSize:pLabelSize];
        _thirdLabel.textColor = [UIColor whiteColor];
        _thirdLabel.alpha = 0;
        _thirdLabel.tag = FTAnimationThirdLbael;

    }
    return _thirdLabel;
}
- (UILabel *)fourthLabel{
    if (_fourthLabel ==nil) {
        _fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 200, 50)];
        _fourthLabel.text = @"更上一层楼";
        _fourthLabel.font = [UIFont systemFontOfSize:pLabelSize];
        _fourthLabel.textAlignment = NSTextAlignmentCenter;
        _fourthLabel.textColor = [UIColor whiteColor];
        _fourthLabel.alpha = 0;
        _fourthLabel.tag = FTAnimationFourthLbael;
    }
    return _fourthLabel;
}
- (NSTimer *)animateViewTimer {
    
    if (!_animateViewTimer) {
        _animateViewTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startAnimating) userInfo:nil repeats:YES];
    }
    return _animateViewTimer;
}

-(AVSpeechSynthesizer *)av{
    if (_av == nil) {
        _av = [[AVSpeechSynthesizer alloc]init];
        _av.delegate = self;
    }
    return _av;
}

#pragma mark -- life cyclye

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self p_initUI];
    self.navigationController.navigationBarHidden = NO;
    self.labelCount = 0;
    self.pitchMultiplier = (arc4random()%15+5)/10.0;
    [[NSRunLoop currentRunLoop] addTimer:self.animateViewTimer forMode:NSDefaultRunLoopMode];

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidDisappear:(BOOL)animated{
    [self stopAnimating];
    [self.av stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

-(void)dealloc{
    
    [self stopAnimating];
}

- (void)p_initUI{
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [bgImage setImage:[UIImage imageNamed:@"wordBG"]];
    [self.view addSubview:bgImage];

    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = self.titleStr;

    [self.view addSubview:self.firstLabel];
    self.firstLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[0]];
    
    [self.view addSubview:self.secondLabel];
    self.secondLabel.text =  [NSString stringWithFormat:@"%@",self.dataArr[1]];
    
    [self.view addSubview:self.thirdLabel];
    self.thirdLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[2]];
    
    
    [self.view addSubview:self.fourthLabel];
    self.fourthLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[3]];

}
-(NSString *)gb2312toutf8:(NSData *) data
{
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    
    return retStr;
    
}


#pragma mark - Animation method

- (void)startAnimating{
    
    if (self.labelCount>4) {
        return;
    }
    
    [self setUpAniamtionWithType:self.labelCount+80000];
    self.labelCount++;
}

- (void)stopAnimating{
    
    [self.animateViewTimer invalidate];
    self.animateViewTimer = nil;
}
- (void)setUpAniamtionWithType:(FTAnimation )type{
    
  UILabel *aView = (UILabel *)[self.view viewWithTag:type];
    __block CGRect frame = aView.frame;
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         frame.origin.x = self.view.center.x-100;
                         aView.frame = frame;
                         aView.alpha = 1.0f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (self.labelCount>4) {
                             [self stopAnimating];
                         }
                     }];
    [self startSpeechWord:aView.text];
}
-( void)startSpeechWord:(NSString *)speechStr{
    
    self.utterance = [[AVSpeechUtterance alloc]initWithString:speechStr];//需要转换的文字
    self.utterance .rate=0.5;// 设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
    AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-HK"];//设置发音，这是中文普通话
    
    self.utterance .voice= voice;
    self.utterance .pitchMultiplier = self.pitchMultiplier;
    [self.av speakUtterance:self.utterance ];//开始
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---开始播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---完成播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放中止");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---恢复播放");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放取消");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
