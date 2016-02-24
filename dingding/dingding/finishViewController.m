//
//  finishViewController.m
//  dingdingtest
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "finishViewController.h"

#import "tripDetailController.h"

#define SWIDTH [UIScreen mainScreen].bounds.size.width
#define SHEIGHT [UIScreen mainScreen].bounds.size.height

@interface finishViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //列表视图
    UITableView * _tableView;
    //数据源
    NSMutableArray * _dataArray;
}

@end

@implementation finishViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createDataSource];
    [self createTableView];
}
#pragma mark 数据源
- (void)createDataSource
{
    
    //初始化数据源
    _dataArray = [[NSMutableArray alloc]init];
    
    //[_dataArray addObject:dic];
    
    //数据源_dataArray中有若干数组，每个数组里1个字典？
}
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //设置数据源和代理连接
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //设置普通状态下能否多选
    _tableView.allowsMultipleSelection = NO;
    //设置编辑状态下能否多选
    _tableView.allowsMultipleSelectionDuringEditing = YES;
}
#pragma mark 协议方法
//返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataArray.count == 0 ) {
        return 1;
    }
    return _dataArray.count;
}
//返回每组的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count == 0) {
        return 1;
    }else{
        return [_dataArray[section] count];}
}
//返回每个cell的内容
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    //从数据源中获得字典
//    NSDictionary * dict = _dataArray[indexPath.section][indexPath.row];
    //设置cell的标题和图片
    cell.textLabel.text = @"暂无内容";
    //副标题
    cell.detailTextLabel.text = @"暂无数据";

    //cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tripDetailController * detail = [[tripDetailController alloc] initWithNibName:@"tripDetailController" bundle:nil];
    detail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:detail animated:YES completion:^{
        
    }];
}

@end
