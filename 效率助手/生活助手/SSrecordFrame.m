//
//  SSrecordFrame.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSrecordFrame.h"
#import "SStool.h"
#import "SSrecord.h"
#import "SSconstant.h"

#define sCDPadding 10

@implementation SSrecordFrame


-(void)setSs_record:(SSrecord *)ss_record{
    _ss_record=ss_record;
    
    
    
    //define some needed variables
    CGSize singleMaxSize=CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    //calculate the size of date
    
    CGSize dateSize=[SStool sizeWithContent:self.ss_record.ss_date maxSize:singleMaxSize Font:kDateFont];
    
    //calculate the frame of date
    self.ss_dateFrame=CGRectMake(3*kPadding+kCircleRadius, kPadding, dateSize.width, dateSize.height);
    
    //calculate the size of detail
    
    CGSize detailMaxSize=CGSizeMake(kWidth-kPadding-2*kCircleRadius-sCDPadding*2, MAXFLOAT);
    
    CGSize detailSize=[SStool sizeWithContent:self.ss_record.ss_detail maxSize:detailMaxSize Font:kDetailFont];
    
    
    //calculate the frame of detail
    
    self.ss_detailsFrame=CGRectMake(kPadding+2*kCircleRadius+sCDPadding, CGRectGetMaxY(self.ss_dateFrame)+kPadding, detailSize.width, detailSize.height);
    
    //calculate the frame of line
    
    self.ss_lineFrame=CGRectMake(kPadding+kCircleRadius-kLineWidth/2, 0, kLineWidth, CGRectGetMaxY(self.ss_detailsFrame)+kPadding);
    
    //calculate the rowHeight
    
    self.ss_rowHeight=CGRectGetMaxY(self.ss_lineFrame);
    
    //calculate the frame of circle
    
    self.ss_circleFrame=CGRectMake(kPadding, (CGRectGetMaxY(self.ss_dateFrame)+self.ss_rowHeight)/2-kCircleRadius, kCircleRadius*2, kCircleRadius*2);
    
}

@end
