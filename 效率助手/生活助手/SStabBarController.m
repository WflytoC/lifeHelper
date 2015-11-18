//
//  SStabBarController.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SStabBarController.h"

#import "SSdownController.h"
#import "SSplanController.h"
#import "SSrecordController.h"
#import "SSmoreController.h"

#import "SStodayController.h"
#import "SSrepeatController.h"
#import "SSnavgationController.h"


@interface SStabBarController ()



@end

@implementation SStabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.backgroundColor=[UIColor greenColor];
    
    SSdownController* downCtrl=[[SSdownController alloc] init];
    downCtrl.title=@"倒计时";
    downCtrl.tabBarItem.image=[UIImage imageNamed:@"tab_down"];
    SSnavgationController* downNav=[[SSnavgationController alloc] initWithRootViewController:downCtrl];
    
    SSplanController* planCtrl=[[SSplanController alloc] init];
    
    SStodayController* today=[[SStodayController alloc] init];
    SSrepeatController* repeat=[[SSrepeatController alloc] init];
    
    planCtrl.subControllers=@[today,repeat];
    planCtrl.subTitles=@[@"今日计划",@"重复执行"];
    
    planCtrl.title=@"计划";
    planCtrl.tabBarItem.image=[UIImage imageNamed:@"tab_plan"];
    SSnavgationController* planNav=[[SSnavgationController alloc] initWithRootViewController:planCtrl];
    
    SSrecordController* recordCtrl=[[SSrecordController alloc] init];
    recordCtrl.title=@"记录";
    recordCtrl.tabBarItem.image=[UIImage imageNamed:@"tab_record"];
    SSnavgationController* recordNav=[[SSnavgationController alloc] initWithRootViewController:recordCtrl];
    
    SSmoreController* moreCtrl=[[SSmoreController alloc] init];
    moreCtrl.title=@"更多";
    moreCtrl.tabBarItem.image=[UIImage imageNamed:@"tab_more"];
    SSnavgationController* moreNav=[[SSnavgationController alloc] initWithRootViewController:moreCtrl];
    
    self.viewControllers=@[downNav,planNav,recordNav,moreNav];
    
    
    
}



@end
