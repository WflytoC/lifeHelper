//
//  SSplanController.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#define kWidth self.view.frame.size.width

#import "SSplanController.h"

@interface SSplanController ()

@property(nonatomic,weak)UISegmentedControl* segControl;
@property(nonatomic,strong)UIViewController* currController;

@property(nonatomic,weak)UIButton* barLeftButton;


@property(nonatomic,assign)NSInteger tag;


@end

@implementation SSplanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegControl];
    [self.view addSubview:((UIViewController*)self.subControllers[0]).view];
    self.currController=(UIViewController*)self.subControllers[0];
    self.tag=0;
    
    //Left
    UIButton* barLeftButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 2, 36, 40)];
    [barLeftButton setTitle:@"添加" forState:UIControlStateNormal];
    
    UIBarButtonItem* barLeftItem=[[UIBarButtonItem alloc] initWithCustomView:barLeftButton];
    self.navigationItem.rightBarButtonItem=barLeftItem;
    self.barLeftButton=barLeftButton;
    [self.barLeftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.barLeftButton addTarget:self action:@selector(clickBarLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.barLeftButton.hidden=YES;
    
    
   
    
}

-(void)clickBarLeftButton{
    if ([self.delegate respondsToSelector:@selector(planCtrlLeftBarClick)]) {
        [self.delegate planCtrlLeftBarClick];
    }
}




-(void)setupSegControl{
    UISegmentedControl* segControl=[[UISegmentedControl alloc] initWithItems:self.subTitles];
    self.segControl=segControl;
    self.segControl.selectedSegmentIndex=0;
    self.segControl.frame=CGRectMake(0, 8, kWidth/4*2, 28);
    [self.segControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView=self.segControl;

}


-(void)setSubControllers:(NSArray *)subControllers{
    _subControllers=subControllers;
    
    for(UIViewController* controller in _subControllers) {
        [self addChildViewController:controller];
    }
    self.delegate=self.subControllers[1];
    
}

-(void)valueChanged:(id)sender{
    UISegmentedControl* seg=(UISegmentedControl*)sender;
    NSInteger currIndex=seg.selectedSegmentIndex;
    if (currIndex==1) {
        self.barLeftButton.hidden=NO;
    }else{
        self.barLeftButton.hidden=YES;
    }
    if (self.tag==currIndex) {
        return;
    }

    
    [self transitionFromViewController:self.currController toViewController:(UIViewController*)self.subControllers[currIndex] duration:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
        self.tag=currIndex;
        
        self.currController=(UIViewController*)self.subControllers[currIndex];
    }];
  
}



@end
