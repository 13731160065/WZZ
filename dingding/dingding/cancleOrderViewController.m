//
//  cancleOrderViewController.m
//  dingding
//
//  Created by mac on 16/1/18.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "cancleOrderViewController.h"
#import "ColorModel.h"
#import "cancleOrderCell.h"
#import "OrderModel.h"

#import "cancelSuccessController.h"

#define Sheight [UIScreen mainScreen].bounds.size.height
#define Swidth [UIScreen mainScreen].bounds.size.width

@interface cancleOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    
    //列表视图
    UITableView * _tableView;
    //数据源
    NSArray * _dataArray;
    //记录选中状态
    NSMutableArray * _selectArray;
    
    NSMutableArray *_resultaArray;
}

@end

@implementation cancleOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"取消订单";
    
    //添加数据
    _dataArray = @[@"导游迟到",@"改变旅游行程,重新预约",@"换个导游预约行程",@"导游价格太高",@"导游所要小费",@"取消行程",@"其他原因",@"提交"];

    //默认的选中状态
    _selectArray = [[NSMutableArray alloc] initWithObjects:@NO,@NO,@NO,@NO,@NO,@NO,@NO, nil];
    _resultaArray = [NSMutableArray array];
    
    [self createView];
    
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

- (void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Swidth, Sheight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    [self.view addSubview:_tableView];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"cell";
    cancleOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[cancleOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 7) {
        //用于处理可能出现cell复用问题
        /*
        for (UIView * child in cell.contentView.subviews) {
            [child removeFromSuperview];
        }
        */
        cell.bgLabel.hidden = YES;
        cell.LeftIcon.hidden = YES;
        UIButton * submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, (Swidth-80), 40)];
        submitBtn.backgroundColor = [ColorModel colorWithHexString:@"#43b4ea" alpha:1];
        [submitBtn setTitle:_dataArray[indexPath.row] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:submitBtn];

    }else{
        cell.titleLb.text = _dataArray[indexPath.row];
        if([_selectArray[indexPath.row] isEqual:@NO])
        {
            cell.bgLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
            //如果小点改变颜色的话
            //            cell.LeftIcon.backgroundColor = [UIColor blueColor];
            
        }else
        {
            cell.bgLabel.layer.borderColor = [UIColor blueColor].CGColor;
        }
    
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)btnClick:(UIButton *)btn
{
    OrderModel * curOrderModel = [OrderModel currentOrderModel];
    if (curOrderModel.state == 0) {
        //[self.orderStateView removeFromSuperview];
        return;
    }
    NSString *reason = _resultaArray [0];
    [curOrderModel cancelBooking:reason complete:^(NSError *error) {
      cancelSuccessController * success = [[cancelSuccessController alloc] init];
        success.reason = reason;
        [self.navigationController pushViewController:success animated:YES];
     
    }];


    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7) {
        return 70;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 7) {
        if ([_selectArray[indexPath.row] isEqual: @NO]) {
            [_selectArray replaceObjectAtIndex:indexPath.row withObject:@YES];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:NO];
            [_resultaArray addObject:_dataArray[indexPath.row]];
           
        }else
        {
            [_selectArray replaceObjectAtIndex:indexPath.row withObject:@NO];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:NO];
        }

    }
}


@end
