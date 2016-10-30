//
//  HomePageViewController.m
//  FTDemo
//
//  Created by iosDevelop on 16/10/30.
//  Copyright © 2016年 tonywang. All rights reserved.
//

#import "HomePageViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "WordViewController.h"
#import "LoadingViewController.h"
@interface HomePageViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource,UITextViewDelegate>

#define Width [UIScreen mainScreen].bounds.size.width
#define scollerY 50

@property (nonatomic, strong)UITextField *textView;
@property (nonatomic, strong)NewPagedFlowView *pageFlowView;

@property (nonatomic, strong)UIButton *button;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, assign)NSInteger selected;
@property (nonatomic, assign)BOOL isFinished;


@end


@implementation HomePageViewController
#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
-(NewPagedFlowView *)pageFlowView{
    if (_pageFlowView ==nil) {
        
        NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake((Width-250)/2, scollerY,250, 200)];
        pageFlowView.backgroundColor = [UIColor clearColor];
        pageFlowView.delegate = self;
        pageFlowView.dataSource = self;
        pageFlowView.minimumPageAlpha = 0.1;
        pageFlowView.minimumPageScale = 0.85;
        pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        
        //提前告诉有多少页
        //    pageFlowView.orginPageCount = self.imageArray.count;
        
        pageFlowView.isOpenAutoScroll = YES;
        
        _pageFlowView = pageFlowView;

    }
    return _pageFlowView;
}
-(UITextField *)textView{
    
    if (_textView == nil) {
        _textView = [[UITextField alloc]initWithFrame:CGRectMake(30, scollerY+260, Width-60, 60)];
        _textView.placeholder = @"请输入一个词（不超过4个字";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textAlignment = NSTextAlignmentCenter;
    }
    return _textView;
}
-(UIButton *)button{
    
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(50, self.view.frame.size.height-100, Width-100, 30);
        _button.backgroundColor = [UIColor redColor];
        [_button setTitle:@"生成诗句" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(createNewWord) forControlEvents:UIControlEventTouchUpInside];
        _button.enabled = YES;
    }
    return _button;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    for (int index = 1; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",index]];
        [self.imageArray addObject:image];
    }
    
    [self p_initUI];
    
    
    [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionOld context:nil];

 
    // Do any additional setup after loading the view.
}
- (void)p_initUI{
    

    self.title = @"趣味诗词生成器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.pageFlowView.frame.size.height - 24 - 8, Width, 8)];
    self.pageFlowView.pageControl = pageControl;
    [self.pageFlowView addSubview:pageControl];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIImageView *scBackGroundIV = [[UIImageView alloc]initWithFrame:bottomScrollView.bounds];
    [bottomScrollView addSubview:scBackGroundIV];
    
    [scBackGroundIV setImage:[UIImage imageNamed:@"homepageBG"]];
    [bottomScrollView addSubview:self.pageFlowView];
    
    [self.view addSubview:bottomScrollView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.button];
    
    [self.pageFlowView reloadData];

}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(100, 100);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    self.selected = subIndex;
    [self.pageFlowView stopTimer];

}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}
-(void)textViewDidChange:(UITextView *)textView{
    
    textView.editable = textView.text.length>8?@(1):@(0);

}
- (void)textViewDidBeginEditing:(UITextView *)textView{
   
    self.isFinished = textView.text.length>0?@(1):@(0);
    [self isCanPush];

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self isCanPush];
    NSLog(@"监听到%@对象的%@属性发生了改变， %@", object, keyPath, change);
}
-(void)isCanPush{
    
    if (self.isFinished&&self.selected) {
        self.button.enabled = YES;
    }
}
-(void)createNewWord{
    
    LoadingViewController *vc = [[LoadingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)dealloc{
    
    [self.pageFlowView.timer invalidate];
    self.pageFlowView.timer = nil;
    self.pageFlowView.delegate = nil;
    self.pageFlowView = nil;

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.pageFlowView.timer invalidate];
    self.pageFlowView.timer = nil;
    self.pageFlowView.delegate = nil;
    self.pageFlowView = nil;
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
