//
//  SSpassController.m
//  生活助手
//
//  Created by weichuang on 10/15/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height

#define kCircleCenter kWidth/3
#define kSlice kWidth/10
#define kLabelWidth kSlice*3
#define kPassWidth kSlice*7
#define kPassItemWidth kSlice/4
#define kCircleHeight kHeight/10*6
#define kPassHeight kHeight/10*3/4

#import "SSpassController.h"
#import "SStool.h"
#import "SStabBarController.h"
#import "FMDB.h"


@interface SSpassController ()


@property(nonatomic,strong)NSMutableArray* images1Array;
@property(nonatomic,strong)NSMutableArray* images2Array;


@property(nonatomic,weak)UIView* container1;
@property(nonatomic,weak)UIView* container2;
@property(nonatomic,weak)UIView* container3;

@property(nonatomic,weak)UIButton* reset;

@property(nonatomic,assign)bool value;

@end

@implementation SSpassController

int pass[8]={0,0,0,0,0,0,0,0};
int number=0;

-(NSMutableArray *)images1Array{
    if (_images1Array==nil) {
        _images1Array=[NSMutableArray array];
    }
    return _images1Array;
}

-(NSMutableArray *)images2Array{
    if (_images2Array==nil) {
        _images2Array=[NSMutableArray array];
    }
    return _images2Array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setGUI];
    [self setClearButton];
    
    NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
    self.value=[users boolForKey:@"password_isset"];
    self.reset.hidden=YES;
    //value 为 yes 则无需设置密码
    
    if (self.value) {
        self.container2.hidden=YES;
        self.reset.hidden=NO;
        self.container1.frame=CGRectMake(0, 2*kPassHeight, kWidth, kPassHeight);
    }
    }

-(void)setGUI{
    
    UIView* container1=[[UIView alloc] initWithFrame:CGRectMake(0, kPassHeight*1.5, kWidth, kPassHeight)];
    [self.view addSubview:container1];
    self.container1=container1;
    
    UIView* container2=[[UIView alloc] initWithFrame:CGRectMake(0, kPassHeight*3, kWidth, kPassHeight)];
    [self.view addSubview:container2];
    self.container2=container2;
    
    UILabel* pass=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLabelWidth, kPassHeight)];
    [self.container1 addSubview:pass];
    pass.textAlignment=NSTextAlignmentCenter;
    pass.text=@"登陆密码";
    pass.textColor=[UIColor blueColor];
    
    NSInteger passAverage=kPassWidth/4;
    for (int i=0;i<4; i++) {
        UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(kLabelWidth+i*passAverage, 0, kPassHeight, kPassHeight)];
        [self.container1 addSubview:imgView];
        [self.images1Array addObject:imgView];
        imgView.backgroundColor=[UIColor lightGrayColor];
        imgView.layer.cornerRadius=kPassHeight/2;
    }
    
    UILabel* confirm=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kLabelWidth, kPassHeight)];
    [self.container2 addSubview:confirm];
    confirm.textAlignment=NSTextAlignmentCenter;
    confirm.text=@"确认密码";
    confirm.textColor=[UIColor redColor];
    
    
    for (int i=0;i<4; i++) {
        UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(kLabelWidth+i*passAverage, 0, kPassHeight, kPassHeight)];
        [self.container2 addSubview:imgView];
        [self.images2Array addObject:imgView];
        imgView.backgroundColor=[UIColor lightGrayColor];
        imgView.layer.cornerRadius=kPassHeight/2;
    }
    
    UIView* container3=[[UIView alloc] initWithFrame:CGRectMake(0, 4*kPassHeight, kWidth, kCircleHeight)];
    [self.view addSubview:container3];
    self.container3=container3;
    
    NSInteger minLength=kWidth;
    if(kCircleHeight<kWidth){
        minLength=kCircleHeight;
    }
    
    NSInteger wItem=kWidth/4;
    NSInteger hItem=kCircleHeight/4;
    NSInteger circle=minLength/10;
    
    for (int i=1; i<10; i++) {
        int row=(i-1)/3+1;
        int col=(i-1)%3+1;
        UIButton* btn=[[UIButton alloc] initWithFrame:CGRectMake(col*wItem-circle, hItem*row-circle, circle*2, circle*2)];
        
        [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        
        btn.tag=i;
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius=circle;
        btn.backgroundColor=[UIColor greenColor];
        
        [btn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.container3 addSubview:btn];
    }
    
    
}


