//
//  YDButton.m
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/3.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import "YDXButton.h"

@implementation YDXButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)setSelected:(BOOL)selected {
    _selected = selected;
    [self update];
}

-(void)setSelectedImage:(NSImage *)selectedImage {
    _selectedImage = selectedImage;
    [self update];
}

-(void)setSelectedColor:(NSColor *)selectedColor {
    _selectedColor = selectedColor;
    [self update];
}

-(void)update {
    if (!_selectedColor && !_selectedImage) return;
    
    if (_selectedImage) {
        if (_selected) {
            self.image = _selectedImage;
        }
        else {
            self.image = _normalImage;
        }
    }
    else {
        if (_selected) {
            self.contentTintColor = _selectedColor;
        }
        else {
            self.contentTintColor = nil;
        }
    }
    
    

}

@end
