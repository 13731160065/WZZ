//
//  unfinishViewController.m
//  dingdingtest
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "unfinishViewController.h"

@interface unfinishViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //列表视图
    UITableView * _tableView;
    //数据源
    NSMutableArray * _dataArray;
}
@end

@implementation unfinishViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createDataSource];
    [self createTableView];
}
#pragma mark 创建导航栏按钮

//点击事件
- (void)editClick:(UIBarButtonItem*)btn
{
    if (_tableView.isEditing == NO) {
        [_tableView setEditing:YES animated:YES];
        //        btn.title = @"完成";
        UIBarButtonItem * deleteBtn = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteCell:)];
        self.navigationItem.rightBarButtonItem = deleteBtn;
    }else{
        [_tableView setEditing:NO animated:YES];
        btn.title = @"编辑";
    }
    
}


- (void)deleteCell:(UIBarButtonItem*)sender
{
    //找到所有选中cell的indexPath
    NSArray * indexPaths = [_tableView indexPathsForSelectedRows];
    //给索引排序
    indexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    
    //从数据源依次删除，在indexPaths中是从后往前
    for (int i = (int)indexPaths.count -1; i>=0; i--) {
        [_dataArray[[indexPaths[i] section]] removeObjectAtIndex:[indexPaths[i] row]];
        //_dataArray[[indexPaths[i] section]]
        //数据源[[选中数组的索引] 所在的组]
        //[indexPaths[i] row]
        //[[选中数组的索引] 所在的行]
    }
    //从tableview删除
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
#pragma mark UITableViewDelegate 关于编辑模式
//返回某种编辑状态
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//无论增加还是删除都在这个方法里面调用
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除时先从数据源中删除
        [_dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
        //其次应该从tableview中删除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//关于允许编辑的两个方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    //是否可以编辑删除或者增加
    //    if (indexPath.section == 0 &&  indexPath.row == 1) {
    //        return NO;
    //    }
    return YES;
}
#pragma mark 数据源
- (void)createDataSource
{
    
    //初始化数据源
    _dataArray = [[NSMutableArray alloc]init];
    
        //加到数据源里
//        [_dataArray addObject:];
 
    //数据源_dataArray数组，每个数组里字典
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
    if (_dataArray.count == 0) {
        return 1;
    }else{
        return _dataArray.count;}
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
    cell.textLabel.text = @"没有记录";
    //副标题
    cell.detailTextLabel.text = @"暂无内容";
//        cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}


@end
