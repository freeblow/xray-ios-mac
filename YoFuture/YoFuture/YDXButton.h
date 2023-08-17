//
//  YDButton.h
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/3.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDXButton : NSButton

/// 是否处于选择状态
@property (nonatomic)BOOL selected;

/// 选中颜色
@property (nonatomic, strong)NSColor *selectedColor;

/// 选中图片
@property (nonatomic, strong)NSImage *selectedImage;

/// 非选中默认图片
@property (nonatomic, strong)NSImage *normalImage;


@property (nonatomic, strong)NSURL *videoURL;

@end

NS_ASSUME_NONNULL_END
