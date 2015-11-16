//
//  WZZXMPP.h
//  HelloXMPP
//
//  Created by MS on 15-10-8.
//  Copyright (c) 2015年 WZZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XMPPNotificationLogin       @"login"
#define XMPPNotificationRegister    @"register"
#define XMPPNotificationFriend      @"friend"
#define XMPPNotificationMessage     @"message"

@interface WZZXMPP : NSObject

+ (instancetype)defaultXMPP;

- (void)loginWithHostIP:(NSString *)IP Jid:(NSString *)jid PassWord:(NSString *)pass;
- (void)registerWithHostIP:(NSString *)IP Jid:(NSString *)jid PassWord:(NSString *)pass;
- (void)getFriendsList;
- (void)sendMessageWithJid:(NSString *)jid text:(NSString *)text;

@end
