//
//  WCWoLKit.h
//  WCWoLKit
//
//  Created by Cash on 13-2-28.
//  Copyright (c) 2013年 2B Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@interface WCWoLKit : NSObject{
	AsyncUdpSocket *udpSocket;
}

@property (nonatomic, assign) AsyncUdpSocket *udpSocket;

- (void)wakingUpRemoteDevice:(NSString *)mac;

@end
