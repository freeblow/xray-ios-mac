//
//  PacketTunnelProvider.m
//  VPNPacketTunnel
//
//  Created by badwin on 2023/1/4.
//

#import "PacketTunnelProvider.h"
#import <FutureSDK/FutureSDK.h>

@implementation PacketTunnelProvider

+ (void)LOGRedirect {
    NSString *logFilePath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), @"xray.log"];
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:logFilePath] error:nil];
    [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stderr);
}

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
    [PacketTunnelProvider LOGRedirect];
    if (!options) {
        NETunnelProviderProtocol *protocolConfiguration = (NETunnelProviderProtocol *)self.protocolConfiguration;
        NSMutableDictionary *copy = protocolConfiguration.providerConfiguration.mutableCopy;
        options = copy[@"configuration"];
    }
    // Add code here to start the process of connecting the tunnel.
    [[LVFutureManager sharedManager] setPacketTunnelProvider:self];
    [[LVFutureManager sharedManager] startTunnelWithOptions:options completionHandler:completionHandler];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    // Add code here to start the process of stopping the tunnel.
    completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler {
    // Add code here to handle the message.
    
    
    
    [LVFutureManager setLogLevel:(xLogLevelWarning)];
    [LVFutureManager setGlobalProxyEnable:NO];
    
    NSDictionary *app = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:nil];
    NSInteger type = [app[@"type"] integerValue];
    NSString *version = [LVFutureManager version];
    // 设置配置文件
    if (type == 0) {
        NSString *configuration = app[@"configuration"];
        [[LVFutureManager sharedManager] setupURL:configuration];
    }
    NSDictionary *response = @{@"desc":@(200), @"version":version, @"tunnel_version":@"1.0.7"};
    NSData *ack = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
    completionHandler(ack);
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
    // Add code here to get ready to sleep.
    completionHandler();
}

- (void)wake {
    // Add code here to wake up.
}

@end
