//
//  SSrepeatController.m
//  生活助手
//
//  Created by weichuang on 10/9/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
/*
 @"ss_event"事件名
 @"ss_makeDate"事件制定时间
 @"ss_frequency"做该事的频率
 @"isFinished"本次是否完成
 @"ss_unFinishTimes"未完成次数 bool
 @"ss_finishTimes"完成次数
 */

/*
 table_repeat 数据表名
 repeat.db 数据库文件名
 id integer primary key 主键
 event text 事件名
 finishTimes int 完成次数
 aYear int 制定事件年份
 aMonth int 制定事件月份
 aDay int 制定事件日
 bYear int 最后更新年份
 bMonth int 最后更新月份
 bDay int 最后更新日
 circle int 更新周期
 */

#import "SSrepeatController.h"
#import "SSrepeatCell.h"
#import "SSrepeat.h"
#import "SSplanController.h"
#import "SStool.h"
#import "FMDB.h"

@interface SSrepeatController ()<planCtrlLeftBarDelegate,repeatCellDelegate>

@property(nonatomic,strong)NSMutableArray* dictArray;

@end

@implementation SSrepeatController

NSInteger presentDay;

-(NSMutableArray *)dictArray{
    if (_dictArray==nil) {
        _dictArray=[NSMutableArray array];
    }
    return _dictArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator=NO;

    presentDay=[[SStool getDateComponent] day];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    refresh.tintColor = [UIColor blueColor];
    [refresh addTarget:self action:@selector(refreshDatas) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self setupHeader];
    [self refreshTableData];
}

-(void)setupHeader{
    UIView* header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 36)];
    header.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dictArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID=@"cell";
    SSrepeatCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[SSrepeatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    SSrepeat* repeat=[SSrepeat repeatWithDict:self.dictArray[indexPath.row]];
    cell.repeat=repeat;
    cell.delegate=self;
    
    UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration=1.2;
    [cell addGestureRecognizer:longPress];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(void)planCtrlLeftBarClick{
    [self popAdd];
}

-(void)refreshDatas{
    
    if (presentDay==[[SStool getDateComponent] day]) {
        [self.refreshControl endRefreshing];
        return;
    }else{
        
        [self.dictArray removeAllObjects];
        [self refreshTableData];
        presentDay=[[SStool getDateComponent] day];
        
    }
    
    
}

//加载视图时从数据库中获取数据
-(void)refreshTableData{
    FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
    
    if (![db open]) {
        return;
    }

    
    
    NSString* sql_table=@"create table if not exists table_repeat (id integer primary key,event text,finishTimes int ,aYear int,aMonth int ,aDay int,bYear int,bMonth int ,bDay int ,circle int,flag int)";
    
    
    if (![db executeUpdate:sql_table]) {
        return;
    }
    
    NSString* sql_query=@"select * from table_repeat";
    FMResultSet* result=[db executeQuery:sql_query];
    while ([result next]) {
        //取出标记
        NSInteger flag=[result intForColumn:@"flag"];
        NSString* event=[result stringForColumn:@"event"];
        NSInteger circle=[result intForColumn:@"circle"];
        NSInteger finishTimes=[result intForColumn:@"finishTimes"];
        
        //制定时间
        NSInteger aYear=[result intForColumn:@"aYear"];
        NSInteger aMonth=[result intForColumn:@"aMonth"];
        NSInteger aDay=[result intForColumn:@"aDay"];
        
        //最后更新时间
        NSInteger bYear=[result intForColumn:@"bYear"];
        NSInteger bMonth=[result intForColumn:@"bMonth"];
        NSInteger bDay=[result intForColumn:@"bDay"];
        
        //计算制定时间起来现在隔了多少天
        NSInteger totalTimes=[SStool daysWithSmallYear:aYear SmallMonth:aMonth SamllDay:aDay];
        //一共有多个周期
        NSInteger circles=totalTimes/circle;
    
        //最后更新时间与制定时间相差天数
        NSInteger daysUpdate=[SStool daysWithaYear:bYear aMonth:bMonth aDay:bDay bYear:aYear bMonth:aMonth bDay:aDay];
        //最后一个完整周期与制定时间相差天数
        NSInteger daysCircle=circle*circles-1;
        
        NSInteger unfinishTimes=circles-finishTimes;
        BOOL isfinished=NO;
        
        if ((daysCircle<daysUpdate)&&((int)flag==1)) {
            isfinished=YES;
            unfinishTimes+=1;
        }
        NSString* makeDate=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)aYear,(long)aMonth,(long)aDay];
        NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:event,@"ss_event",makeDate,@"ss_makeDate",[NSNumber numberWithInteger:circle],@"ss_frequency",[NSNumber numberWithBool:isfinished],@"isFinished",[NSNumber numberWithInteger:finishTimes], @"ss_finishTimes",[NSNumber numberWithInteger:unfinishTimes], @"ss_unFinishTimes", nil];
        [self.dictArray addObject:dict];
        
    }
    
    [self.refreshControl endRefreshing];
}

