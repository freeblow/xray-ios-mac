//
//  YDTextField.m
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/7.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import "YDVTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation YDVPopTextField
- (void)textDidEndEditing:(NSNotification *)notification {
    [super textDidEndEditing:notification];
    [self.xdelegate textDidChanged:self];
}
- (BOOL)textShouldBeginEditing:(NSText *)textObject {
    BOOL x = [super textShouldBeginEditing:textObject];
    NSTextView* textField = (NSTextView*) [self currentEditor];
    if(self.cursorColor && [textField respondsToSelector: @selector(setInsertionPointColor:)])
        [textField setInsertionPointColor: self.cursorColor];
    return x;
}

-(BOOL)becomeFirstResponder {
    BOOL  success = [super becomeFirstResponder];
    if(success){
        // Strictly spoken, NSText (which currentEditor returns) doesn't
        // implement setInsertionPointColor:, but it's an NSTextView in practice.
        // But let's be paranoid, better show an invisible black-on-black cursor
        // than crash.
        NSTextView* textField = (NSTextView*) [self currentEditor];
        if(self.cursorColor && [textField respondsToSelector: @selector(setInsertionPointColor:)] )
            [textField setInsertionPointColor:self.cursorColor];
    }
    return success;
}

@end


@implementation YDVPopTextFieldCell
{
    BOOL mIsEditingOrSelecting;
}
- (NSRect)drawingRectForBounds:(NSRect)theRect {
    NSRect newRect = [super drawingRectForBounds:theRect];
    if (!mIsEditingOrSelecting) {
        // Get our ideal size for current text
        NSSize textSize = [self cellSizeForBounds:theRect];

        // Center in the proposed rect
        CGFloat heightDelta = newRect.size.height - textSize.height;
        if (heightDelta > 0) {
            newRect.size.height -= heightDelta;
            newRect.origin.y += heightDelta/2;
        }
    }
    return newRect;
}

-(void)selectWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength {
    NSRect arect = [self drawingRectForBounds:rect];
    mIsEditingOrSelecting = true;
    [super selectWithFrame:arect inView:controlView editor:textObj delegate:delegate start:selStart length:selLength];
    mIsEditingOrSelecting = false;
}

-(void)editWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event {
    NSRect aRect = [self drawingRectForBounds:rect];
    mIsEditingOrSelecting = true;
    [super editWithFrame:aRect inView:controlView editor:textObj delegate:delegate event:event];
    mIsEditingOrSelecting = false;
}
@end
