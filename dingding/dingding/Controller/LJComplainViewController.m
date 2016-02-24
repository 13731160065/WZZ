//
//  LJComplainViewController.m
//  dingdingtest
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 rabbit. All rights reserved.
//

#import "LJComplainViewController.h"
#import "LJComplainCell.h"
#import "OrderModel.h"
#import "ColorModel.h"

#import "LJComplainDetailViewController.h"

#define Sheight [UIScreen mainScreen].bounds.size.height
#define Swidth [UIScreen mainScreen].bounds.size.width

@interface LJComplainViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    //列表视图
    UITableView * _tableView;
    //数据源
    NSArray * _dataArray;
    //记录选中状态
    NSMutableArray * _selectArray;
    //文本视图
    UITextView * _textView;
    //文本默认
    UILabel * _textLabel;
}

@end

@implementation LJComplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投诉";
    self.view.backgroundColor = [ColorModel colorWithHexString:@"ecf1f2" alpha:1];
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    //背景颜色
    self.view.backgroundColor = [ColorModel colorWithHexString:@"#ecf1f2" alpha:1];
    [_textView resignFirstResponder];
 
    
    //添加数据
    _dataArray = @[@"导游迟到",@"导游服务态度不好",@"导游乱收费",@"不是订单显示的导游",@"导游引领区高消费场所",@"",@"提交"];
    
    //默认的选中状态
    _selectArray = [[NSMutableArray alloc] initWithObjects:@NO,@NO,@NO,@NO,@NO, nil];
    
    
    [self createView];
    [self CreatQuit];
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

-(void)viewWillAppear:(BOOL)animated{

[_textView resignFirstResponder];
}
- (void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, Swidth, Sheight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    [self.view addSubview:_tableView];
    
    
}

-(void)CreatQuit{
    UIView *quitView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    UIButton *quitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [quitButton addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    [quitButton setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    quitButton.frame = CGRectMake(0, 5, 25, 25);
    [quitView addSubview:quitButton];
    
    UIBarButtonItem *TouSuButton=[[UIBarButtonItem alloc] initWithCustomView:quitView];
    self.navigationItem.rightBarButtonItem = TouSuButton;
    
    
}
-(void)backToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
#pragma mark - tableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"cell";
    LJComplainCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LJComplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 6) {
        //用于处理可能出现cell复用问题
        /*
         for (UIView * child in cell.contentView.subviews) {
         [child removeFromSuperview];
         }
         */
        cell.bgView.hidden = YES;
        cell.LeftIcon.hidden = YES;
        UIButton * submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, (Swidth-80), 40)];
        submitBtn.backgroundColor = [ColorModel colorWithHexString:@"#43b4ea" alpha:1];
        [submitBtn setTitle:_dataArray[indexPath.row] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:submitBtn];
        
    }else if(indexPath.row == 5){
        cell.bgView.hidden = YES;
        cell.LeftIcon.hidden = YES;
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 5, Swidth-30, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        [cell.contentView addSubview:bgView];
        
        UIImageView * LeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        LeftIcon.image = [UIImage imageNamed:@"tousu_dot.png"];
        [bgView addSubview:LeftIcon];

        _textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.LeftIcon.frame), 0, (Swidth-80), 60)];
//        textView.pl
        [_textView becomeFirstResponder];
        _textView.delegate = self;
        _textView.tag = 1000;
        [bgView addSubview:_textView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.LeftIcon.frame)+5, 5, (Swidth-80), 20)];
        _textLabel.textColor = [UIColor lightGrayColor];
        _textLabel.font = [UIFont systemFontOfSize:17];
        _textLabel.text = @"其它投诉理由...";
        [bgView addSubview:_textLabel];
        
        [cell.contentView addSubview:bgView];
        
    }else{
        cell.titleLb.text = _dataArray[indexPath.row];
        if([_selectArray[indexPath.row] isEqual:@NO])
        {
            cell.bgView.backgroundColor = [UIColor whiteColor];
            
        }else
        {
            cell.bgView.backgroundColor = [ColorModel colorWithHexString:@"b2e5fe" alpha:1];
        }

        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)btnClick:(UIButton *)btn
{

    [self showAlertView];
    
}

- (void)showAlertView
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定提交吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加按钮
    UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }];
    
    UIAlertAction * defaultBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
        //获取输入框的内容
        _textView = (UITextView *)[self.view viewWithTag:1000];
        if ([_textView.text isEqualToString:@""]||_textView.text ==nil) {
            
        }else {
            [_selectArray addObject:_textView.text];}
        
        //将投诉内容发送到服务器
        [[OrderModel currentOrderModel] complain:^(NSError *error) {
            LJComplainDetailViewController * detail = [[LJComplainDetailViewController alloc] init];
            
            detail.subArray = _selectArray;
            
            [self.navigationController pushViewController:detail animated:YES];
        } complain_text:[_selectArray lastObject]];
        
    }];
    
    //将按钮添加到弹框上
    [alertC addAction:cancelBtn];
    [alertC addAction:defaultBtn];
    //显示到屏幕上
    [self presentViewController:alertC animated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 7) {
//        return 70;
//    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 5) {
        if ([_selectArray[indexPath.row] isEqual: @NO]) {
            [_selectArray replaceObjectAtIndex:indexPath.row withObject:_dataArray[indexPath.row]];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:NO];
            
        }else
        {
            [_selectArray replaceObjectAtIndex:indexPath.row withObject:@NO];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:NO];
        }
        
    }
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    _textView.text =  textView.text;
    if (_textView.text.length == 0) {
        _textLabel.text = @"其它投诉理由...";
    }else{
        _textLabel.text = @"";
    }
}

@end
