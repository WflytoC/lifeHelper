//
//  SStool.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SStool.h"

@implementation SStool

+(CGSize)sizeWithContent:(NSString*)content maxSize:(CGSize)maxSize Font:(CGFloat)fontValue;{
    NSDictionary* dict=@{NSFontAttributeName:[UIFont systemFontOfSize:fontValue]};
    return [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

+(NSString *)dbPathWithdbName:(NSString*)dbName{
    NSArray* paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *documentDirectory = [paths lastObject];
    
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:dbName];
    
    return dbPath;
}


//计算两个日期相差的天数，给定的日期必须要小于当前日期，且a要大于b
+(NSInteger)daysWithaYear:(NSInteger)aYear aMonth:(NSInteger)aMonth aDay:(NSInteger)aDay bYear:(NSInteger)bYear bMonth:(NSInteger)bMonth bDay:(NSInteger)bDay{
    return [self daysWithSmallYear:bYear SmallMonth:bMonth SamllDay:bDay]-[self daysWithSmallYear:aYear SmallMonth:aMonth SamllDay:aDay];
}

+(NSInteger)daysWithOldYear:(NSInteger)oldYear oldMonth:(NSInteger)oldMonth oldDay:(NSInteger)oldDay{
    //获得当前日期
    NSDateComponents* comps=[self getDateComponent];
    NSInteger thisYear=[comps year];
    NSInteger thisMonth=[comps month];
    NSInteger thisDay=[comps day];
    
    //获得目标日期
    NSInteger thatYear=oldYear;
    NSInteger thatMonth=oldMonth;
    NSInteger thatDay=oldDay;
    
    NSInteger yearMinus=thatYear-thisYear;
    
    NSInteger thisDays=[self daysWithYear:thisYear month:thisMonth day:thisDay];
    NSInteger thatDays=[self daysWithYear:thatYear month:thatMonth day:thatDay];
    
    if (yearMinus==0) {
        return thatDays-thisDays;
    }
    
    NSInteger daysExtra=[self daysWithYear:thisYear]-thisDays+thatDays;
    
    if (yearMinus==1) {
        return daysExtra ;
    }
    
    for (int i=(int)thisYear+1; i<thatYear; i++) {
        daysExtra+=[self daysWithYear:i];
    }
    
    return daysExtra;
}

+(NSInteger)daysWithSmallYear:(NSInteger)SmallYear SmallMonth:(NSInteger)SmallMonth SamllDay:(NSInteger)SmallDay{
    //获得当前日期
    NSDateComponents* comps=[self getDateComponent];
    NSInteger thisYear=[comps year];
    NSInteger thisMonth=[comps month];
    NSInteger thisDay=[comps day];
    
    NSInteger yearMinus=thisYear-SmallYear;
    
    NSInteger thisDays=[self daysWithYear:thisYear month:thisMonth day:thisDay];
    NSInteger SmallDays=[self daysWithYear:SmallYear month:SmallMonth day:SmallDay];
    
    if (yearMinus==0) {
        return thisDays-SmallDays;
    }
    
    NSInteger daysExtra=[self daysWithYear:thisYear]-SmallDays+thisDays;
    
    if (yearMinus==1) {
        return daysExtra ;
    }
    
    for (int i=(int)SmallYear+1; i<thisYear; i++) {
        daysExtra+=[self daysWithYear:i];
    }
    
    return daysExtra;
    
}

+(NSDateComponents *)getDateComponent{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDate* date=[NSDate date];
    NSDateComponents* comps=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    return comps;
}

+(NSInteger)daysWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSArray* days;
    if ((year%4==0&&year%100!=0)||(year%400==0)) {
        days=@[@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    }else{
        days=@[@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    }
    NSInteger total=day;
    for (int i=1; i<month; i++) {
        total=total+[(NSString*)days[i] intValue];
    }
    return total;
}

+(NSInteger)daysWithYear:(NSInteger)year{
    if ((year%4==0&&year%100!=0)||(year%400==0)) {
        return 366;
    }
    return 365;
}

+(NSInteger)daysWithYear:(NSInteger)year month:(NSInteger)month{
    
    NSArray* days;
    if ((year%4==0&&year%100!=0)||(year%400==0)) {
        days=@[@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    }else{
        days=@[@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
    }
    
    return [(NSString*)days[month-1] intValue];
    
}

+(void)alertWithController:(UIViewController*)controller Title:(NSString *)title info:(NSString *)info btnTitle:(NSString *)btnTitle{
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:nil];
    UIAlertController* errorContrl=[UIAlertController alertControllerWithTitle:title message:info preferredStyle:UIAlertControllerStyleAlert];
    [errorContrl addAction:cancel];
    [controller presentViewController:errorContrl animated:YES completion:nil];
}

+(NSDateComponents *)getDateComponentWithDays:(NSInteger)days{
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDate* date=[[NSDate alloc] initWithTimeIntervalSinceNow:3600*24*days];
    NSDateComponents* comps=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    return comps;
}

+(BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


@end
