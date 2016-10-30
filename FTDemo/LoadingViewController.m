//
//  LoadingViewController.m
//  FTDemo
//
//  Created by iosDevelop on 16/10/30.
//  Copyright © 2016年 tonywang. All rights reserved.
//

#import "LoadingViewController.h"
#import "WordViewController.h"
#import <AFNetworking.h>
@interface LoadingViewController ()
@property (nonatomic,strong) UIView *loadingView1;
@property (nonatomic,strong) UIView *loadingView2;
@property (nonatomic,strong) UIView *loadingView3;
@property (nonatomic,strong) UIView *loadingView4;
@property(strong ,nonatomic) NSTimer* animateViewTimer;

@property (nonatomic,assign) NSMutableArray *strArr;
@end

@implementation LoadingViewController
- (NSTimer *)animateViewTimer {
    if (!_animateViewTimer) {
        _animateViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    }
    return _animateViewTimer;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(UIView *)loadingView1{
    if (_loadingView1 == nil) {
        _loadingView1 = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-130, self.view.center.y-220, 80, 80)];
        _loadingView1.backgroundColor = [UIColor redColor];
        _loadingView1.layer.masksToBounds = YES;
        _loadingView1.layer.cornerRadius = 40;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _loadingView1.frame.size.width, _loadingView1.frame.size.height)];
        label.text = @"正能量";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [_loadingView1 addSubview:label];
    }
    return _loadingView1;
}
-(UIView *)loadingView2{
    if (_loadingView2 == nil) {
        _loadingView2 = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-50, self.view.center.y-80, 80, 80)];
        _loadingView2.backgroundColor = [UIColor redColor];
        _loadingView2.layer.masksToBounds = YES;
        _loadingView2.layer.cornerRadius = 40;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _loadingView2.frame.size.width, _loadingView2.frame.size.height)];
        label.text = @"黑客马拉松";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [_loadingView2 addSubview:label];
    }
    return _loadingView2;
}
-(UIView *)loadingView3{
    if (_loadingView3 == nil) {
        _loadingView3 = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x+100, self.view.center.y+100, 80, 80)];
        _loadingView3.backgroundColor = [UIColor redColor];
        _loadingView3.layer.masksToBounds = YES;
        _loadingView3.layer.cornerRadius = 40;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _loadingView3.frame.size.width, _loadingView3.frame.size.height)];
        label.text = @"PPAP";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [_loadingView3 addSubview:label];
    }
    return _loadingView3;
}
-(UIView *)loadingView4{
    if (_loadingView4 == nil) {
        _loadingView4 = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-100, 80, 80)];
        _loadingView4.backgroundColor = [UIColor redColor];
        _loadingView4.layer.masksToBounds = YES;
        _loadingView4.layer.cornerRadius = 40;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _loadingView4.frame.size.width, _loadingView4.frame.size.height)];
        label.text = @"42";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [_loadingView4 addSubview:label];
    }
    return _loadingView4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [image setImage:[UIImage imageNamed:@"laodingBG"]];
    [self.view addSubview:image];
    self.title = @"诗词生成中...";
    [self.view addSubview:self.loadingView4];
    [self.view addSubview:self.loadingView1];
    [self.view addSubview:self.loadingView2];
    [self.view addSubview:self.loadingView3];
    
    [self p_getData];
    
    for (int i = 0 ; i<25; i++) {
        NSInteger x =self.view.frame.size.width;
        NSInteger y = self.view.frame.size.height;
        UIView *imageVeiw = [[UIView alloc]initWithFrame:CGRectMake((arc4random()%x), (arc4random()%y), 80, 80)];
        imageVeiw.backgroundColor = [UIColor whiteColor];
        imageVeiw.layer.masksToBounds = YES;
        imageVeiw.layer.cornerRadius = 40;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageVeiw.frame.size.width, imageVeiw.frame.size.height)];
        label.text = @"42";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        [imageVeiw addSubview:label];
        imageVeiw.tag = 700+i;
        [self.view addSubview:imageVeiw];
    }
    
    [self startAnimation];
    [[NSRunLoop currentRunLoop] addTimer:self.animateViewTimer forMode:NSDefaultRunLoopMode];
    
     //[UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionRepeat animations:^{
     //} completion:^(BOOL finished) {
    // }];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [self stopAnimation];
}

- (void)p_getData{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:@"http://172.16.4.79:8000/get-poem" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSLog(@"%@", [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil] encoding:NSUTF8StringEncoding]);
        [self stopAnimation];
        NSString *title =[responseObject objectForKey:@"data"][@"title"];
        NSArray *arr=[responseObject objectForKey:@"data"][@"content"];
        WordViewController *vc = [[WordViewController alloc] initWithData:title des:arr];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
        [self stopAnimation];
    }];

}
- (void)startAnimation{
    
    [self startAnimationWith:self.loadingView1 scane:1.2];
    [self startAnimationWith:self.loadingView2 scane:1.8];
    [self startAnimationWith:self.loadingView3 scane:0.7];
    [self startAnimationWith:self.loadingView4 scane:2.5];
    
    for (int i = 0 ; i<25; i++) {
        UIView *view = [self.view viewWithTag:700+i];
        [self startAnimationWith:view scane:arc4random()%2+1.2];
    }
    
}
- (void)stopAnimation{
    
    [self.animateViewTimer invalidate];
    self.animateViewTimer = nil;
}
- (void)startAnimationWith:(UIView *)view scane:(NSInteger)scane{
    NSString *temStr = [self getRandDomStr];
    [UIView animateWithDuration:2.5f
                          delay:0.5*scane
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         NSInteger x = view.frame.size.width;
                         NSInteger y = view.frame.size.height;
                         view.transform =  CGAffineTransformMakeScale(scane, scane);
                         view.transform = CGAffineTransformMakeTranslation((arc4random()%x),  (arc4random()%y));
                         view.backgroundColor = [self setRandDomColor];
                         for (UILabel *label in view.subviews) {
                             label.text = [NSString stringWithFormat:@"%@",temStr];
                         }
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         //view.transform = CGAffineTransformIdentity;
                     }
     ];
    
}
- (NSString *)getRandDomStr{
    
    NSInteger num =(arc4random() % 9);
    self.strArr = [NSMutableArray arrayWithObjects:@"PPAP",@"因缺思厅",@"word哥",@"日了狗",@"日了狗",@"那画面太美",@"猴赛雷",@"呵呵",@"看气质",@"我想静静", nil];
    return [NSString stringWithFormat:@"%@",[self.strArr objectAtIndex:num]];
    
}
- (UIColor *)setRandDomColor{
    
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
