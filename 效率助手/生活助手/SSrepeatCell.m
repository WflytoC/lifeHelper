//
//  SSrepeatCell.m
//  生活助手
//
//  Created by weichuang on 10/9/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//
#define sPadding 2

#import "SSrepeatCell.h"
#import "SSrepeat.h"
#import "SSconstant.h"

@interface SSrepeatCell()

@property(nonatomic,weak)UILabel* ss_eventView;

@property(nonatomic,weak)UILabel* ss_frequencyView;

@property(nonatomic,weak)UILabel* ss_makeDateView;

@property(nonatomic,weak)UILabel* ss_totalView;

@property(nonatomic,weak)UILabel* ss_isFinishedView;

@property(nonatomic,weak)UISwitch* ss_switchView;

@property(nonatomic,weak)UIView* ss_lineView;


@end

@implementation SSrepeatCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel* eventView=[[UILabel alloc] init];
        [self.contentView addSubview:eventView];
        self.ss_eventView=eventView;
        [self.ss_eventView setFont:[UIFont systemFontOfSize:20]];
        [self.ss_eventView setTextColor:[UIColor blueColor]];
        
        UILabel* frequencyView=[[UILabel alloc] init];
        [self.contentView addSubview:frequencyView];
        self.ss_frequencyView=frequencyView;
        [self.ss_frequencyView setFont:[UIFont systemFontOfSize:15]];
        self.ss_frequencyView.textColor=[UIColor greenColor];
        
        
        UILabel* makeDateView=[[UILabel alloc] init];
        [self.contentView addSubview:makeDateView];
        self.ss_makeDateView=makeDateView;
        [self.ss_makeDateView setFont:[UIFont systemFontOfSize:15]];
        self.ss_makeDateView.textColor=[UIColor orangeColor];
        
        UILabel* totalView=[[UILabel alloc] init];
        [self.contentView addSubview:totalView];
        self.ss_totalView=totalView;
        [self.ss_totalView setFont:[UIFont systemFontOfSize:15]];
        self.ss_totalView.textColor=[UIColor purpleColor];
        
        UILabel* isFinishedView=[[UILabel alloc] init];
        [self.contentView addSubview:isFinishedView];
        self.ss_isFinishedView=isFinishedView;
        self.ss_isFinishedView.textAlignment=NSTextAlignmentRight;
        [self.ss_isFinishedView setFont:[UIFont systemFontOfSize:15]];
        
        UISwitch* switchView=[[UISwitch alloc] init];
        [self.contentView addSubview:switchView];
        self.ss_switchView=switchView;
        [self.ss_switchView addTarget:self action:@selector(switchValueChangeHandler:) forControlEvents:UIControlEventValueChanged];
        
        UIView* lineView=[[UIView alloc] init];
        [self.contentView addSubview:lineView];
        self.ss_lineView=lineView;
        self.ss_lineView.backgroundColor=[UIColor redColor];
        
    }
    return self;
}


-(void)switchValueChangeHandler:(id)sender{
    
    UISwitch* cellSwitch=(UISwitch*)sender;
    
    if ([self.delegate respondsToSelector:@selector(repeateCellWithCell:cellSwitch:)]) {
        [self.delegate repeateCellWithCell:self cellSwitch:cellSwitch];
    }
}

-(void)setRepeat:(SSrepeat *)repeat{
    _repeat=repeat;
    
    self.ss_eventView.frame=CGRectMake(sPadding, sPadding, kWidth/3*2, 40);
    self.ss_eventView.text=self.repeat.ss_event;
    
    
    self.ss_frequencyView.frame=CGRectMake(sPadding, sPadding+40+10, kWidth, 25);
    self.ss_frequencyView.text=[NSString stringWithFormat:@"执行规定：%ld天一次",(long)self.repeat.ss_frequency];
    
    self.ss_makeDateView.frame=CGRectMake(sPadding, sPadding+40+25+10, kWidth, 25);
    self.ss_makeDateView.text=[NSString stringWithFormat:@"制定日期：%@",self.repeat.ss_makeDate];
    
    self.ss_totalView.frame=CGRectMake(sPadding, sPadding+40+10+25*2, kWidth, 25);
    self.ss_totalView.text=[NSString stringWithFormat:@"未完成%ld次数，完成%ld次",(long)self.repeat.ss_unFinishTimes,(long)self.repeat.ss_finishTimes];
    
    self.ss_isFinishedView.frame=CGRectMake(kWidth/3*2, kPadding, kWidth/3, 20);
    if (self.repeat.isFinished) {
        self.ss_isFinishedView.text=@"本次已完成 ";
        self.ss_isFinishedView.textColor=[UIColor redColor];
        
    }else{
        self.ss_isFinishedView.text=@"本次未完成 ";
        self.ss_isFinishedView.textColor=[UIColor grayColor];
    }
    
    self.ss_switchView.frame=CGRectMake(kWidth-60, sPadding+50, 0, 0);
    
    if (self.repeat.isFinished) {
        [self.ss_switchView setOn:YES];
    }else{
        [self.ss_switchView setOn:NO];
    }
    
    self.ss_lineView.frame=CGRectMake(0, 130, kWidth, 2);
}



@end
