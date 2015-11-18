//
//  SSrecordView.m
//  生活助手
//
//  Created by weichuang on 10/14/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSrecordView.h"

@interface SSrecordView()

@property(nonatomic,weak)UIButton* ss_confirm;
@property(nonatomic,weak)UIButton* ss_cancel;

@end

@implementation SSrecordView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.alpha=0.9;
        
        CGFloat kWidth=frame.size.width;
        CGFloat kHeight=frame.size.height;
        
        self.layer.borderColor=[UIColor purpleColor].CGColor;
        self.layer.borderWidth=2.0;
        
        
        UIToolbar* topView=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem* close=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editFinish)];
        [topView setItems:@[close]];
        
        
        UITextView* text=[[UITextView alloc] init];
        text.frame=CGRectMake(0, 0, kWidth, kHeight-24);
        [self addSubview:text];
        self.ss_text=text;
        self.ss_text.textColor=[UIColor blueColor];
        [self.ss_text setFont:[UIFont systemFontOfSize:20]];
        [self.ss_text setInputAccessoryView:topView];
        
        
        UIButton* confirm=[[UIButton alloc] init];
        confirm.frame=CGRectMake(0, kHeight-24, kWidth/2, 24);
        [self addSubview:confirm];
        self.ss_confirm=confirm;
        self.ss_confirm.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.ss_confirm setTitle:@"确 定" forState:UIControlStateNormal];
        [self.ss_confirm addTarget:self action:@selector(handleConfirm) forControlEvents:UIControlEventTouchUpInside];
        self.ss_confirm.backgroundColor=[UIColor orangeColor];
        
        UIButton* cancel=[[UIButton alloc] init];
        cancel.frame=CGRectMake(kWidth/2, kHeight-24, kWidth/2, 24);
        [self addSubview:cancel];
        self.ss_cancel=cancel;
        self.ss_cancel.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.ss_cancel setTitle:@"取 消" forState:UIControlStateNormal];
        [self.ss_cancel addTarget:self action:@selector(handleCancle) forControlEvents:UIControlEventTouchUpInside];
        self.ss_cancel.backgroundColor=[UIColor orangeColor];
        
    }
    
    return self;
}

-(void)handleConfirm{
    if ([self.delegate respondsToSelector:@selector(recordViewConfirmWith:content:)]) {
        [self.delegate recordViewConfirmWith:self content:self.ss_text.text];
        self.ss_text.text=@"";
    }
}

-(void)handleCancle{
    if ([self.delegate respondsToSelector:@selector(recordViewCancelWith:)]) {
        [self.delegate recordViewCancelWith:self];
        self.ss_text.text=@"";
    }
}

-(void)editFinish{
    [self.ss_text resignFirstResponder];
}


@end
