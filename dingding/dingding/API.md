# API 接口文档

## 几个问题 

1. 用户的信息获取，除了登录接口是否还有其它方式？ 
2. 用户信息修改可否合并为同一个接口？ 
3. 部分信息查询的接口，除了上传token 以外，还需要上传用户ID，订单号，这些信息是否必须？ 
4. 如何处理以下流程： 
    用户拿到一手机 -> 登录 -> 获取未完成订单信息
    即使可以通过获取订单列表来获取的有订单状态，此接口有无高级筛选接口？游客端是否可用？ 





## 基本信息

> HOST: http://carcrm.gotoip1.com

## 用户认证

#### 登录 
* url: api_tourists/login
    * post: 

```
    {
        mobile:		游客手机号
        password ：	密码
    }
    

    {
        code：1000 //OK
        message：操作成功
        id:	 	游客id
        token  ：[对应游客的token信息]
        tname ：姓名
        sex ：		性别 （1，,男；0，女）
        education : 	教育程度
        mobile : 		手机号
        avatar : 		头像; 显示示例：http://x.com/upload/images/avatar/[avatar]
        dob : 		出生年月
        card_no : 		银行卡号
        alipay_no : 	支付宝号
        a_balance : 	账户余额
        code: 1001 //Fail
        message: [对应的错误提示信息]
    }
```

#### 修改密码

找回密码{ 
第1步：获取验证码

Url:api_tourists/reset_pwd/
get{
1
手机号
}
示例：/api_tourists/reset_pwd/1/18277221199

服务端返回{
code：1000 //OK
message：验证码已发送，请注意查收。

code：1001 //Fail
message：[对应的错误提示信息]
}


第2步：检查获取到的验证码

url: api_tourists/reset_pwd/
get{
2
手机号
验证码
}
示例：/api_tourists/reset_pwd/2/18277221199/2222

服务端返回{
code：1000  //OK
message：	手机验证成功
id: 	 		游客id
token:	 	游客token

code：1001 //Fail
message：[对应的错误提示信息]
}


第3步：设置新密码

url: api_tourists/form
post: {
id:			游客id
token:		游客token
password: 	新密码
}

服务端返回{
code：1000 //OK
message：操作成功

code：1001 //Fail
message：[对应的错误提示信息]
}
}

#### 注册

游客注册{ 
url: api_tourists/reg
post: {
mobile:		游客手机号
vcode :		手机验证码
password ：	密码
}

服务端返回{
code：1000 //OK
message：操作成功
id:	 游客id
token  ：[游客的token信息]

code：1001 //Fail
message：[对应的错误提示信息] 
}

}

#### 信息修改

游客信息修改{ 

基本信息：
url: api_tourists/form
post: {
id:			游客id
token:		游客token
userfile ：	头像
tname ：		姓名
sex ：		性别; 1,男; 0,女
dob ：		出生年月; DATE字段
education ：	教育程度

}

支付宝账号：
url: api_tourists/form
post: {
id:		游客id
token:		游客token
alipay_no ：	支付宝账号
}
}

密码修改{
url: api_tourists/update_pwd
post: {
id:				游客id
token:			游客token
password_old:		原密码
password: 		新密码
}


服务端返回{
code：1000 //OK
message：操作成功
avatar:	游客头像文件名(仅编辑了头像信息时需要，其余信息编辑无需关注)

code：1001 //Fail
message：[对应的错误提示信息]
}
}

#### 位置信息

游客上报gps位置{
url: api_tourists/get_position
post: {
id:			游客id
token:		游客token
tname:：		游客姓名
sex：		游客性别
mobile：		游客手机号
longitude： 	经度
latitude： 	纬度
speed： 		速度
direction： 	方向
}

服务端返回{
code：1000 //OK
message：操作成功

code：1001 //Fail
message：[对应的错误提示信息]
}
}

游客获取附近导游列表{ 
url: api_tourists/get_near_guides
post: {
id:			游客id
token:		游客token
longitude： 	经度
latitude： 	纬度
speed： 		速度
direction： 	方向
}

服务端返回{
code：1000 //OK
message： 操作成功
result:	  导游列表(因新增筛选条件，字段待详细描述)

code：1001 //Fail
message：[对应的错误提示信息]
}
}


************************************ 




付款流程{
·支付宝接口完成充值跳转后，通知接收页
url: /alipay/do_notify

·微信支付待研究
·银行卡支付用哪家的接口？网银/银联 ？
}

#游客发布预约(下单){ 
url: api_tourists/book
post: {
tid:			游客id
token:		游客token
tmobile:		游客手机号
book_text：	预约内容
rg_sex ：  	要求目标导游性别： 1,男；0，女
rg_age ：  	要求目标导游年龄范围(年龄段，如80后为数字8，90后为数字9)
rg_star ： 	要求目标导游的评级(达到的星数)
longitude： 	经度
latitude： 	纬度
speed： 		速度
direction： 	方向
}

服务端返回{
code：1000 //OK
message：操作成功
book_id：发布的预约id
result: 	 附近符合条件的导游总数

code：1001 //Fail
message：[对应的错误提示信息]
}
}

#游客取消预约(取消下单){
url: api_tourists/cancel_booking
post: {
book_id:		预约id
id:			游客id
token:		游客token
rt_cancel：	取消原因（请限制为30个汉字内）
}

服务端返回{
code：1000 //OK
message：操作成功

code：1001 //Fail
message：[对应的错误提示信息]
}
}

#游客的预约状态查询(订单状态查询){

url: api_tourists/get_booking_status 
get{
预约id
}

示例：http://xx.com/api_tourists/get_booking_status/1

订单状态 (0，预约中、1，待付款、2，进行中、3，待确认、4，已完成、5，已取消、6，已关闭、7，申请退款、8，同意退款、9，已退款、10，拒绝退款) 

