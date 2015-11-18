//
//  SSaboutController.m
//  生活助手
//
//  Created by weichuang on 10/15/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.width
#define kPadding 24
#define kParagraphPadding 16
#define kFont 20


#import "SSaboutController.h"
#import "SStool.h"

@interface SSaboutController ()

@end

@implementation SSaboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setInterface];
}

-(void)setInterface{
    UIScrollView* scroll=[[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scroll];
    
    NSString* guide=@"  感谢使用\"生活助手\"这款应用,下面是该应用的使用指南";
    NSString* helper=@"  1.使用倒计时功能:您只需点击\"添加\"按钮,然后填写事件名,选择事件的重要程度,事件的日期便可实现该功能,您长按添加的项可以删除\n\n  2.使用计划功能:对于\"今日计划\",您可以添加今日,明日的计划,长按添加的项可以删除,而对于\"重复执行\",您可以添加重复性做的事情，应用会自动帮您统计您的执行情况，长按添加的项可以删除\n\n  3.使用记录功能:您只需点击\"添加记录\"按钮，然后记录下事情的细节即可，当然，长按可以删除,编辑所添加的项\n\n  4.使用存储信息功能:在\"更多\"中的\"存储信息\"中，你可以添加你容易忘记的信息，包括相关的密码等，该应用不具有网络功能，在存储信息中，你可以以明文或者暗文的形式添加信息，长按可以修改或删除添加的新消息";
    
    CGFloat maxWidth=kWidth-2*kPadding;
    CGSize maxSize=CGSizeMake(maxWidth, MAXFLOAT);
    
    CGFloat height_guide=[SStool sizeWithContent:guide maxSize:maxSize Font:kFont].height;
    CGFloat height_helper=[SStool sizeWithContent:helper maxSize:maxSize Font:kFont].height;

    scroll.contentSize=CGSizeMake(kWidth, 4*kParagraphPadding+height_guide+height_helper);
    
    UILabel* label_guide=[[UILabel alloc] initWithFrame:CGRectMake(kPadding, kParagraphPadding, maxWidth, height_guide)];
    label_guide.text=guide;
    label_guide.numberOfLines=0;
    [label_guide setFont:[UIFont systemFontOfSize:kFont]];
    label_guide.textColor=[UIColor greenColor];
    [scroll addSubview:label_guide];
    
    UILabel* label_helper=[[UILabel alloc] initWithFrame:CGRectMake(kPadding, kParagraphPadding*2+height_guide, maxWidth, height_helper)];
    label_helper.text=helper;
    label_helper.numberOfLines=0;
    [label_helper setFont:[UIFont systemFontOfSize:kFont]];
    label_helper.textColor=[UIColor blueColor];
    [scroll addSubview:label_helper];
    
    
    
    
}




@end
