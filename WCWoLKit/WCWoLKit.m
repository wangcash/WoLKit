//
//  WCWoLKit.m
//  WCWoLKit
//
//  Created by Cash on 13-2-28.
//  Copyright (c) 2013年 2B Studio. All rights reserved.
//

#import "WCWoLKit.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/ethernet.h>
#include <unistd.h>

@implementation WCWoLKit

@synthesize udpSocket;

/*
 * Convert option into a mac address
 */
static struct ether_addr * get_opt_ether_addr(const char *opt)
{
  struct ether_addr *addr;
  
  addr = ether_aton(opt);
  if (!addr) {
    fprintf(stderr, "Error: bad mac address %s\n", opt);
    return (NULL);
  }
  return (addr);
}

/*
 * Setup magic packet
 */
static int setup_magic_packet(unsigned char *buf, struct ether_addr *dst)
{
  int i, off = 0;
  
  memset(buf+off, 0xff, 6);    /* magic packet */
  off += 6;
  for (i = 0; i < 16; i++) {
    memcpy(buf+off, dst->ether_addr_octet, 6);
    off += 6;
  }
  
  return (off);
}

- (void)wakingUpRemoteDevice:(NSString *)mac {
  NSLog(@"Wake up [%@]", mac);
  
  //char *mac = "11:22:33:44:55:66";
  
  struct ether_addr *dstaddr;
  unsigned char buf[1000];
  int pktlen;
  
  AsyncUdpSocket *socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
  
  NSError *error = nil;
  [socket bindToPort:10009 error:&error];
  [socket enableBroadcast:YES error:&error];
//[socket joinMulticastGroup:@"192.168.1.1" error:&error];
  
  if (error) {
    NSLog(@"error: %@",error);
  }
  
//    NSLog("mac = %s", [mac UTF8String]);
  
  dstaddr = get_opt_ether_addr([mac UTF8String]);
  pktlen = setup_magic_packet(buf, dstaddr);
  
  /*
   to.sin_addr.s_addr = inet_addr("255.255.255.255");
   setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &yes, sizeof (yes));
   ret = sendto(sock, buf, pktlen, 0, (struct sockaddr *)&to, sizeof (to));
   */
  
  [socket sendData:[[NSData alloc] initWithBytes:buf length:pktlen] toHost:@"255.255.255.255" port:9 withTimeout:-1 tag:0];
  
  [socket receiveWithTimeout:-1 tag:1];
  NSLog(@"start udp server");}

@end
