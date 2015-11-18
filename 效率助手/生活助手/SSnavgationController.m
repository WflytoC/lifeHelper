//
//  SSnavgationController.m
//  生活助手
//
//  Created by weichuang on 10/12/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSnavgationController.h"

@interface SSnavgationController ()

@end

@implementation SSnavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.backgroundColor=[UIColor greenColor];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count>1) {
        self.tabBarController.tabBar.hidden=YES;
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.viewControllers.count==2) {
        self.tabBarController.tabBar.hidden=NO;
    }
    return  [super popViewControllerAnimated:animated];

}



@end
