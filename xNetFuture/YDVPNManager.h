//
//  YDVPNManager.h
//  VPNExtension
//
//  Created by 杨雨东 on 2023/1/15.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ENABLE_SYSTEM_CONFIGURATION 1

#import <NetworkExtension/NetworkExtension.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YDProviderManagerCompletion)(NETunnelProviderManager *_Nullable manager);


@interface YDVPNManager : NSObject

+(instancetype)sharedManager;

-(void)fetchVPNManager:(YDProviderManagerCompletion)completion;

@property (nonatomic)BOOL isVPNActive;

-(void)applyConfiguration:(NSString *)mode;

@property (nonatomic, copy)NSString *vpn;

-(NSDictionary *)ping:(NSString *)x;

-(void)stopTunnelWithReason;
+(void)setLogLevel:(int)l;
+(void)setGlobalProxyEnable:(BOOL)enable;
+(void)setSocks5Enable:(BOOL)enable;
+(NSDictionary *)parseURI:(NSString *)uri;
-(void)startTunnelWithOptions:(NSDictionary *)op configuration:(NSDictionary *)x;

@end

NS_ASSUME_NONNULL_END