服务端返回{
code：1000 //OK
message：操作成功
result  ：	  状态码(0, 预约中; 1, 待付款; 2, 进行中 ……) 
result_msg  ：状态文本( 预约中;  待付款;  进行中等)

has_paid：状态(0，未付款、1，已付款)
rt_cancel：游客取消预约的原因
gr_cancel：导游回应游客取消预约的原因

code：1001 //Fail
message：[对应的错误提示信息]
}

}

#游客用户登录{ 
url: api_tourists/login
post: {
mobile:		游客手机号
password ：	密码
}


#* 提交评价 { 


url: /api_tourists/evaluate
post{
id:			游客id
t_token: 		游客token，
tmobile: 		游客手机号
gid:    		导游id，
gname:  		姓名，
eval_all:    	总体评价( 1 [好评]；2 [中评]； 3 [差评]；)，//设计图无此项，可忽略
eval_text: 	评价内容(文本)，
eval_star：	星级(1 - 5星，整数)
}

服务端返回{
code：1000 //OK
message：操作成功

code：1001 //Fail
message：[对应的错误提示信息]
}

}

#* 投诉{ 
url: /api_tourists/complain
post{
id:		游客id
t_token: 	游客token，
tmobile: 游客手机号
gid:    	导游id，
gname:  	导游姓名，
gmobile:	导游手机号
complain_text:  游客投诉事项

}

服务端返回{
code：1000 //OK
message：操作成功

code：1001 //Fail
message：[对应的错误提示信息]
}


}

|* 分享// 暂不考虑，主要是第三方




#导游{

//---导游：我的订单-----------------------------------------------------------------
/api_tguides/my_orders
post{
gid：导游id
token：导游token
state：订单(预约)状态：1，已完成；0，未完成
page_number：要显示的页码；默认12条记录一页
}

return {
code: 1000 //OK
code: 1001 //err
message：对应的消息提示

results{
id（订单id）,tid（游客id）,tname（游客姓名）,book_text（订单内容）,state（订单状态）, book_time（订单时间）,trade_no（订单号）,gid（导游id）
}
}

//---获取app版本信息----------------------------------------------------------------- 
/api_app_info/get_app_info
get{
type：类型，1，安卓游客app；2，安卓导游app；3，ios游客app；4，ios导游app；
}

return{
asize：        软件大小
version：      版本号 
nf_list：      新增功能列表，类似：“功能1|功能2|功能3|建议您升级到新版本”
url_download：  app 下载地址
}

//---获取app帮助列表（问答）-----------------------------------------------------------------  
/api_app_info/get_help_qa
get{
type：类型，1，用于游客；0，用于导游
}  

return{
results{
id：问答id
question：问题
answer：回答

}
}

//---获取app文章内容（游客、导游端共用）-----------------------------------------------------------------  
/api_app_info/get_app_article
get{
type：类型，1，游客用户指南；2，导游用户指南；3，关于滴滴；4，用户注册协议；5，支付宝使用协议
}  

return{
code:100 //ok
message:对应的消息内容

result{
title：   文章标题
content： 文章内容
add_time：发布时间

}
}  

//---导游发送服务完毕信号-----------------------------------------------------------------        
/api_tguides/service_is_completed
调用条件：只有进行中的订单才可以进行此操作[state = 2，进行中]

post{
gid：导游id
token：导游token
trade_no：订单(预约)号
}

return {
code: 1000 //OK
code: 1001 //err
message：对应的消息提示
}

//---获取导游余额----------------------------------------------------------------- 
/api_tguides/get_balance 
post{
gid：导游id
token：导游token
}
return {
result:{
margin：保证金
a_balance：导游账户余额(总额)
}

results:{
tag：5，平台提现给导游     (设计图中的“提现”)
3，游客确认支付给导游 (设计图中的“订单”)
tname：游客姓名
mobile:游客手机号
amt_of_money：金额
cre_time：交易时间
}


}   

导游可提现的最大额度 = a_balance - margin，申请额超过最大额度请予以提示。服务端已禁止。

//---导游申请提现-----------------------------------------------------------------        
/api_tguides/apply_for_withdrawal
调用条件：导游身份通过审核，且提现数量不超过最大可提现额度

post{
gid：导游id
token：导游token
gmobile；手机号
gname：姓名
sex：性别
amount：提现金额
}

return {
code: 1000 //OK
code: 1001 //err
message：对应的消息提示
} 

//---导游评价游客-----------------------------------------------------------------        
/api_tguides/evaluate

post{
gid：    导游id
g_token：导游token
tid：    游客id    
tmobile；游客手机号
gname：  导游姓名
eval_text：评价内容

}

return {
code: 1000 //OK
message：对应的消息提示
}   

//---滴滴播报-----------------------------------------------------------------    
/api_app_info/get_broadcasts
get{
type
}

return{
results:{
title, 标题
abstract, 摘要
content, 内容
add_time，发布时间
}  
}

//---游客查询发布的订单是否有导游接单-----------------------------------------------------------------        
/api_tourists/get_guide_for_order
post{
tid：游客id
token：游客token
trade_no: 订单号
}

return{
gid,接单的导游id；如无导游接单则为0
} 

//---导游获取游客新发布的订单-----------------------------------------------------------------        
/api_tguides/get_new_orders
post{
gid：导游id
token：游客token
sex：导游性别
dob：导游出生年月
star_grade：导游星级
longitude：经度
latitude：    纬度
}

return{
tmobile, 游客手机号
tname, 游客姓名
avatar, 游客头像
book_text, 预约内容
longitude, 发布预约时的经度
latitude, 发布预约时的纬度
trade_no，订单号
}

}

