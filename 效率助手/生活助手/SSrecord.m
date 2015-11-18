//
//  SSrecord.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSrecord.h"


@implementation SSrecord

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)recordWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
