//
//  SSdownCell.m
//  生活助手
//
//  Created by weichuang on 10/11/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSdownCell.h"
#import "SStool.h"

@interface SSdownCell()

@property(nonatomic,weak)UILabel* ss_eventView;
@property(nonatomic,weak)UILabel* ss_dateView;
@property(nonatomic,weak)UILabel* ss_leftView;
@property(nonatomic,weak)UIView* ss_lineView;

@end

@implementation SSdownCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel* eventView=[[UILabel alloc] init];
        [self addSubview:eventView];
        self.ss_eventView=eventView;
        [self.ss_eventView setFont:[UIFont systemFontOfSize:24]];
        self.ss_eventView.textColor=[UIColor purpleColor];
        
        UILabel* dateView=[[UILabel alloc] init];
        [self addSubview:dateView];
        self.ss_dateView=dateView;
        self.ss_dateView.textColor=[UIColor greenColor];
        
        UILabel* leftView=[[UILabel alloc] init];
        [self addSubview:leftView];
        self.ss_leftView=leftView;
        [self.ss_leftView setFont:[UIFont systemFontOfSize:20]];
        self.ss_leftView.textColor=[UIColor blueColor];
        
        UIView* lineView=[[UIView alloc] init];
        [self addSubview:lineView];
        self.ss_lineView=lineView;
        self.ss_lineView.backgroundColor=[UIColor redColor];
        
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    CGFloat width=self.frame.size.width;
    CGFloat height=self.frame.size.height;
    
    CGFloat padding=2;
    CGFloat eventH=30;
    CGFloat eventW=(width-2*padding)/7*4;
    CGFloat dateH=20;
    CGFloat dateW=(width-2*padding)/7*4;
    CGFloat leftH=30;
    CGFloat leftW=(width-2*padding)/7*2;
    
    self.ss_eventView.frame=CGRectMake(padding, padding, eventW, eventH);
    
    self.ss_dateView.frame=CGRectMake(padding, 3*padding+eventH, dateW, dateH);
    
    self.ss_leftView.frame=CGRectMake(width-padding-leftW, (height-leftH)/2, leftW, leftH);
    
    
    self.ss_lineView.frame=CGRectMake(0, height-2, width, 2);
}

-(void)setDownDict:(NSDictionary *)downDict{
    _downDict=downDict;
    
    self.ss_eventView.text=self.downDict[@"event"];
    NSInteger year=[self.downDict[@"year"] integerValue];
    NSInteger month=[self.downDict[@"month"] integerValue];
    NSInteger day=[self.downDict[@"day"] integerValue];
    NSString* date=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
    self.ss_dateView.text=date;
    
    NSInteger days=[SStool daysWithOldYear:year oldMonth:month oldDay:day];
    
    NSString* leftText=@"";
    if (days<0) {
        leftText=@"过期";
    }else if (days==0){
        leftText=@"到期";
    }else{
        leftText=[NSString stringWithFormat:@"%ld天",(long)days];
    }
    
    self.ss_leftView.text=leftText;
    
}

@end
