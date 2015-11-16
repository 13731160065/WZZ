//
//  WZZXMPP.m
//  HelloXMPP
//
//  Created by MS on 15-10-8.
//  Copyright (c) 2015年 WZZ. All rights reserved.
//

#import "WZZXMPP.h"
#import "XMPPFramework.h"

@interface WZZXMPP()<XMPPStreamDelegate>

@end

@implementation WZZXMPP
{
    XMPPStream * _stream;
    NSString * _pass;
    BOOL isLogin;
}
static WZZXMPP * xmpp;


#pragma mark - 初始化方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmpp = [super allocWithZone:zone];
    });
    return xmpp;
}

+ (instancetype)defaultXMPP {
    return [[WZZXMPP alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stream = [[XMPPStream alloc] init];
        [_stream setHostPort:5222];
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

#pragma mark - 对象方法
- (void)loginWithHostIP:(NSString *)IP Jid:(NSString *)jid PassWord:(NSString *)pass {
    if ([_stream isConnected]) {
        [_stream disconnect];
    }
    isLogin = YES;
    [_stream setHostName:IP];
    _pass = pass;
    [_stream setMyJID:[XMPPJID jidWithString:jid]];
    [_stream connectWithTimeout:-1 error:nil];
}

- (void)registerWithHostIP:(NSString *)IP Jid:(NSString *)jid PassWord:(NSString *)pass {
    if ([_stream isConnected]) {
        [_stream disconnect];
    }
    isLogin = NO;
    [_stream setHostName:IP];
    _pass = pass;
    [_stream setMyJID:[XMPPJID jidWithString:jid]];
    [_stream connectWithTimeout:-1 error:nil];
}

- (void)getFriendsList {
    NSError * err;
    DDXMLElement * element = [[DDXMLElement alloc] initWithXMLString:@"<iq type=\"get\"><query xmlns=\"jabber:iq:roster\"/></iq>" error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
    [_stream sendElement:element];
}

- (void)sendMessageWithJid:(NSString *)jid text:(NSString *)text {
    /*
     <message type="chat" to=“jid“ msgType=“0”>
     <body>hello</body>
     </message>
     */
    DDXMLElement * body = [DDXMLElement elementWithName:@"body" stringValue:text];
    DDXMLElement * message = [DDXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:jid];
    [message addAttributeWithName:@"msgType" stringValue:@"0"];
    [message addChild:body];
    [_stream sendElement:message];
}


#pragma mark - 代理方法
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"连接建立");
    if (isLogin) {
        [sender authenticateWithPassword:_pass error:nil];
        NSLog(@"%@", _pass);
    } else {
        [sender registerWithPassword:_pass error:nil];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"连接断开%@", error);
}

#pragma mark 登陆
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"密码校验成功");
    XMPPPresence * presence = [XMPPPresence presence];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    [sender sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"密码校验失败, %@", error);
}

#pragma mark 注册
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"注册成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"register" object:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    NSLog(@"注册失败");
}

#pragma mark 获取好友列表
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    NSLog(@"%@", iq);
    DDXMLElement * element = [iq elementForName:@"query"];
    NSArray * eleArr = [element elementsForName:@"item"];
    NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:0];
    [eleArr enumerateObjectsUsingBlock:^(DDXMLElement * obj, NSUInteger idx, BOOL *stop) {
        NSString * jid = [[obj attributeForName:@"jid"] stringValue];
        [arr addObject:jid];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"friends" object:arr];

    return YES;
}

#pragma mark 接收信息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:[[message elementForName:@"body"] stringValue]];
}


@end
