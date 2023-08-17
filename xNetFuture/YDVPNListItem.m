//
//  YDVPNListItem.m
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/20.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import "YDVPNListItem.h"
#import "YDProtocolParser.h"
#import "YDVDashView.h"
#import <Masonry/Masonry.h>

@interface YDVPNListItem()
@property (weak) IBOutlet NSTextField *remarkLab;
@property (weak) IBOutlet NSImageView *logoImageView;
@property (weak) IBOutlet NSView *backgroundView;
@property (nonatomic, strong)YDVDashView *dashView;
@property (weak) IBOutlet NSTextField *pingLabel;
@end

@implementation YDVPNListItem
{
    NSDictionary *_info;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.logoImageView.wantsLayer = YES;
    self.logoImageView.layer.cornerRadius = 4;
    self.backgroundView.wantsLayer = YES;
    self.backgroundView.layer.cornerRadius = 5;
    self.backgroundView.layer.backgroundColor = [NSColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:0.9].CGColor;
    
    self.dashView = [[YDVDashView alloc] initWithFrame:CGRectZero];
    self.dashView.cornorRadius = 3;
    [self addSubview:self.dashView positioned:(NSWindowBelow) relativeTo:nil];
    [self.dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)reloadData:(NSDictionary *)info{
    NSString *uri = info[@"uri"];
    NSDictionary *configuration = [YDProtocolParser parseURI:uri];
    NSString *remark = configuration[@"remark"];
    self.remarkLab.stringValue = remark ? remark : @"";
    NSImage *image = nil;
    if ([remark containsString:@"Hong Kong"] || [remark containsString:@"China"] || [remark containsString:@"Taiwan"]) {
        image = [NSImage imageNamed:@"china"];
    }
    else if ([remark containsString:@"Japan"]) {
        image = [NSImage imageNamed:@"japan"];
    }
    else if ([remark containsString:@"Singapore"]) {
        image = [NSImage imageNamed:@"singpore"];
    }
    else if ([remark containsString:@"United States"]) {
        image = [NSImage imageNamed:@"us"];
    }
    else if ([remark containsString:@"Canada"]) {
        image = [NSImage imageNamed:@"canada"];
    }
    else if ([remark containsString:@"England"]) {
        image = [NSImage imageNamed:@"england"];
    }
    else if ([remark containsString:@"Germany"]) {
        image = [NSImage imageNamed:@"germany"];
    }
    else if ([remark containsString:@"India"]) {
        image = [NSImage imageNamed:@"japan"];
    }
    else {
        image = [NSImage imageNamed:@"us"];
    }
    self.logoImageView.image = image;
    
    BOOL selected = [info[@"selected"] boolValue];
    
    self.dashView.hidden = selected == NO;
    self.deleteButton.hidden = selected == NO;
    _info = info;
    
    self.pingLabel.hidden = YES;
    if (info[@"ping"] && !selected) {
        self.pingLabel.hidden = NO;
        NSInteger rtt = [info[@"ping"][@"rtt"] integerValue];
        self.pingLabel.stringValue = [NSString stringWithFormat:@"%ldms", (long)rtt];
        
        if (rtt < 200) {
            self.pingLabel.textColor = [NSColor systemGreenColor];
        }
        else if (rtt < 400) {
            self.pingLabel.textColor = [NSColor systemBrownColor];
        }
        else {
            self.pingLabel.textColor = [NSColor systemRedColor];
        }
    }
}

-(void)reloadDatax:(NSDictionary *)info{
    self.remarkLab.stringValue = info[@"url"];
    self.dashView.hidden = YES;
    self.deleteButton.hidden = YES;
    self.pingLabel.hidden = YES;
    self.backgroundView.hidden = YES;
    self.remarkLab.font = [NSFont systemFontOfSize:14];
    
    BOOL selected = [info[@"selected"] boolValue];
    self.dashView.hidden = selected == NO;
    
    [self.remarkLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(self);
        make.top.equalTo(self).offset(4);
        make.height.equalTo(self);
    }];
}

- (IBAction)deleteButtonClick:(id)sender {
    [self.delegate onDeleteButtonClick:_info cellView:self];
}
@end
