//
//  SSrecordCell.h
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSrecordCell;

@protocol recordCellDelegate <NSObject>

-(void)recordCellLongPressWithrecordCell:(SSrecordCell*)cell;

@end

@class SSrecordFrame;

@interface SSrecordCell : UITableViewCell

@property(nonatomic,strong)SSrecordFrame* recordFrame;

@property(nonatomic,weak)id<recordCellDelegate> delegate;

@end
