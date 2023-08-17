//
//  YDDashView.h
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/4.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDVDashView : NSView

/// 虚线颜色
@property (nonatomic, strong)NSColor *dashTintColor;

/// 圆角半径
@property (nonatomic)CGFloat cornorRadius;


@property (nonatomic)CGFloat lineWidth;


@property (nonatomic)NSArray *lineDashPattern;

@end

NS_ASSUME_NONNULL_END
