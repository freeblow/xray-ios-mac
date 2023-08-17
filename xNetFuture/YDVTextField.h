//
//  YDTextField.h
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/7.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


@protocol YDVTextFieldDelegate <NSObject>

@optional
-(void)textDidChanged:(NSTextField *)field;

-(void)textFieldWillBeginEditing:(NSTextField *)field;

@end


@interface YDVPopTextField : NSTextField

@property (nonatomic, strong)NSColor *cursorColor;

@property (nonatomic, weak)id<YDVTextFieldDelegate> xdelegate;
@end

@interface YDVPopTextFieldCell : NSTextFieldCell

@end

NS_ASSUME_NONNULL_END
