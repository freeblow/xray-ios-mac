//
//  NSSocks5Manager.h
//  AppProxyProvider
//
//  Created by LinkV on 2022/10/22.
//

#import <Foundation/Foundation.h>

#define ENABLE_APPLE_NETWORK_EXTENSION 1
#define ENABLE_APPLICATION_VPN 1

#if ENABLE_APPLE_NETWORK_EXTENSION
#import <NetworkExtension/NetworkExtension.h>
#endif

#define THROW_EXCEPTION(v) if(v) {NSLog(@"xx-%@", v); return;}

NS_ASSUME_NONNULL_BEGIN

typedef void(^VPNDelayResponse)(BOOL isSuccess, float delay);

typedef enum : NSUInteger {
    xLogLevelVerbose,
    xLogLevelInfo,
    xLogLevelWarning,
    xLogLevelError
} xLogLevel;

@protocol NSVPNManagerDelegate <NSObject>

/// 网速回调，一秒一次
/// - Parameter speed: 单位 bps
/// - Parameter uplink: YES 表示上传，NO 表示下载
-(void)onConnectionSpeedReport:(NSInteger)speed uplink:(BOOL)uplink;

@end


@interface LVFutureManager : NSObject
+ (instancetype)sharedManager;

@property (nonatomic, weak)id <NSVPNManagerDelegate> delegate;

@property (nonatomic, strong, readonly)NSArray *DNS;

+ (NSString *)version;

+ (void)setLogLevel:(xLogLevel)level;

+ (void)setHttpProxyPort:(uint16_t)port;

+ (void)setGlobalProxyEnable:(BOOL)enable;

+ (void)setDirectDomainList:(NSArray *)list;

+ (void)setProxyDomainList:(NSArray *)list;

+ (void)setBlockDomainList:(NSArray *)list;

+ (void)setSocks5Enable:(BOOL)socks5Enable;

+ (NSDictionary *)parseURI:(NSString *)uri;

+ (NSString *)ping:(NSString *)ips;

#if ENABLE_APPLE_NETWORK_EXTENSION
- (NSArray<NSString *> *)allDNSServer;

- (void)setPacketTunnelProvider:(NEPacketTunnelProvider *)provider;

- (void)startTunnelWithOptions:(nullable NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler;

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler;

- (void)wake;

- (void)google204Delay:(nullable VPNDelayResponse)response;

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler;

- (BOOL)setupURL:(NSString *)url;
#endif

#if ENABLE_APPLICATION_VPN
- (void)startTunnelWithOptions:(nullable NSDictionary *)options configuration:(NSDictionary *)configuration;

- (void)stopTunnelWithReason;
#endif

@end

NS_ASSUME_NONNULL_END
