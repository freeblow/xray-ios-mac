//
//  AppDelegate.m
//  xNetFuture
//
//  Created by 杨雨东 on 2023/6/16.
//

#import "AppDelegate.h"
#import <YoFuture/YoFuture.h>
#import <MMKV/MMKV.h>

@interface AppDelegate ()<YDVPNManagerDelegate>
{
    MMKV *_defaultMMKV;
}
@end

@implementation AppDelegate
{
    NSString *_defaultDocDir;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    YDVPNManager.sharedManager.delegate = self;
    [MMKV initializeMMKV:self.defaultDocDir];
    const char* cryptoKey = "lovelike08150802";
    _defaultMMKV = [MMKV defaultMMKVWithCryptKey:[NSData dataWithBytesNoCopy:(void *)cryptoKey length:16 freeWhenDone:NO]];
}

-(NSString *)defaultDocDir {
    if (!_defaultDocDir) {
        NSString *dir = [NSString stringWithFormat:@"%@/Documents/Future", NSHomeDirectory()];
        BOOL isDirectory = NO;
        BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDirectory];
        if (!exist || !isDirectory) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        _defaultDocDir = dir;
    }
    return _defaultDocDir;
}

-(void)setObject:(NSObject *)object forKey:(NSString *)forKey {
    [_defaultMMKV setObject:(NSObject<NSCoding> *)object forKey:forKey];
}

-(BOOL)getBoolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [_defaultMMKV getBoolForKey:key defaultValue:defaultValue];
}

-(void)setBool:(BOOL)v forKey:(NSString *)forKey {
    [_defaultMMKV setBool:v forKey:forKey];
}

-(NSObject *)getObjectOfClass:(Class)xclass forKey:(NSString *)forKey {
    return [_defaultMMKV getObjectOfClass:xclass forKey:forKey];
}


-(void)makeToast:(NSString *)toast {
    
}

-(void)makeToast:(NSString *)toast inView:(NSView *)inView maxWidth:(CGFloat)maxWidth {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end
