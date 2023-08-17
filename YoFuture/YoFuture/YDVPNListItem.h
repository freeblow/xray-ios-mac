//
//  YDVPNListItem.h
//  Yo Wish
//
//  Created by 杨雨东 on 2023/1/20.
//  Copyright © 2023 RongCloud. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YDVPNListItemDelegate <NSObject>

-(void)onDeleteButtonClick:(NSDictionary *)info cellView:(NSTableCellView *)cellView;

@end

@interface YDVPNListItem : NSTableCellView
-(void)reloadData:(NSDictionary *)info;
@property (weak) IBOutlet NSButton *deleteButton;;
@property (nonatomic, weak)id <YDVPNListItemDelegate> delegate;

-(void)reloadDatax:(NSDictionary *)info;
@end

NS_ASSUME_NONNULL_END
