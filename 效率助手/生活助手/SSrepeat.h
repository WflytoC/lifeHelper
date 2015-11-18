//
//  SSrepeat.h
//  生活助手
//
//  Created by weichuang on 10/9/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSrepeat : NSObject

@property(nonatomic,copy)NSString* ss_event;

@property(nonatomic,copy)NSString* ss_makeDate;

@property(nonatomic,assign)NSInteger ss_frequency;

@property(nonatomic,assign)NSInteger ss_finishTimes;

@property(nonatomic,assign)NSInteger ss_unFinishTimes;

@property(nonatomic,assign)BOOL isFinished;

-(instancetype)initWithDict:(NSDictionary*)dict;

+(instancetype)repeatWithDict:(NSDictionary*)dict;


@end
