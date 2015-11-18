//
//  SStool.h
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SStool : NSObject

//计算所给的文本在指定的宽度下的尺寸
+(CGSize)sizeWithContent:(NSString*)content maxSize:(CGSize)maxSize Font:(CGFloat)fontValue;

//指定数据库所在的文件路径
+(NSString*)dbPathWithdbName:(NSString*)dbName;

//计算给定两个日期之间的天数差 a的日期－b的日期
+(NSInteger)daysWithaYear:(NSInteger)aYear aMonth:(NSInteger)aMonth aDay:(NSInteger)aDay bYear:(NSInteger)bYear bMonth:(NSInteger)bMonth bDay:(NSInteger)bDay;

//计算给定的日期与当前日期相隔的天数,给定的日期大于、等于当前日期
+(NSInteger)daysWithOldYear:(NSInteger)oldYear oldMonth:(NSInteger)oldMonth oldDay:(NSInteger)oldDay;

//计算给定的日期与当前日期相隔的天数，给定的日期小于等于当前的日期
+(NSInteger)daysWithSmallYear:(NSInteger)SmallYear SmallMonth:(NSInteger)SmallMonth SamllDay:(NSInteger)SmallDay;

//计算给定日期在该年份已过的天数
+(NSInteger)daysWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

//计算给定的年份的总天数
+(NSInteger)daysWithYear:(NSInteger)year;

//计算给定年份、月份的天数
+(NSInteger)daysWithYear:(NSInteger)year month:(NSInteger)month;

//传出一个可以计算日期的组件

+(NSDateComponents*)getDateComponent;

//错误提示框
+(void)alertWithController:(UIViewController*)controller Title:(NSString*)title info:(NSString*)info btnTitle:(NSString*)btnTitle;
//传出一个可以计算过n天后的日期
+(NSDateComponents*)getDateComponentWithDays:(NSInteger)days;

//判断一个字符串是否是纯整数
+(BOOL)isPureInt:(NSString *)string;

@end
