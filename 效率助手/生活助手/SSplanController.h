//
//  SSplanController.h
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol planCtrlLeftBarDelegate <NSObject>

@optional
-(void)planCtrlLeftBarClick;

@end

@interface SSplanController : UIViewController

@property(nonatomic,strong)NSArray* subControllers;
@property(nonatomic,strong)NSArray* subTitles;
@property(nonatomic,weak)id<planCtrlLeftBarDelegate> delegate;

@end
