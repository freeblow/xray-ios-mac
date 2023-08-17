//
//  xVPNProtocolParser.h
//  xVPN
//
//  Created by LinkV on 2022/11/1.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    xVPNProtocolVmess,
    xVPNProtocolVless,
} xVPNProtocol;


NS_ASSUME_NONNULL_BEGIN

@interface ProtocolParser : NSObject
+(nullable NSDictionary *)parse:(NSString *)uri protocol:(xVPNProtocol)protocol;

+(void)setHttpProxyPort:(uint16_t)port;

+(uint16_t)HttpProxyPort;

+(void)setLogLevel:(NSString *)level;

+ (void)setGlobalProxyEnable:(BOOL)enable;

+ (void)setDirectDomainList:(NSArray *)list;

+ (void)setProxyDomainList:(NSArray *)list;

+ (void)setBlockDomainList:(NSArray *)list;

+ (void)setSocks5Enable:(BOOL)socks5Enable;

@end

NS_ASSUME_NONNULL_END