-(void)handleBtnClick:(id)sender{
    
    UIButton* target=(UIButton*)sender;
    
    NSInteger tag=target.tag;
    
    pass[number]=(int)tag;
    
    if (number<4) {
        UIButton* btn=self.images1Array[number];
        btn.backgroundColor=[UIColor blueColor];
    }else{
        int row=number%4;
        UIButton* btn=self.images2Array[row];
        btn.backgroundColor=[UIColor redColor];
    }
    
    
    
    number++;
    
    if (self.value&&number==4) {
        
        NSString* input=[NSString stringWithFormat:@"%d%d%d%d",pass[0],pass[1],pass[2],pass[3]];
        
        NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
        
        NSString* realPass=[users stringForKey:@"password_login"];
        
        
        if ([input isEqualToString:realPass]) {
            
            number=0;
            //成功登陆
            SStabBarController* tabController=[[SStabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController=tabController;
            
        }else{
            //密码错误
            
            UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:nil];
            
            UIAlertAction* find=[UIAlertAction actionWithTitle:@"找回密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
                
                NSString* question=[users objectForKey:@"question"];
                NSString* response=[users objectForKey:@"response"];
                NSString* message=[NSString stringWithFormat:@"请您回答问题:%@",question];
                
                UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"找回密码" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder=@"填写上述问题答案";
                }];
                
                UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString* anwser=[alert.textFields firstObject].text;
                    if ([response isEqualToString:anwser]) {
                        
                        NSString* password=[users objectForKey:@"password_login"];
                        
                        
                        UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"以后要记住啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            SStabBarController* tabController=[[SStabBarController alloc] init];
                            [UIApplication sharedApplication].keyWindow.rootViewController=tabController;
                            
                        }];
                        
                        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"密码是%@",password] preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:confirm];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                        
                    }else{
                        [SStool alertWithController:self Title:@"抱歉" info:@"您输入的问题答案不正确" btnTitle:@"好吧"];
                    }
                }];
                
                [alert addAction:confirm];
                [self presentViewController:alert animated:YES completion:nil];
                
                
            }];
            
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您输入的密码不正确" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:cancel];
            [alert addAction:find];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            number=0;
            for (int i=0; i<4; i++) {
                UIImageView* imgView=self.images1Array[i];
                imgView.backgroundColor=[UIColor lightGrayColor];
            }
        }
        
        return;
    }
    
    if (!self.value&&number==8) {
        
        //两次密码相同
        if ((pass[0]==pass[4])&&(pass[1]==pass[5])&&(pass[2]==pass[6])&&(pass[3]==pass[7])) {
            NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
            
            NSString* realPass=[NSString stringWithFormat:@"%d%d%d%d",pass[0],pass[1],pass[2],pass[3]];
            [users setObject:realPass forKey:@"password_login"];
            [users setBool:YES forKey:@"password_isset"];
            
            UIAlertAction* passYes=[UIAlertAction actionWithTitle:@"需要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [users setBool:NO forKey:@"password_notneed"];
                number=0;
                [self gotoHomePage];
            }];
            UIAlertAction* passNo=[UIAlertAction actionWithTitle:@"不需要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [users setBool:YES forKey:@"password_notneed"];
                number=0;
                [self gotoHomePage];
            }];
            
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"打开应用需要密码吗" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:passYes];
            [alert addAction:passNo];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }else{
            [SStool alertWithController:self Title:@"提示" info:@"两次密码输入不相同" btnTitle:@"知道啦"];
            number=0;
            for (int i=0; i<4; i++) {
                UIButton* btn1=self.images1Array[i];
                UIButton* btn2=self.images2Array[i];
                btn1.backgroundColor=[UIColor lightGrayColor];
                btn2.backgroundColor=[UIColor lightGrayColor];
            }
        }
        
        return;
    }
    
}


-(void)gotoHomePage{
    
    NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
    
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请填写找回密码问题，如果填写为空，问题、密码都为admin" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"填写您的问题";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"填写您的问题答案";
    }];
    
    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定·" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString* first=[alert.textFields firstObject].text;
        NSString* second=[alert.textFields lastObject].text;
        if ([first isEqualToString:@""]||[second isEqualToString:@""]) {
            [users setObject:@"admin" forKey:@"question"];
            [users setObject:@"admin" forKey:@"response"];
        }else{
            [users setObject:first forKey:@"question"];
            [users setObject:second forKey:@"response"];
        }
        
        SStabBarController* tabController=[[SStabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController=tabController;
        
        
    }];
    
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)setClearButton{
    
    
    
    UIButton* reset=[[UIButton alloc] initWithFrame:CGRectMake(0, kHeight-36, kWidth, 32)];
    [self.view addSubview:reset];
    self.reset=reset;
    self.reset.contentHorizontalAlignment=NSTextAlignmentRight;
    self.reset.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    [self.reset setTitle:@"忘记所有登录信息？" forState:UIControlStateNormal];
    [self.reset setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[self.reset addTarget:self action:@selector(resetAllData) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)resetAllData{
    
   
    
    UIAlertAction* resetData=[UIAlertAction actionWithTitle:@"重置数据" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
        
        if (![db open]) {
            return;
        }
        
        NSString* sql_drop=@"drop table if exists table_info";
        
        [db executeUpdate:sql_drop];

        NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
        [users setBool:NO forKey:@"password_isset"];
        
        self.reset.hidden=YES;
        
        self.container2.hidden=NO;
        self.container1.frame=CGRectMake(0, 1.5*kPassHeight, kWidth, kPassHeight);
        
        
        for (int i=0; i<number; i++) {
            UIButton* btn=self.images1Array[i];
            btn.backgroundColor=[UIColor lightGrayColor];
        }
        
        number=0;
        self.value=NO;
        
    }];
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提醒" message:@"你存储的重要信息会丢失" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:resetData];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
