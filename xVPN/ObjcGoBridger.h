//
//  ObjcGoBridger.h
//  xVPN
//
//  Created by 杨雨东 on 2022/10/27.
//

#import <Foundation/Foundation.h>
#import <VPN/VPN.h>
#include "socks5.h"

NS_ASSUME_NONNULL_BEGIN

@interface xObjcGoHandler : NSObject
@property (nonatomic, strong)id<VPNAppleWriterPacketFlow> flow;
@property (nonatomic)struct ip header;
@property (nonatomic)long long activityTime;
- (void)close;

-(NSData *)NewIPPacket:(NSData *)payload len:(int)len remotePort:(uint16_t)remotePort localPort:(int)localPort;
@end

NS_ASSUME_NONNULL_END
