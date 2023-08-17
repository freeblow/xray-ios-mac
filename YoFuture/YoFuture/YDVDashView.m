//
//  YDDashView.m
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/4.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import "YDVDashView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YDVDashView{
    CAShapeLayer *_shapeLayer;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = YES;
        _cornorRadius = 0;
        _lineWidth = 1;
        _shapeLayer = [CAShapeLayer new];
        _lineDashPattern = @[@5.2, @5.2];
        [self.layer addSublayer:_shapeLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.wantsLayer = YES;
        _lineWidth = 1;
        _shapeLayer = [CAShapeLayer new];
        _lineDashPattern = @[@5.2, @5.2];
        [self.layer addSublayer:_shapeLayer];
    }
    return self;
}

-(void)setDashTintColor:(NSColor *)dashTintColor {
    _dashTintColor = dashTintColor;
    _shapeLayer.strokeColor = self.dashTintColor.CGColor;
}

-(void)setCornorRadius:(CGFloat)cornorRadius {
    _cornorRadius = cornorRadius;
    [self draw];
}

-(void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self draw];
}

-(void)setLineDashPattern:(NSArray *)lineDashPattern {
    _lineDashPattern = lineDashPattern;
    [self draw];
}

-(void)draw {
    
    NSRect shapeBounds = NSMakeRect(0, 0, self.bounds.size.width - _shapeLayer.lineWidth, self.bounds.size.height - _shapeLayer.lineWidth);
    CGFloat shapeRadius = _cornorRadius == 0 ? 0.2 * shapeBounds.size.height : _cornorRadius;
    if (2 * shapeRadius > shapeBounds.size.height || 2 * shapeRadius > shapeBounds.size.width) return;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, nil, shapeBounds, shapeRadius, shapeRadius);
    
    _shapeLayer.path = path;
    _shapeLayer.bounds = shapeBounds;
    _shapeLayer.lineWidth = _lineWidth;
    _shapeLayer.position = CGPointMake(0.5 * _shapeLayer.lineWidth, 0.5 * _shapeLayer.lineWidth);
    _shapeLayer.strokeColor = self.dashTintColor ? self.dashTintColor.CGColor : NSColor.lightGrayColor.CGColor;
    _shapeLayer.fillColor = nil;
    _shapeLayer.lineDashPattern = _lineDashPattern;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.anchorPoint = CGPointMake(0, 0);
    CGPathRelease(path);
}

-(void)layout {
    [super layout];
    [self draw];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
