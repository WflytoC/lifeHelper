//
//  SShandleController.h
//  生活助手
//
//  Created by weichuang on 10/12/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^paramsBlock)(NSString* name,NSInteger degree,NSInteger year,NSInteger month,NSInteger day);

@interface SShandleController : UIViewController

@property(nonatomic,copy)paramsBlock blockParams;

@end
