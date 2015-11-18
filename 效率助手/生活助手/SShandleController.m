//
//  SShandleController.m
//  生活助手
//
//  Created by weichuang on 10/12/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#define cWidth self.view.frame.size.width
#define cHeight (self.view.frame.size.height-64)
#define cTableH (64*4)
#define cLeftH (cHeight-cTableH)
#define cSpacing 24


#import "SShandleController.h"
#import "SStool.h"
#import "FMDB.h"

@interface SShandleController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property(nonatomic,weak)UIPickerView* picker;





@property(nonatomic,weak)UITableView* tableView;
@property(nonatomic,strong)NSArray* infoArr;

@property(nonatomic,weak)UITextField* nameText;
@property(nonatomic,weak)UILabel* degreeLabel;
@property(nonatomic,weak)UILabel* dateLabel;

@property(nonatomic,assign)NSInteger thisYear;
@property(nonatomic,assign)NSInteger thatYear;
@property(nonatomic,assign)NSInteger thisMonth;
@property(nonatomic,assign)NSInteger thatMonth;
@property(nonatomic,assign)NSInteger thisDay;
@property(nonatomic,assign)NSInteger thatDay;


@property(nonatomic,assign)NSInteger passDegree;//事件重要程度
@property(nonatomic,copy)NSString* passName;//事件名称
@property(nonatomic,assign)NSInteger passYear;
@property(nonatomic,assign)NSInteger passMonth;
@property(nonatomic,assign) NSInteger passDay;


//year month day



@end

@implementation SShandleController

-(NSArray *)infoArr{
    if (_infoArr==nil) {
        _infoArr=@[@"事件名称",@"重要程度",@"目标日期"];
    }
    return _infoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.passDegree=3;
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAdd)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAdd)];
    
    self.navigationItem.title=@"添加倒计时";
    
    UITableView* tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, cWidth, cTableH) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    

    UILabel* pickerLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, cTableH+cSpacing, cWidth, cSpacing)];
    pickerLabel.text=@"请您选择目标日期";
    pickerLabel.textColor=[UIColor blueColor];
    [pickerLabel setFont:[UIFont systemFontOfSize:24]];
    [self.view addSubview:pickerLabel];
    
    UIPickerView* picker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, cTableH+3*cSpacing, cWidth, cHeight+64-cTableH-4*cSpacing)];
    [self.view addSubview:picker];
    self.picker=picker;
    self.picker.dataSource=self;
    self.picker.delegate=self;
    
    
    NSDateComponents* comps=[SStool getDateComponent];
    
    self.thisYear=[comps year];
    self.thisMonth=[comps month];
    self.thisDay=[comps day];
    
    self.thatYear=self.thisYear;
    self.thatMonth=self.thisMonth;
    self.thatDay=self.thisDay;
    
    [self.picker selectRow:self.thatMonth-1 inComponent:1 animated:YES];
    [self.picker selectRow:self.thatDay-1 inComponent:2 animated:YES];
    
    
    self.picker.backgroundColor=[UIColor whiteColor];
    
}

