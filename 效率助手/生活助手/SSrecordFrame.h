//
//  SSrecordFrame.h
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SSrecord;
@interface SSrecordFrame : NSObject

@property(nonatomic,strong)SSrecord* ss_record;

@property(nonatomic,assign)CGFloat ss_rowHeight;

@property(nonatomic,assign)CGRect ss_lineFrame;
@property(nonatomic,assign)CGRect ss_circleFrame;
@property(nonatomic,assign)CGRect ss_dateFrame;
@property(nonatomic,assign)CGRect ss_detailsFrame;

@end
