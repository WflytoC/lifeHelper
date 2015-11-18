//
//  SSrepeatCell.h
//  生活助手
//
//  Created by weichuang on 10/9/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSrepeat;
@class SSrepeatCell;

@protocol repeatCellDelegate <NSObject>

-(void)repeateCellWithCell:(SSrepeatCell*)repeatCell cellSwitch:(UISwitch*)cellSwitch;

@end

@interface SSrepeatCell : UITableViewCell

@property(nonatomic,strong)SSrepeat* repeat;

@property(nonatomic,weak)id<repeatCellDelegate> delegate;

@end