-(void)cancelAdd{
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertController* alertContrl=[UIAlertController alertControllerWithTitle:@"提 示" message:@"您，您确定要取消吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertContrl addAction:cancel];
    [alertContrl addAction:confirm];
    [self presentViewController:alertContrl animated:YES completion:nil];
    
}

-(void)finishAdd{
    self.passName=self.nameText.text;
    if ([self.passName isEqualToString:@""]) {
        
        [SStool alertWithController:self Title:@"错误提示" info:@"事件名不能为空" btnTitle:@"知道啦"];
        
    }else{
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleDefault handler:nil];
        
        UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //如何处理完成添加数据呢 1.添加到数据库 2.刷新另一个界面数据
            self.passYear=self.thatYear;
            self.passMonth=self.thatMonth;
            self.passDay=self.thatDay;
            
            
            
            // 1.更新数据库
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            
            //查看新添加的事件名是否有重复
            NSString* sql_query=@"select* from table_down where name =(?)";
            FMResultSet* result=[db executeQuery:sql_query withArgumentsInArray:@[self.passName]];
            
            if ([result next]) {
                [SStool alertWithController:self Title:@"错误提示" info:@"已存在相同的事件名" btnTitle:@"知道啦"];
                return ;
            }
            
            
            
            if(self.passDegree==2||self.passDegree==3){
                
                //处理重要性排在第二、第三的事件
                NSString* sql_insert=@"insert into table_down (name,year,month,day,kind) values (?,?,?,?,?)";
                
                [db executeUpdate:sql_insert withArgumentsInArray:@[self.passName,[NSNumber numberWithInteger:self.passYear],[NSNumber numberWithInteger:self.passMonth],[NSNumber numberWithInteger:self.passDay],[NSNumber numberWithInteger:self.passDegree]]];
                
                [db close];
                
            }else if (self.passDegree==1){
                
                //处理重要性排在第一的事件,只需修改其重要度
                NSString* sql_query=@"select* from table_down where kind =1";
                
                FMResultSet* result=[db executeQuery:sql_query];
                
                if ([result next]) {
                    NSLog(@"exists");
                    NSString* sql_modify=@"update table_down set kind=2 where kind=1";
                    [db executeUpdate:sql_modify];
                }
                    
                NSString* sql_insert=@"insert into table_down (name,year,month,day,kind) values (?,?,?,?,?)";
                    
                [db executeUpdate:sql_insert withArgumentsInArray:@[self.passName,[NSNumber numberWithInteger:self.passYear],[NSNumber numberWithInteger:self.passMonth],[NSNumber numberWithInteger:self.passDay],[NSNumber numberWithInteger:self.passDegree]]];
                    
                [db close];
                    
                
                
            }
            
            
            // 2.更新界面
            
            self.blockParams(self.passName,self.passDegree,self.passYear,self.passMonth,self.passDay);
            
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertController* alertContrl=[UIAlertController alertControllerWithTitle:@"提 示" message:@"您确定要添加吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertContrl addAction:cancel];
        
        [alertContrl addAction:confirm];
        
        [self presentViewController:alertContrl animated:YES completion:nil];
        
    }
    
    
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    
    cell.textLabel.text=self.infoArr[indexPath.row];
    
    cell.textLabel.textColor=[UIColor greenColor];
    
    if (indexPath.row==0) {
        UITextField* nameText=[[UITextField alloc] initWithFrame:CGRectMake(cWidth/2-30, 15, 30+cWidth/2, 64-30)];
        nameText.placeholder=@"请填写下事件名字";
        nameText.textColor=[UIColor orangeColor];
        self.nameText=nameText;
        self.nameText.delegate=self;
        [cell.contentView addSubview:nameText];
    }
    
    if (indexPath.row==1) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel* degreeLabel=[[UILabel alloc] initWithFrame:CGRectMake(cWidth/2-30, 15, 30+cWidth/2-30, 64-30)];
        
        [cell.contentView addSubview:degreeLabel];

        degreeLabel.text=@"一般重要";
        
        self.degreeLabel=degreeLabel;
        self.degreeLabel.textColor=[UIColor orangeColor];
        
    }else if (indexPath.row==2){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel* dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(cWidth/2-30, 15, 30+cWidth/2-30, 64-30)];
        
        [cell.contentView addSubview:dateLabel];
        
        
        dateLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)self.thisYear,(long)self.thisMonth,(long)self.thisDay];
        
        self.dateLabel=dateLabel;
        self.dateLabel.textColor=[UIColor orangeColor];
    }
    
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (cTableH-64)/3;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameText resignFirstResponder];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        [self degreeChoose];
    }else if (indexPath.row==2){
        [self.nameText resignFirstResponder];
        [self dateChoose];
    }
}



