//
//  RootViewController.m
//  dingding
//
//  Created by CccDaxIN on 15/12/14.
//  Copyright © 2015年 rabbit. All rights reserved.
//

#import "RootViewController.h"
#import "UserModel.h"
#import "OrderModel.h"
#import "BKMoreInfoViewController.h"
#import "DataSigner.h"
#import "BKLSideView.h"
#import "BKUserCenterViewController.h"
#import "Prefix.pch"
#import "tripViewController.h"
#import "notBuildViewController.h"

@interface RootViewController ()<BKCreateOrderDelegate, UMSocialUIDelegate, QMapViewDelegate, CLLocationManagerDelegate>
{
    NSTimer *_timer;

}
@property(nonatomic, strong) UserModel *userModel;
@property(nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) QMapView *mapView;
@property (nonatomic, strong) NSArray *navList; // 周边导游列表
@property (nonatomic, strong) NSMutableArray *mapAnnotation; // 标注

@property (nonatomic, strong) BKLSideView *slideView;


@end

@implementation RootViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initIconView];
    [self initMapView];

    //头部蓝色 #43b4ea 下面浅灰色 #ecf1f2
    self.navigationController.navigationBar.barTintColor = [ColorModel colorWithHexString:@"#43b4ea" alpha:1];
    self.bottomVIew.backgroundColor = [ColorModel colorWithHexString:@"#ecf1f2" alpha:1];
    self.orderStateView.backgroundColor = [ColorModel colorWithHexString:@"#ecf1f2" alpha:1];
 
    [self addleftView];
    
    
   }
//加载侧边栏
-(void)addleftView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"BKLSideView" owner:nil options:nil];
    self.slideView = [nibView objectAtIndex:0];
    self.slideView.frame = self.view.bounds;
   // self.slideView.contextView.backgroundColor = [UIColor blackColor];
//    [self.slideView.contextView setTintColor:[ColorModel colorWithHexString:@"#ecf1f2" alpha:1]];
//    self.slideView.backgroundColor = [ColorModel colorWithHexString:@"#ecf1f2" alpha:1];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:@"updateUser" object:nil];

    //退出登录功能
    [self.slideView.logOut addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    //拨打客服电话
    [self.slideView.serviceCall addTarget:self action:@selector(callService) forControlEvents:UIControlEventTouchUpInside];
    //用户中心功能
    UITapGestureRecognizer *tapCenter = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userCenterIN:)];
    [self.slideView.userCenterView addGestureRecognizer:tapCenter];
    self.slideView.userCenterView.userInteractionEnabled = YES;
    //我的行程功能
    UITapGestureRecognizer *tapTrip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMyTrip:)];
    [self.slideView.myTrip addGestureRecognizer:tapTrip];
    self.slideView.myTrip.userInteractionEnabled = YES;
    //我的钱包
    UITapGestureRecognizer *tapTrip1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMyPurse:)];
    [self.slideView.myPurse addGestureRecognizer:tapTrip1];
    self.slideView.myPurse.userInteractionEnabled = YES;
    //推荐景点
    UITapGestureRecognizer *tapTrip2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMyPurse:)];
    [self.slideView.tuijianSight addGestureRecognizer:tapTrip2];
    self.slideView.tuijianSight.userInteractionEnabled = YES;
    //推荐导游
    UITapGestureRecognizer *tapTrip3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMyPurse:)];
    [self.slideView.tuijianGuide addGestureRecognizer:tapTrip3];
    self.slideView.tuijianGuide.userInteractionEnabled = YES;
    //设置
    UITapGestureRecognizer *tapTrip4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMyPurse:)];
    [self.slideView.settings addGestureRecognizer:tapTrip4];
    self.slideView.settings.userInteractionEnabled = YES;
    //我的卡包
    UITapGestureRecognizer *tapTrip5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMyPurse:)];
    [self.slideView.myCardWallet addGestureRecognizer:tapTrip5];
    self.slideView.myCardWallet.userInteractionEnabled = YES;
    //消息中心
    UITapGestureRecognizer *tapTrip6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toMyPurse:)];
    [self.slideView.messageCenter addGestureRecognizer:tapTrip6];
    self.slideView.messageCenter.userInteractionEnabled = YES;
    
    [self.view addSubview:self.slideView];


}
//根据用户信息改变名称和电话
-(void)updateUserInfo:(NSNotification*) noti{
    NSString *name = [noti.object objectForKey:@"tname"];
    NSString *tele = [noti.object objectForKey:@"mobile"];
    [self.slideView refreshUserInfoWithName:name telePhone:tele];
}
-(void)toMyPurse:(UITapGestureRecognizer*)sender{
    notBuildViewController *not= [[notBuildViewController alloc]init];
    [self.navigationController pushViewController:not animated:YES];
    
}
-(void)toMyTrip:(UITapGestureRecognizer*)sender{

    tripViewController *mytrip = [[tripViewController alloc]init];
    
    [self.navigationController pushViewController:mytrip animated:YES];
    
}
-(void)logOut{

[self performSegueWithIdentifier:@"loginIdentifier" sender:nil];


}
-(void)userCenterIN:(UITapGestureRecognizer*)sender{
    BKUserCenterViewController *userCenter = [[BKUserCenterViewController alloc]init];
    [self.navigationController pushViewController:userCenter animated:YES];
    
}
-(void)callService{
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4004001234"]];

}

