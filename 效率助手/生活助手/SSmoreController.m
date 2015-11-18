//
//  SSmoreController.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSmoreController.h"
#import "SSdataController.h"
#import "SSpassController.h"
#import "SSaboutController.h"
#import "SStool.h"

@interface SSmoreController ()

@property(nonatomic,strong)NSArray* moreFuncs;
@property(nonatomic,strong)NSArray* passSetting;
@property(nonatomic,strong)NSArray* others;
@property(nonatomic,strong)NSArray* headers;

@end

@implementation SSmoreController


-(NSArray *)moreFuncs{
    if (_moreFuncs==nil) {
        _moreFuncs=@[@"存储信息"];
    }
    return _moreFuncs;
}

-(NSArray *)passSetting{
    if (_passSetting==nil) {
        _passSetting=@[@"修改密码",@"开启密码"];
    }
    return _passSetting;
}

-(NSArray *)others{
    if (_others==nil) {
        _others=@[@"关于应用"];
    }
    return _others;
}

-(NSArray *)headers{
    if (_headers==nil) {
        _headers=@[@"更多功能",@"密码设置",@"更多"];
    }
    return _headers;
}

-(instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.view.backgroundColor=[UIColor whiteColor];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.moreFuncs.count;
    }else if (section==1){
        return self.passSetting.count;
    }
    return self.others.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headers.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    if (section==0) {
        cell.textLabel.text=self.moreFuncs[row];
    }else if (section==1){
        cell.textLabel.text=self.passSetting[row];
        if (row==1) {
            
            NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
            BOOL value=[users boolForKey:@"password_notneed"];
            
            UISwitch* cellSwtch=[[UISwitch alloc] init];
            [cellSwtch setOn:!value];
            
            [cellSwtch addTarget:self action:@selector(isSetPassword:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView=cellSwtch;
        }
    }else if (section==2){
        cell.textLabel.text=self.others[row];
    }
    
    cell.textLabel.textColor=[UIColor blueColor];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.headers[section];
}

-(void)isSetPassword:(id)sender{
    UISwitch* cellSwitch=(UISwitch*)sender;
    NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
    
    if (cellSwitch.on) {
        
        [SStool alertWithController:self Title:@"温馨提示" info:@"您将开启进入应用需要密码模式" btnTitle:@"知道啦"];
        [users setBool:NO forKey:@"password_notneed"];
        
    }else{
        [SStool alertWithController:self Title:@"温馨提示" info:@"您将开启应用不需要密码格式" btnTitle:@"知道啦"];
        [users setBool:YES forKey:@"password_notneed"];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
    
    if (section==0&&row==0) {
        //存储重要信息
        NSString* passStr=[users stringForKey:@"dataPassword"];
        if (passStr==nil) {
            
            //设置密码
            
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"感谢使用该功能" message:@"请为您的数据设置查看密码" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder=@"填写密码";
                textField.secureTextEntry=YES;
            }];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder=@"确认密码";
                textField.secureTextEntry=YES;
            }];
            
            UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //处理用户填写的数据
                UITextField* first=[alert.textFields objectAtIndex:0];
                UITextField* second=[alert.textFields objectAtIndex:1];
                NSString* firstInfo=first.text;
                NSString* secondInfo=second.text;
                
                if ([firstInfo isEqualToString:@""]||[secondInfo isEqualToString:@""]) {
                    [SStool alertWithController:self Title:@"提示" info:@"填写的信息不能为空" btnTitle:@"知道啦"];
                }else if (![firstInfo isEqualToString:secondInfo]){
                    [SStool alertWithController:self Title:@"提示" info:@"两次密码填写不一致" btnTitle:@"知道啦"];
                }else{
                    [users setObject:firstInfo forKey:@"dataPassword"];
                    [self.navigationController pushViewController:[[SSdataController alloc] init] animated:YES];
                    
                }
                
                
                
            }];
            
            UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:confirm];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
            UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入进入密码" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder=@"请输入密码";
                textField.secureTextEntry=YES;
            }];
            
            UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //处理登陆密码
                UITextField* first=[alert.textFields firstObject];
                NSString* firstInfo=first.text;
                NSString* dataPassword=[users stringForKey:@"dataPassword"];
                
                if ([firstInfo isEqualToString:@""]) {
                    [SStool alertWithController:self Title:@"提示" info:@"填写的密码不能为空哦" btnTitle:@"知道啦"];
                }else if (![dataPassword isEqualToString:firstInfo]){
                    //[SStool alertWithController:self Title:@"提示" info:@"您填写的密码不正确" btnTitle:@"知道啦"];
                    //密码不正确
                    
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
                                
                                NSString* password=[users objectForKey:@"dataPassword"];
                                
                                
                                UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"以后要记住啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    
                                    [self.navigationController pushViewController:[[SSdataController alloc] init] animated:YES];
                                    
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
                    
                    
                    
                    
                    
                    //不正确
                }else{
                    [self.navigationController pushViewController:[[SSdataController alloc] init] animated:YES];
                }
                
                
            }];
            UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:confirm];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        
        
        
    }else if (section==1&&row==0){
        
        
        UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSUserDefaults* users=[NSUserDefaults standardUserDefaults];
            [users setBool:NO forKey:@"password_isset"];
            [UIApplication sharedApplication].keyWindow.rootViewController=[[SSpassController alloc] init];
        }];
        
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要修改密码吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:confirm];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
        
        
    }else if (section==2&&row==0){
        [self.navigationController pushViewController:[[SSaboutController alloc] init] animated:YES];
    }
}



@end
