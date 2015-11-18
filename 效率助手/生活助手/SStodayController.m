//
//  SStodayController.m
//  生活助手
//
//  Created by weichuang on 10/9/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SStodayController.h"
#import "SSconstant.h"
#import "SStool.h"
#import "FMDB.h"



@interface SStodayController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSMutableArray* todayEvents;

@property(nonatomic,strong)NSMutableArray* tommorrowEvents;


@end


@implementation SStodayController

NSInteger flagRefresh=0;
NSInteger presentedDay;


-(instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(NSMutableArray *)todayEvents{
    if (_todayEvents==nil) {
        _todayEvents=[NSMutableArray array];
    }
    return _todayEvents;
}

-(NSMutableArray *)tommorrowEvents{
    if (_tommorrowEvents==nil) {
        _tommorrowEvents=[NSMutableArray array];
    }
    return _tommorrowEvents;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    flagRefresh=1;
    presentedDay=[[SStool getDateComponent] day];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.view.backgroundColor=[UIColor whiteColor];


    
    [self setupHeaderView];
    
    [self getDataFromDB];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (flagRefresh==0&&presentedDay!=[[SStool getDateComponent] day]) {
        [self.todayEvents removeAllObjects];
        [self.tommorrowEvents removeAllObjects];
        [self getDataFromDB];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    flagRefresh=0;
}


-(void)getDataFromDB{
    
    FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
    
    if (![db open]) {
        return;
    }
    
    NSString* sql_table=@"create table if not exists table_today (id integer primary key,event text,finish int,year int ,month int ,day int)";
    
    if (![db executeUpdate:sql_table]) {
        return;
    }
    
    NSDateComponents* todayComps=[SStool getDateComponent];
    
    NSInteger todayYear=[todayComps year];
    NSInteger todayMonth=[todayComps month];
    NSInteger todayDay=[todayComps day];
    
    NSNumber *yearNumber=[NSNumber numberWithInteger:todayYear];
    NSNumber *monthNumber=[NSNumber numberWithInteger:todayMonth];
    NSNumber *dayNumber=[NSNumber numberWithInteger:todayDay];
    
    NSString* sql_delete=@"delete from table_today where (year<(?)) or (year=(?) and month<(?)) or (year=(?) and month=(?) and day<(?))";
    [db executeUpdate:sql_delete withArgumentsInArray:@[yearNumber,yearNumber,monthNumber,yearNumber,monthNumber,dayNumber]];
    
    
    NSString* sql_query=@"select* from table_today";
    FMResultSet* result=[db executeQuery:sql_query];

    while ([result next]) {
        
        NSString* event=[result stringForColumn:@"event"];
        NSInteger finish=[result intForColumn:@"finish"];
        NSInteger day=[result intForColumn:@"day"];
        
        NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:event,@"event",[NSNumber numberWithInteger:finish],@"finish", nil];
        if (day==todayDay) {
            [self.todayEvents addObject:dict];
        }else{
            [self.tommorrowEvents addObject:dict];
        }
        
    }
    
    [self.tableView reloadData];
}



-(void)setupHeaderView{
    
    UIView* header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 160)];
    header.alpha=0.9;
    self.tableView.tableHeaderView=header;
    header.backgroundColor=[UIColor grayColor];
    

    
    UIImageView* titleView=[[UIImageView alloc] initWithFrame:header.frame];
    titleView.image=[UIImage imageNamed:@"today.jpg"];
    [header addSubview:titleView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.todayEvents.count;
    }
    return self.tommorrowEvents.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
        cell.textLabel.text=self.todayEvents[row][@"event"];
    }else if (section==1){
        cell.textLabel.text=self.tommorrowEvents[row][@"event"];
    }
    
    cell.textLabel.textColor=[UIColor greenColor];
    
    if (section==0) {
        UISwitch* cellSwitch=[[UISwitch alloc] init];
        cellSwitch.frame=CGRectMake(kWidth-61, 10, 0, 0);
        [cellSwitch addTarget:self action:@selector(handleValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSInteger finish=[(NSNumber*)(self.todayEvents[row][@"finish"]) integerValue];
        if (finish==1) {
            [cellSwitch setOn:YES];
        }
        
        [cell.contentView addSubview:cellSwitch];
    }
    
    //为单元格添加长按事件
    
    UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration=1.5;
    [cell addGestureRecognizer:longPress];
    
    return cell;
}

-(void)handleLongPress:(id)sender{
    
    
    UILongPressGestureRecognizer* longPress=(UILongPressGestureRecognizer*)sender;
    
    if (longPress.state==UIGestureRecognizerStateBegan) {
        
        UITableViewCell* cell=(UITableViewCell*)longPress.view;
        
        NSIndexPath* indexPath=[self.tableView indexPathForCell:cell];
        NSInteger section=indexPath.section;
        NSInteger row=indexPath.row;
        
        NSString* message;
        
        if (section==0) {
            message=self.todayEvents[row][@"event"];
        }else if (section==1){
            message=self.tommorrowEvents[row][@"event"];
        }
        
        UIAlertAction* delete=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //处理数据库数据
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            
            NSString* sql_delete=@"delete from table_today where event = (?)";
            
            
            
            [db executeUpdate:sql_delete withArgumentsInArray:@[message]];
            
            //处理本界面数据
            
            if (section==0) {
                [self.todayEvents removeObjectAtIndex:row];
            }else if (section==1){
                [self.tommorrowEvents removeObjectAtIndex:row];
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }];
        
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
    
        
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定要删除%@",message] preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:delete];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowInSection:(NSInteger)section{
    return 51;
}

-(void)handleValueChanged:(id)sender{
    
    UISwitch* switchCell=(UISwitch*)sender;
    
    //不允许用户从完成状态转为未完成状态
    if (switchCell.on==NO) {
        [switchCell setOn:YES];
        [SStool alertWithController:self Title:@"提示" info:@"任务已完成，无法修改" btnTitle:@"知道啦"];
        return ;
    }
    
    UITableViewCell* cell=(UITableViewCell*)switchCell.superview.superview;
    NSIndexPath* indexPath=[self.tableView indexPathForCell:cell];
    NSInteger row=indexPath.row;
    NSString* event=self.todayEvents[row][@"event"];
    
    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"做完了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理数据库数据
        FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
        
        if (![db open]) {
            return;
        }
        
        NSString* sql_update=@"update table_today set finish=1 where event = (?)";
        [db executeUpdate:sql_update withArgumentsInArray:@[event]];
        
        [db close];
        
    }];
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"还没呢" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [switchCell setOn:NO];
    }];
    
    
    NSString* message=[NSString stringWithFormat:@"您完成了%@吗",event];
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//定制表格视图的头部

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
    
    UILabel* title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, kWidth/2, 44)];
    [title setFont:[UIFont systemFontOfSize:20]];
    [header addSubview:title];
    title.textColor=[UIColor redColor];
    
    UIButton* add=[[UIButton alloc] initWithFrame:CGRectMake(kWidth/2, 10, kWidth/2, 44)];
    [header addSubview:add];
    add.tag=100+section;
    [add setTitle:@"添加计划" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [add.titleLabel setTextAlignment:NSTextAlignmentRight];
    [add addTarget:self action:@selector(popEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    if (section==0) {
        title.text=@"今天要做的事情";
        [add setTitle:@"添加今日计划" forState:UIControlStateNormal];
    }else if (section==1){
        title.text=@"明天要做的事情";
        [add setTitle:@"添加明日计划" forState:UIControlStateNormal];
    }
    
    return header;
}

-(void)popEdit:(id)sender{
    UIButton* btn=(UIButton*)sender;
    NSInteger flag=btn.tag;
    
    NSDateComponents* todayComps=[SStool getDateComponent];
    
    NSInteger todayYear=[todayComps year];
    NSInteger todayMonth=[todayComps month];
    NSInteger todayDay=[todayComps day];
    
    NSDateComponents* tomorrowComps=[SStool getDateComponentWithDays:1];
    
    NSInteger tomorrowYear=[tomorrowComps year];
    NSInteger tomorrowMonth=[tomorrowComps month];
    NSInteger tomorrowDay=[tomorrowComps day];
    
    
    
    
    NSString* message;
    if (flag==100) {
        message=@"添加今日的计划";
    }else if (flag==101){
        message=@"添加明日的计划";
    }
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.backgroundColor=[UIColor colorWithRed:0.616 green:0.784 blue:0.667 alpha:1.0];
    }];
    
    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField* choice=[alert.textFields firstObject];
        NSString* text=choice.text;
        if ([text isEqualToString:@""]) {
            [SStool alertWithController:self Title:@"小提示" info:@"文本框内容不能为空" btnTitle:@"知道啦"];
        }else{
            //将数据添加至数据库
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            
            NSNumber* dayNumber;
            NSNumber* monthNumber;
            NSNumber* yearNumber;
            if (flag==100) {
                dayNumber=[NSNumber numberWithInteger:todayDay];
                monthNumber=[NSNumber numberWithInteger:todayMonth];
                yearNumber=[NSNumber numberWithInteger:todayYear];
            }else if (flag==101){
                dayNumber=[NSNumber numberWithInteger:tomorrowDay];
                monthNumber=[NSNumber numberWithInteger:tomorrowMonth];
                yearNumber=[NSNumber numberWithInteger:tomorrowYear];
            }
            
            NSString* sql_insert=@"insert into table_today (event,finish,year ,month ,day) values(?,?,?,?,?)";
            [db executeUpdate:sql_insert withArgumentsInArray:@[text,@0,yearNumber,monthNumber,dayNumber]];
            [db close];
            //刷新本界面
            NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:text,@"event",[NSNumber numberWithInteger:0],@"finish", nil];
            
            NSInteger row;
            if (flag==100) {
                row=self.todayEvents.count;
                [self.todayEvents addObject:dict
                 ];
                
            }else if (flag==101){
                row=self.tommorrowEvents.count;
                [self.tommorrowEvents addObject:dict];
            }
            
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:row inSection:flag-100];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
    }];
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消添加" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}





@end
