//
//  YDVPNManager.m
//  VPNExtension
//
//  Created by 杨雨东 on 2023/1/15.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import "YDVPNManager.h"
#import <FutureSDK/FutureSDK.h>
#if ENABLE_SYSTEM_CONFIGURATION
#import <SystemConfiguration/SystemConfiguration.h>
#endif

NSString *const kApplicationVPNServerAddress = @"sg.linkv.vpn.mac.x";
NSString *const kApplicationVPNLocalizedDescription = @"Yo Wish VPN Packet Tunnel";

@implementation YDVPNManager

+(instancetype)sharedManager{
    static YDVPNManager *__manager__;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[self alloc] init];
    });
    return __manager__;
}

-(void)fetchVPNManager:(YDProviderManagerCompletion)completion {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if (managers.count == 0) {
            [self createVPNConfiguration:completion];
            if (error) {
                NSLog(@"loadAllFromPreferencesWithCompletionHandler: %@", error);
            }
            return;
        }
        [self handlePreferences:managers completion:completion];
    }];
}

- (void)handlePreferences:(NSArray<NETunnelProviderManager *> * _Nullable)managers completion:(YDProviderManagerCompletion)completion{
    NETunnelProviderManager *manager;
    for (NETunnelProviderManager *item in managers) {
        if ([item.localizedDescription isEqualToString:kApplicationVPNLocalizedDescription]) {
            manager = item;
            break;
        }
    }
    completion(manager);
    NSLog(@"Found a vpn configuration");
}

- (void)createVPNConfiguration:(YDProviderManagerCompletion)completion {
        
    NETunnelProviderManager *manager = [NETunnelProviderManager new];
    NETunnelProviderProtocol *protocolConfiguration = [NETunnelProviderProtocol new];
    
    protocolConfiguration.serverAddress = kApplicationVPNServerAddress;
    
    // providerConfiguration 可以自定义进行存储
    protocolConfiguration.providerConfiguration = @{};
    manager.protocolConfiguration = protocolConfiguration;

    manager.localizedDescription = kApplicationVPNLocalizedDescription;
    manager.enabled = YES;
    [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"saveToPreferencesWithCompletionHandler:%@", error);
            completion(nil);
            return;
        }
        [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"loadFromPreferencesWithCompletionHandler:%@", error);
                completion(nil);
            }
            else {
                completion(manager);
            }
        }];
    }];
}

-(void)applyConfiguration:(NSString *)mode {
#if ENABLE_SYSTEM_CONFIGURATION
    AuthorizationRef authRef;
    AuthorizationFlags authFlags = kAuthorizationFlagDefaults
    | kAuthorizationFlagExtendRights
    | kAuthorizationFlagInteractionAllowed
    | kAuthorizationFlagPreAuthorize;
    OSStatus ret = AuthorizationCreate(nil, kAuthorizationEmptyEnvironment, authFlags, &authRef);
    if (ret != noErr) {
        NSLog(@"No authorization has been granted to modify network configuration");
        return;
    }
    SCPreferencesRef prefRef = SCPreferencesCreateWithAuthorization(nil, CFSTR("Yo Wish VPN"), nil, authRef);
    NSDictionary *sets = (__bridge NSDictionary *)SCPreferencesGetValue(prefRef, kSCPrefNetworkServices);
    for (NSString *key in [sets allKeys]) {
        NSMutableDictionary *dict = [sets objectForKey:key];
        NSString *hardware = [dict valueForKeyPath:@"Interface.UserDefinedName"];
        if ([hardware isEqualToString:@"Wi-Fi"] || [hardware isEqualToString:@"Ethernet"]) {
            NSMutableDictionary *proxies = [sets[key][@"Proxies"] mutableCopy];
            [proxies setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCFNetworkProxiesHTTPEnable];
            [proxies setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCFNetworkProxiesHTTPSEnable];
            [proxies setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCFNetworkProxiesSOCKSEnable];
            if ([mode isEqualToString:@"global"]) {
                int socksPort = 1081;
                int httpPort = 1082;
                NSLog(@"in helper %d %d", socksPort, httpPort);
                if (socksPort > 0) {
                    [proxies setObject:@"127.0.0.1" forKey:(NSString *)kCFNetworkProxiesSOCKSProxy];
                    [proxies setObject:[NSNumber numberWithInt:socksPort] forKey:(NSString*)kCFNetworkProxiesSOCKSPort];
                    [proxies setObject:[NSNumber numberWithInt:1] forKey:(NSString*)kCFNetworkProxiesSOCKSEnable];
                }
                if (httpPort > 0) {
                    [proxies setObject:@"127.0.0.1" forKey:(NSString *)kCFNetworkProxiesHTTPProxy];
                    [proxies setObject:@"127.0.0.1" forKey:(NSString *)kCFNetworkProxiesHTTPSProxy];
                    [proxies setObject:[NSNumber numberWithInt:httpPort] forKey:(NSString*)kCFNetworkProxiesHTTPPort];
                    [proxies setObject:[NSNumber numberWithInt:httpPort] forKey:(NSString*)kCFNetworkProxiesHTTPSPort];
                    [proxies setObject:[NSNumber numberWithInt:1] forKey:(NSString*)kCFNetworkProxiesHTTPEnable];
                    [proxies setObject:[NSNumber numberWithInt:1] forKey:(NSString*)kCFNetworkProxiesHTTPSEnable];
                }
            }
            Boolean isOK = SCPreferencesPathSetValue(prefRef, (__bridge CFStringRef)[NSString stringWithFormat:@"/%@/%@/%@", kSCPrefNetworkServices, key, kSCEntNetProxies], (__bridge CFDictionaryRef)proxies);
            NSLog(@"System proxy apply:%d", isOK);
        }
    }
    SCPreferencesCommitChanges(prefRef);
    SCPreferencesApplyChanges(prefRef);
    SCPreferencesSynchronize(prefRef);
    AuthorizationFree(authRef, kAuthorizationFlagDefaults);
    self.isVPNActive = [mode isEqualToString:@"global"];
#endif
}

-(NSDictionary *)ping:(NSString *)ip {
    NSString *pings = [LVFutureManager ping:[NSString stringWithFormat:@"[\"%@\"]", ip]];
    NSDictionary *r = @{@"action":@"response", @"type":@"ping", @"pings":pings};
    return r;
}

-(void)stopTunnelWithReason{
    [[LVFutureManager sharedManager] stopTunnelWithReason];
}

+(void)setLogLevel:(int)l {
    [LVFutureManager setLogLevel:l];
}

+(void)setGlobalProxyEnable:(BOOL)enable {
    [LVFutureManager setGlobalProxyEnable:enable];
}

+(void)setSocks5Enable:(BOOL)enable {
    [LVFutureManager setSocks5Enable:enable];
}

+(NSDictionary *)parseURI:(NSString *)uri {
    return [LVFutureManager parseURI:uri];
}

-(void)startTunnelWithOptions:(NSDictionary *)op configuration:(NSDictionary *)x {
    [[LVFutureManager sharedManager] startTunnelWithOptions:op configuration:x];
}

@end