-(void)degreeChoose{
    UIAlertAction* most=[UIAlertAction actionWithTitle:@"最重要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.degreeLabel.text=@"最重要";
        self.passDegree=1;
    }];
    UIAlertAction* import=[UIAlertAction actionWithTitle:@"比较重要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.degreeLabel.text=@"比较重要";
        self.passDegree=2;
    }];
    UIAlertAction* common=[UIAlertAction actionWithTitle:@"一般重要" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.degreeLabel.text=@"一般重要";
        self.passDegree=3;
    }];
    
    UIAlertController* alertContrl=[UIAlertController alertControllerWithTitle:@"选择重要程度" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertContrl addAction:most];
    [alertContrl addAction:import];
    [alertContrl addAction:common];
    
    [self presentViewController:alertContrl animated:YES completion:nil];
}

-(void)dateChoose{
    
}

#pragma uipickerDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) {
        return 80;
    }
    if (component==1) {
        return 12;
    }
    
    
    return [SStool daysWithYear:self.thatYear month:self.thatMonth];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return [NSString stringWithFormat:@"%ld年",(long)(self.thisYear+row)];
    }
    
    if (component==1) {
        return [NSString stringWithFormat:@"%ld月",(long)(row+1)];
    }
    
    return [NSString stringWithFormat:@"%ld日",(long)(row+1)];
    
}

//只有当选择时才会调用，点击时不会调用

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (component==0) {
        
        
        if (self.thisYear==(self.thisYear+row)) {
            
            self.thatYear=self.thisYear;
            
            //处理年份相同时，月份小于当前月份
            if (self.thatMonth<self.thisMonth) {
                self.thatMonth=self.thisMonth;
                [self.picker selectRow:self.thatMonth-1 inComponent:1 animated:YES];
                //月份调整相同时，处理日小于当前日
                if (self.thatDay<self.thisDay) {
                    self.thatDay=self.thisDay;
                    [self.picker selectRow:self.thatDay-1 inComponent:2 animated:YES];
                }
                //处理月份相同,处理日小于当前日
            }else if (self.thatMonth==self.thisMonth){
                
                if (self.thatDay<self.thisDay) {
                    self.thatDay=self.thisDay;
                    [self.picker selectRow:self.thatDay-1 inComponent:2 animated:YES];
                }
                
            }
            
            
        }else{
            
            self.thatYear=self.thisYear+row;
            
        }
        
        [self.picker reloadComponent:2];

        self.dateLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)self.thatYear,(long)self.thatMonth,(long)self.thatDay];
        
        return;
    }
    
    if (component==1) {
        if (self.thatYear==self.thisYear) {
            if (self.thisMonth>row+1) {
                self.thatMonth=self.thisMonth;
                [self.picker selectRow:self.thatMonth-1 inComponent:1 animated:YES];
                
                if (self.thisDay>self.thatDay) {
                    self.thatDay=self.thisDay;
                    [self.picker selectRow:self.thatDay-1 inComponent:2 animated:YES];
                }
            }else if (self.thisMonth==(row+1)){
                self.thatMonth=self.thisMonth;
                if (self.thisDay>self.thatDay) {
                    self.thatDay=self.thisDay;
                    [self.picker selectRow:self.thatDay-1 inComponent:2 animated:YES];
                }
            }else{
                self.thatMonth=row+1;
            }
        }else{
            self.thatMonth=row+1;
        }
       
        [self.picker reloadComponent:2];
        
        self.dateLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)self.thatYear,(long)self.thatMonth,(long)self.thatDay];
        
        return;
    }
    
    if (component==2) {
        
        if (self.thisYear==self.thisYear&&self.thatMonth==self.thisMonth) {
            if (self.thisDay>row+1) {
                self.thatDay=self.thisDay;
                [self.picker selectRow:self.thatDay-1 inComponent:2 animated:YES];
            }else{
                self.thatDay=row+1;
            }
        }else{
            self.thatDay=row+1;
        }
        
        self.dateLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)self.thatYear,(long)self.thatMonth,(long)self.thatDay];
        
        return ;
    }
    
}




#pragma uitextfieldDelegate



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameText resignFirstResponder];
    return YES;
}











@end
