//
//  SSrecordView.h
//  生活助手
//
//  Created by weichuang on 10/14/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSrecordView;

@protocol recordViewDelegate <NSObject>

-(void)recordViewConfirmWith:(SSrecordView*)recordView content:(NSString*)content;

-(void)recordViewCancelWith:(SSrecordView*)recordView;

@end

@interface SSrecordView : UIView

@property(nonatomic,weak)UITextView* ss_text;

@property(nonatomic,weak)id<recordViewDelegate> delegate;

@end
