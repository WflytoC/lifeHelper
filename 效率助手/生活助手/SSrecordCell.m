//
//  SSrecordCell.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSrecordCell.h"
#import "SSconstant.h"
#import "SSrecord.h"
#import "SSrecordFrame.h"



@interface SSrecordCell()

@property(nonatomic,weak)UILabel* ss_dateView;
@property(nonatomic,weak)UILabel* ss_detailView;
@property(nonatomic,weak)UIView* ss_lineView;
@property(nonatomic,weak)UIImageView* ss_circleView;

@end

@implementation SSrecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        
        UIView* lineView=[[UIView alloc] init];
        [self.contentView addSubview:lineView];
        self.ss_lineView=lineView;
        self.ss_lineView.backgroundColor=[UIColor greenColor];
        
        UIImageView* circleView=[[UIImageView alloc] init];
        [self.contentView addSubview:circleView];
        self.ss_circleView=circleView;
        self.ss_circleView.layer.cornerRadius=kCircleRadius;
        self.ss_circleView.backgroundColor=[UIColor orangeColor];
        
        self.ss_circleView.userInteractionEnabled=YES;
        
        UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration=1.0;
        [self.ss_circleView addGestureRecognizer:longPress];
        
        
        UILabel* dateView=[[UILabel alloc] init];
        [self.contentView addSubview:dateView];
        self.ss_dateView=dateView;
        [self.ss_dateView setFont:[UIFont systemFontOfSize:kDateFont]];
        self.ss_dateView.textColor=[UIColor redColor];
        
        
        
        UILabel* detailView=[[UILabel alloc] init];
        [self.contentView addSubview:detailView];
        self.ss_detailView=detailView;
        [self.ss_detailView setFont:[UIFont systemFontOfSize:kDetailFont]];
        self.ss_detailView.numberOfLines=0;
        self.ss_detailView.textColor=[UIColor blueColor];
        
        
    }
    
    return self;
}

-(void)handleLongPress:(id)sender{
    UILongPressGestureRecognizer* longPress=(UILongPressGestureRecognizer*)sender;
    if (longPress.state==UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(recordCellLongPressWithrecordCell:)]) {
            [self.delegate recordCellLongPressWithrecordCell:self];
        }
    }
}

-(void)setRecordFrame:(SSrecordFrame *)recordFrame{
    _recordFrame=recordFrame;
    
    SSrecord* record=recordFrame.ss_record;
    
    
    self.ss_lineView.frame=self.recordFrame.ss_lineFrame;
    self.ss_circleView.frame=self.recordFrame.ss_circleFrame;
    self.ss_dateView.frame=self.recordFrame.ss_dateFrame;
    self.ss_detailView.frame=self.recordFrame.ss_detailsFrame;
    
    [self.ss_dateView setText:record.ss_date];
    [self.ss_detailView setText:record.ss_detail];
}


@end
