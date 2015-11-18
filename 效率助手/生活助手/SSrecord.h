//
//  SSrecord.h
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSrecord : NSObject

@property(nonatomic,copy)NSString* ss_date;
@property(nonatomic,copy)NSString* ss_detail;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)recordWithDict:(NSDictionary*)dict;

@end
