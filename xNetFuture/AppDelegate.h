//
//  AppDelegate.h
//  xNetFuture
//
//  Created by 杨雨东 on 2023/6/16.
//

#import <Cocoa/Cocoa.h>

@protocol YDVPNManagerDelegate <NSObject>

-(void)setObject:(NSObject *)object forKey:(NSString *)forKey;

-(BOOL)getBoolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

-(void)setBool:(BOOL)v forKey:(NSString *)forKey;

-(void)makeToast:(NSString *)toast;

-(void)makeToast:(NSString *)toast inView:(NSView *)inView maxWidth:(CGFloat)maxWidth;

-(NSObject *)getObjectOfClass:(Class)xclass forKey:(NSString *)forKey;

@end

@interface AppDelegate : NSObject <NSApplicationDelegate, YDVPNManagerDelegate>


@end