/** 初始化头像 **/
- (void) initIconView{
    UIImage * iconImage = [UIImage imageNamed:@"tjdy"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:iconImage forState:UIControlStateNormal];
    UIBarButtonItem *iconButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = iconButton;
    self.iconButton = button;
    
    [button addTarget:self action:@selector(onIconButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 地图相关
/** 初始化地图显示 **/
- (void) initMapView{
    [QMapServices sharedServices].apiKey = @"QQUBZ-IAIRU-27IVT-2XKU2-R2QCQ-ELBMY";
//    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
    self.mapView = [[QMapView alloc] init];
    self.mapView.delegate = self;
    [self.contextView addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contextView);
    }];
    
    [self.mapView setZoomLevel:10.01];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserTrackingMode:QUserTrackingModeFollow animated:YES];
}

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (updatingLocation) {
        [self checkNavStatus];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"main"];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrderStateChange) name:BKOrderModelLocalStatusChanage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:@"startCheckState" object:nil];
    
    if (!self.userModel.token) {
        [self performSegueWithIdentifier:@"loginIdentifier" sender:nil];
    } else {
        // TODO 换头像
        [self.iconButton setImage:[UIImage imageNamed:@"huiyuan"] forState:UIControlStateNormal];

//        self.orderStateView.hidden = YES;
    }
}
-(void)startTimer{

    _timer =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateOrderState:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];

}
- (void) viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"main"]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BKOrderModelLocalStatusChanage object:nil];
}

- (void) onIconButtonClick{
    static BOOL isShow =YES;
    
    if(self.userModel.token){

        if (!isShow) {
            [self.slideView show:YES];
            isShow = YES;
        }else{
        [self.slideView close:YES];
            isShow = NO;
        }
        
    } else {
        [self performSegueWithIdentifier: @"loginIdentifier" sender:nil];
        
    }
}

/** 订单变化 **/
- (void) onOrderStateChange{
    DDLogInfo(@"controller_order_state_change");
    [self updateOrderStateChange];
}

- (void) updateOrderStateChange{

    OrderModel *curModel = [OrderModel currentOrderModel];
    if (curModel.state == 0) {
        // booking
//        [self.contextView bringSubviewToFront:self.orderStateView];
//        self.orderStateView.hidden = NO;
        self.bottomVIew.hidden = YES;
        UIButton * buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancle.frame = self.bottomVIew.frame;
        [buttonCancle setTitle:@"取消" forState:UIControlStateNormal];
        buttonCancle.titleLabel.textAlignment = NSTextAlignmentCenter;
        [buttonCancle setBackgroundColor:[ColorModel colorWithHexString:@"#43b4ea" alpha:1]];
        [buttonCancle addTarget:self action:@selector(cancelOrderBooking:) forControlEvents:UIControlEventTouchUpInside];
        buttonCancle.tag = 11;
        [self.view addSubview:buttonCancle];
        
    } else if(curModel.state == 1){
        // 待付款
        [_timer invalidate];
        [self performSegueWithIdentifier:@"root2order" sender:nil];
        [self.orderStateView removeFromSuperview];
        self.bottomVIew.hidden = NO;
        UIButton *but = (UIButton *)[self.view viewWithTag:11];
        [but removeFromSuperview];
        
        
    } else if (curModel.state == 2 ) {
        // 进行中
        [_timer invalidate];
        [self performSegueWithIdentifier:@"root2order" sender:nil];
        [self.orderStateView removeFromSuperview];
        self.bottomVIew.hidden = NO;
        UIButton *but = (UIButton *)[self.view viewWithTag:11];
        [but removeFromSuperview];
        
        
    } else {
        self.orderStateView.hidden = YES;
        self.bottomVIew.hidden = NO;
        UIButton *but = (UIButton *)[self.view viewWithTag:11];
        [but removeFromSuperview];
    }

}
#pragma mark - 定时器执行的方法
- (void)updateOrderState:(UIButton *)sender {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在查询状态";
    [[OrderModel currentOrderModel] syncRemoteStatus:^(NSError *error) {
       // [hud hide:YES];
        
    }];
}

- (void)cancelOrderBooking:(UIButton *)sender {
    OrderModel * curOrderModel = [OrderModel currentOrderModel];
    if (curOrderModel.state != 0) {
        [RootViewController toastShow:self.view message:@"在预约才可以取消"];
        //[self.orderStateView removeFromSuperview];
        return;
    }
    
    [curOrderModel cancelBooking:@"就是任性" complete:^(NSError *error) {
        [RootViewController toastShow:self.view message:@"取消预约成功"];
        self.bottomVIew.hidden = NO;
        UIButton *but = (UIButton *)[self.view viewWithTag:11];
        [but removeFromSuperview];
        
        //[self.orderStateView removeFromSuperview];
    }];
}


