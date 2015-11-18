//
//  SSrepeat.m
//  生活助手
//
//  Created by weichuang on 10/9/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSrepeat.h"

@implementation SSrepeat

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)repeatWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