//handle the event of longpress gesture
-(void)handleLongPress:(id)sender{
    UILongPressGestureRecognizer* longPress=(UILongPressGestureRecognizer*)sender;
    SSrepeatCell* repeatCell=(SSrepeatCell*)(longPress.view);
    NSIndexPath* indexPath=[self.tableView indexPathForCell:repeatCell];
    
    if (longPress.state==UIGestureRecognizerStateBegan) {
        
        NSMutableDictionary* dict=[self.dictArray objectAtIndex:indexPath.row];
        NSString* eventName=dict[@"ss_event"];
        
        UIAlertAction* delete=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //处理数据库数据
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            
            NSString* sql_delete=@"delete from table_repeat where event =(?)";
            [db executeUpdate:sql_delete withArgumentsInArray:@[eventName]];
             [db close];
             
             //处理本界面数据
            
            [self.dictArray removeObjectAtIndex:indexPath.row];
            
            NSIndexPath* indexPathdelete=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPathdelete] withRowAnimation:UITableViewRowAnimationBottom];
            
        }];
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        
        
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"你确定要删除%@",eventName] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:delete];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

//handle the event of click "add" button
-(void)popAdd{
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"请填好信息" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"事件名";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"执行周期(大于0整数)";
    }];
    
    UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField* first=[alert.textFields objectAtIndex:0];
                UITextField* second=[alert.textFields objectAtIndex:1];
        
        if([first.text isEqualToString:@""]||[second.text isEqualToString:@""]||![SStool isPureInt:second.text]||([second.text intValue] <1)){
            [SStool alertWithController:self Title:@"错误提示" info:@"无法添加：填写内容不能为空和第二个为大于0的整数哦" btnTitle:@"知道啦"];
        }else{
            NSString* event=first.text;
            NSString* circle=second.text;
            
            //添加到数据库
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            NSDateComponents* comps=[SStool getDateComponent];
            
            NSInteger year=[comps year];
            NSNumber* yearNumber=[NSNumber numberWithInteger:year];
            
            NSInteger month=[comps month];
            NSNumber* monthNumber=[NSNumber numberWithInteger:month];
            
            NSInteger day=[comps day];
            NSNumber* dayNumber=[NSNumber numberWithInteger:day];
            
            NSNumber* circleNumber=[NSNumber numberWithInteger:[circle integerValue]];
            
            NSString* sql_insert=@"insert into table_repeat(event,finishTimes ,aYear,aMonth,aDay ,bYear ,bMonth ,bDay,circle,flag) values(?,0,?,?,?,?,?,?,?,0)";
            [db executeUpdate:sql_insert withArgumentsInArray:@[event,yearNumber,monthNumber,dayNumber,yearNumber,monthNumber,dayNumber,circleNumber]];
            
            //更新本界面
            NSString* makeDate=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
            NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:event,@"ss_event",makeDate,@"ss_makeDate",circleNumber,@"ss_frequency",[NSNumber numberWithBool:NO],@"isFinished",[NSNumber numberWithInteger:0], @"ss_finishTimes",[NSNumber numberWithInteger:0], @"ss_unFinishTimes", nil];
            [self.dictArray addObject:dict];
            
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:self.dictArray.count-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            
        }
        
    }];
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];

    
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)repeateCellWithCell:(SSrepeatCell *)repeatCell cellSwitch:(UISwitch *)cellSwitch{
    
    NSIndexPath* indexPath=[self.tableView indexPathForCell:repeatCell];
    NSInteger row=indexPath.row;
    
    if (cellSwitch.on==NO) {
        
        [SStool alertWithController:self Title:@"温馨提示" info:@"完成的无法修改" btnTitle:@"知道啦"];
        [cellSwitch setOn:YES];
        
    }else if (cellSwitch.on==YES){
        
        UIAlertAction* confirm=[UIAlertAction actionWithTitle:@"完成啦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //本次任务完成时
            
            NSMutableDictionary* dict=self.dictArray[row];
            NSString* eventName=dict[@"ss_event"];
            //处理数据库中的数据
            
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            
            //
            NSDateComponents* comps=[SStool getDateComponent];
            NSNumber* yearNumber=[NSNumber numberWithInteger:[comps year]];
            NSNumber* monthNumber=[NSNumber numberWithInteger:[comps month]];
            NSNumber* dayNumber=[NSNumber numberWithInteger:[comps day]];
            
            NSString* sql_update=@"update table_repeat set finishTimes=(finishTimes+1),flag=1,bYear=(?),bMonth=(?),bDay=(?) where event=(?) ";
            [db executeUpdate:sql_update withArgumentsInArray:@[yearNumber,monthNumber,dayNumber,eventName]];
            
            //处理本界面的数据
            
            /*@"isFinished"本次是否完成
            @"ss_unFinishTimes"未完成次数
            @"ss_finishTimes"完成次数
             BOOL isFinished
             */
            
            dict[@"isFinished"]=[NSNumber numberWithBool:YES];
            dict[@"ss_finishTimes"]=[NSNumber numberWithInteger:[(NSNumber*)(dict[@"ss_finishTimes"]) integerValue]+1];
            
            
            NSIndexPath* indexPathUpdate=[NSIndexPath indexPathForItem:row inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPathUpdate] withRowAnimation:UITableViewRowAnimationBottom];
            
        }];
        
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"还没呢" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [cellSwitch setOn:NO];
        }];
        
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"哈哈" message:@"本次任务完成了吗？别偷懒哦" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:confirm];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}



@end