/** 
 * 刷新周边导游状态
 *
 **/
- (void) checkNavStatus {
    [MobClick event:@"controller_check_nav"];
    
    //NSLog(@"%s[INFO], %@", __func__, self.mapView.userLocation.location.debugDescription);
    QUserLocation *qLocation = self.mapView.userLocation;
    CLLocation *location = qLocation.location;
    
    if (!location) { // 位置为空，定位失败
        return;
    }

    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:self.userModel.token forKey:@"token"];
    [params setValue:self.userModel.ID forKey:@"id"];
    [params setValue:[NSString stringWithFormat:@"%f", longitude] forKey:@"longitude"];
    [params setValue:[NSString stringWithFormat:@"%f", latitude] forKey:@"latitude"];
    
    AFHTTPSessionManager *manager = [BK httpSessioManager];
    NSString *urlString = @"http://carcrm.gotoip1.com/api_tourists/get_near_guides";
    NSLog(@"%s[INFO] url: %@\n      parameters: %@", __func__, urlString, params);
    
    // 先不处理频率的问题
    NSURLSessionDataTask *task = [manager POST:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%s[INFO], %@", __func__, responseObject);
        if ([[BK getStringFromObject:responseObject byName:@"code"] intValue] == 1000) {
            self.navList = [responseObject objectForKey:@"results"];
            [self initMapViewAnnotation];
            
//            MBProgressHUD *h = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            h.mode = MBProgressHUDModeText;
//            h.labelText = @"已经获取周边导游";
//            [h hide:YES afterDelay:2];
        } else {
//            [BK alert:@"获取周边导游失败"];
            [RootViewController toastShow:self.view message:@"获取周边导游失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [RootViewController toastShow:self.view message:@"网络异常，请稍后重试"];
    }];
}

/** 初始化地图标，导游位置显示 **/
- (void) initMapViewAnnotation{
    
    if (!self.mapAnnotation) {
        self.mapAnnotation = [NSMutableArray array];
    }
    [self.mapView removeAnnotations:self.mapAnnotation];
    [self.mapAnnotation removeAllObjects];
    for (NSDictionary * nav in self.navList) {
        QPointAnnotation *navAnn = [[QPointAnnotation alloc] init];
        navAnn.coordinate = CLLocationCoordinate2DMake([[nav valueForKey:@"latitude"] floatValue], [[nav valueForKey:@"longitude"] floatValue]);
        navAnn.title = [nav valueForKey:@"gname"];
//        QAnnotationView * guidePoint =[[QAnnotationView alloc]initWithAnnotation:navAnn reuseIdentifier:@"guide"];
//        guidePoint.image = [UIImage imageNamed:@"ren.png"];
//        [self.mapView viewForAnnotation:navAnn];
        
        [self.mapAnnotation addObject:navAnn];
    }
    
    QPointAnnotation *red = [[QPointAnnotation alloc] init];
    red.coordinate = CLLocationCoordinate2DMake(36, 120);
    red.title    = @"Red";
    red.subtitle = [NSString stringWithFormat:@"{%f, %f}", red.coordinate.latitude, red.coordinate.longitude];
    [self.mapAnnotation addObject:red];
    
    [self.mapView addAnnotations:self.mapAnnotation];
}

/** 创建订单 **/
- (void)createOrder{
    
    [MobClick event:@"controller_create_book"];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (!self.mapView.userLocation || !self.mapView.userLocation.location) {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"正在定位，请稍后重试";
        [self.hud hide:YES afterDelay:2];
        return;
    }
    
    self.hud.labelText = @"正在预约";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if((self.destinationAddress.text == nil)||[self.destinationAddress.text isEqualToString:@""]){
        
        [params setValue:@"我要去河南" forKey:@"book_text"];
    }else{
    [params setValue:self.destinationAddress.text forKey:@"book_text"];
    }
    
    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
    
    [params setValue:[NSNumber numberWithDouble:coord.longitude] forKey:@"longitude"];

    [params setValue:[NSNumber numberWithDouble:coord.latitude] forKey:@"latitude"];
    
    [[OrderModel currentOrderModel] createBooking:^(NSError *error) {
        self.hud.labelText = @"待导游接单";
        [self.hud hide:YES afterDelay:1];
    } filter:params];
    
    
    // 跳转到订单详情
//    [self performSegueWithIdentifier:@"root2order" sender:nil];
//    [self payOrder];
    
}

/** 取消定单 **/
- (void) cancelOrder:(NSString *) why{
    
}

- (void) sharedApp {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"567636e467e58e3761003370"
                                      shareText:@"你要分享的文字"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIViewController *viewController = [segue destinationViewController];
    
    if ([viewController isKindOfClass:[BKMoreInfoViewController class]]) {
        ((BKMoreInfoViewController *) viewController).delegate = self;
    }
}

- (UserModel *)userModel{
    if (!_userModel) {
        _userModel = [UserModel sharedModel];
    }
    return _userModel;
}

+ (MBProgressHUD *) toastShow: (UIView *) view message:(NSString *) message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud hide:YES afterDelay:2];
    return hud;
}

@end
