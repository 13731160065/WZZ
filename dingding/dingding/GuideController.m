//
//  GuideController.m
//  dingdingtest
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "GuideController.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@interface GuideController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    
    NSMutableArray * _dataArray;
    
}

@end

@implementation GuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    [self createview];
    [self createHeaderView];
    [self loadData];
    [self backBUTTON];
    
    
}

-(void)backBUTTON{
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 30, 30);
    [back setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backpop) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButton;
    
}
-(void)backpop{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)createview
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)loadData
{
    
}
//创建头部视图
- (void)createHeaderView
{
    //背景视图
    UIView * headBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 270)];
    headBgView.backgroundColor = [UIColor lightGrayColor];
    
    //头部背景视图
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 120)];
    topView.backgroundColor = [UIColor whiteColor];
    [headBgView addSubview:topView];
    
    int iconLW = 40;
    //头像
    UIImageView * iconImg = [[UIImageView alloc] initWithFrame: CGRectMake( iconLW, 30, 70, 70)];
    iconImg.backgroundColor = [UIColor blueColor];
    [topView addSubview:iconImg];
    //姓名
    NSString * string = @"崔始源";
    CGSize nameLbSize = [string sizeWithAttributes:@{@"NSFontAttributeName" : [UIFont systemFontOfSize:17]}];
    UILabel * nameLb = [[UILabel alloc] initWithFrame:(CGRect){{CGRectGetMaxX(iconImg.frame)+10, 35}, nameLbSize}];//
    nameLb.font = [UIFont boldSystemFontOfSize:17];
    nameLb.backgroundColor = [UIColor yellowColor];
    [topView addSubview:nameLb];
    //右侧的图标
    //根据名称的长度调整右侧图片的位置
    UIImageView * baoImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLb.frame), 35, 20, 20)];
    baoImg.image = [UIImage imageNamed:@"bao.png"];
    [topView addSubview:baoImg];
    //星星
    UIImageView * starImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+10, CGRectGetMaxY(nameLb.frame) + 5, 100, 20)];
    starImg.backgroundColor = [UIColor greenColor];
    [topView addSubview:starImg];
    //星星数量
    UILabel * starLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starImg.frame), CGRectGetMaxY(nameLb.frame) + 5, 40, 20)];
    starLb.backgroundColor = [UIColor blueColor];
    [topView addSubview:starLb];

    //中部数据
    UIView * middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 1, SWIDTH, 60)];
    for (int i = 0; i<3; i++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH/3*i + 2, 0, SWIDTH/3 - 2, 40)];
        label.backgroundColor = [UIColor blueColor];
        [middleView addSubview:label];
        
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH/3*i + 2, CGRectGetMaxY(label.frame), SWIDTH/3 - 2, 20)];
        label2.backgroundColor = [UIColor yellowColor];
        [middleView addSubview:label2];
        
    }
    [headBgView addSubview:middleView];
    
    //下部视图
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame), SWIDTH, 88)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, SWIDTH - 40, 30)];
    label.backgroundColor = [UIColor greenColor];
    [bottomView addSubview:label];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame), SWIDTH - 40, 20)];
    label2.backgroundColor = [UIColor yellowColor];
    [bottomView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label2.frame), SWIDTH - 40, 20)];
    label3.backgroundColor = [UIColor greenColor];
    [bottomView addSubview:label3];
    [headBgView addSubview:bottomView];
    
    _tableView.tableHeaderView = headBgView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
@end
