//
//  SSdownController.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSdownController.h"
#import "SShandleController.h"
#import "SSconstant.h"
#import "SSdownCell.h"
#import "SStool.h"
#import "FMDB.h"

@interface SSdownController ()

@property(nonatomic,strong)NSMutableArray* impEvents;
@property(nonatomic,strong)NSMutableArray* comEvents;
@property(nonatomic,strong)NSMutableArray* mostEvent;
@property(nonatomic,weak)UILabel* ss_dateView;
@property(nonatomic,weak)UILabel* ss_eventView;
@property(nonatomic,weak)UILabel* ss_leftView;
@property(nonatomic,weak)UIImageView* header;



@end

@implementation SSdownController

NSInteger nowDay;

-(instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

-(NSMutableArray *)impEvents{
    if (_impEvents==nil) {
        _impEvents=[NSMutableArray array];
        
    }
    return _impEvents;
}

-(NSMutableArray *)comEvents{
    if (_comEvents==nil) {
        _comEvents=[NSMutableArray array];
        
    }
    return _comEvents;
}

-(NSMutableArray *)mostEvent{
    if (_mostEvent==nil) {
        _mostEvent=[NSMutableArray array];
    }
    return _mostEvent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    nowDay=[[SStool getDateComponent] day];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    refresh.tintColor = [UIColor blueColor];
    [refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添 加" style:UIBarButtonItemStylePlain target:self action:@selector(handleItemTransition)];
    
    self.navigationController.navigationBar.backgroundColor=[UIColor greenColor];
    [self setupHeader];
    [self refreshAllData];
    
}

-(void)refreshData{
    
    if (nowDay==[[SStool getDateComponent] day]) {
        [self.refreshControl endRefreshing];
        return;
    }else{
        [self.mostEvent removeAllObjects];
        [self.impEvents removeAllObjects];
        [self.comEvents removeAllObjects];
        [self setupHeader];
        [self refreshAllData];
        [self.refreshControl endRefreshing];
        nowDay=[[SStool getDateComponent] day];
    }
    
    
}

-(void)handleItemTransition{
    
    SShandleController* handlerContrl=[[SShandleController alloc] init];
    //handlerContrl
    
    handlerContrl.blockParams=^(NSString* name,NSInteger degree,NSInteger year,NSInteger month,NSInteger day){
        //利用代码块进行传值
        NSDictionary* dict=@{@"event":name,@"year":[NSNumber numberWithInt:(int)year],@"month":[NSNumber numberWithInt:(int)month],@"day":[NSNumber numberWithInt:(int)day]};
        
        if (degree==2) {
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:self.impEvents.count inSection:0];
            [self.impEvents addObject:dict];
            NSArray* indexPaths=@[indexPath];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }else if (degree==3){
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:self.comEvents.count inSection:1];
            [self.comEvents addObject:dict];
            NSArray* indexPaths=@[indexPath];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }else if (degree==1){
            if (self.mostEvent.count<1) {
                [self.mostEvent addObject:dict];
                [self setHeaderData];
            }else if (self.mostEvent.count>0){
                NSDictionary* oldDict=[self.mostEvent objectAtIndex:0];
                NSIndexPath* indexPath=[NSIndexPath indexPathForRow:self.impEvents.count inSection:0];
                [self.impEvents addObject:oldDict];
                NSArray* indexPaths=@[indexPath];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.mostEvent removeObjectAtIndex:0];
                [self.mostEvent addObject:dict];
                [self setHeaderData];
            }
        }
        
        
        
        
        
        
    };
    
    [self.navigationController pushViewController:handlerContrl animated:YES];
    
}



-(void)setupHeader{
    UIImageView* header=[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, 0, 160)];
    [header setImage:[UIImage imageNamed:@"down.jpg"]];
    
    header.alpha=0.9;
    
    
    self.tableView.tableHeaderView=header;
    self.header=header;
    
    CGFloat centerX=kWidth/2;
    
    UILabel* dateView=[[UILabel alloc] initWithFrame:CGRectMake(centerX-kWidth/2, 120, kWidth, 30)];
    dateView.textAlignment=NSTextAlignmentCenter;
    [self.header addSubview:dateView];
    self.ss_dateView=dateView;
    self.ss_dateView.textColor=[UIColor greenColor];
    
    
    UILabel* eventView=[[UILabel alloc] initWithFrame:CGRectMake(centerX-kWidth/2, 80, kWidth, 30)];
    eventView.textAlignment=NSTextAlignmentCenter;
    [eventView setFont:[UIFont systemFontOfSize:25]];
    [self.header addSubview:eventView];
    self.ss_eventView=eventView;
    self.ss_eventView.textColor=[UIColor purpleColor];
    
    UILabel* leftView=[[UILabel alloc] initWithFrame:CGRectMake(centerX-kWidth/2,10, kWidth, 60)];
    [leftView setFont:[UIFont systemFontOfSize:60]];
    leftView.textAlignment=NSTextAlignmentCenter;
    [self.header addSubview:leftView];
    self.ss_leftView=leftView;
    self.ss_leftView.textColor=[UIColor blueColor];
    [self setHeaderData];
    
    UILongPressGestureRecognizer* headerPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(headerPressHandler:)];
    headerPress.minimumPressDuration=1.0;
    header.userInteractionEnabled=YES;
    [self.header addGestureRecognizer:headerPress];
}

-(void)headerPressHandler:(id)sender{
    UILongPressGestureRecognizer* headerPress=(UILongPressGestureRecognizer*)sender;
    
    if (headerPress.state==UIGestureRecognizerStateBegan) {
        if (self.mostEvent.count>0) {
            UIAlertAction* deleteAction=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //对数据的操作分两步：数据库和界面
                
                FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
                
                if (![db open]) {
                    return;
                }
                NSString* sql_delete=@"delete from table_down where name = (?)";
                NSString* argu=[self.mostEvent objectAtIndex:0][@"event"];
                [db executeUpdate:sql_delete withArgumentsInArray:@[argu]];
                
                [self.mostEvent removeObjectAtIndex:0];
                [self setHeaderData];
                
                
                
            }];
            UIAlertAction* editAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            NSString* message=self.mostEvent[0][@"event"];
            
            UIAlertController* alertControl=[UIAlertController alertControllerWithTitle:@"提 示" message:[NSString stringWithFormat:@"您正在操作：%@",message] preferredStyle:UIAlertControllerStyleAlert];
            
            [alertControl addAction:deleteAction];
            [alertControl addAction:editAction];
            
            [self presentViewController:alertControl animated:YES completion:nil];
        }
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.impEvents.count;
    }
    return self.comEvents.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID=@"cell";
    SSdownCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[SSdownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.section==0) {
        cell.downDict=self.impEvents[indexPath.row];
    }else if(indexPath.section==1){
        cell.downDict=self.comEvents[indexPath.row];
    }
    
    
    UILongPressGestureRecognizer* cellPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellPressHandler:)];
    cellPress.minimumPressDuration=1.0;
    [cell addGestureRecognizer:cellPress];
    
    
    
    return cell;
}



-(void)cellPressHandler:(id)sender{
    UILongPressGestureRecognizer* gesture=(UILongPressGestureRecognizer*)sender;
    NSIndexPath *indexPath=[self.tableView indexPathForCell:(SSdownCell*)(gesture.view)];
    
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        
        
        NSString* name;
        if (section==0) {
            name=[self.impEvents objectAtIndex:row][@"event"];
        }else if (section==1){
            name=[self.comEvents objectAtIndex:row][@"event"];
        }
        //删除
        
        
        UIAlertAction* deleteAction=[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            //对数据的操作分两步：数据库和界面
            
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            NSString* sql_delete=@"delete from table_down where name = (?)";
            [db executeUpdate:sql_delete withArgumentsInArray:@[name]];
            [db close];
            
            if (section==0) {
                [self.impEvents removeObjectAtIndex:row];
            }else if (section==1){
                [self.comEvents removeObjectAtIndex:row];
            }
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:row inSection:section];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
        }];
        //编辑
        UIAlertAction* editAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        
        UIAlertController* alertControl=[UIAlertController alertControllerWithTitle:@"提 示" message:[NSString stringWithFormat:@"您正在操作：%@",name] preferredStyle:UIAlertControllerStyleAlert];
        
        [alertControl addAction:deleteAction];
        [alertControl addAction:editAction];
        
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    UILabel* label=[[UILabel alloc] initWithFrame:view.frame];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor orangeColor];
    if (section==0) {
        label.text=@"重要的事情";
    }else if (section==1){
        label.text=@"记录的事情";
    }
    
    [view addSubview:label];
    [label setFont:[UIFont systemFontOfSize:28]];
    if (self.impEvents.count==00&&self.comEvents.count==0) {
        return nil;
    }
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

-(void)refreshAllData{
    
    
    FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
    
    if (![db open]) {
        return;
    }
    
    NSString* sql_table=@"create table if not exists table_down (id integer primary key,name text,year int ,month int ,day int,kind int)";
    
    
    if (![db executeUpdate:sql_table]) {
        return;
    }
    
//    NSString* sql_insert=@"insert into table_down (name,year,month,day,kind) values (?,?,?,?,?)";
//    [db executeUpdate:sql_insert withArgumentsInArray:@[@"高考",@2016,@10,@13,@2]];
//    [db executeUpdate:sql_insert withArgumentsInArray:@[@"大学毕业",@2015,@10,@13,@1]];
//    [db executeUpdate:sql_insert withArgumentsInArray:@[@"大三寒假",@2013,@10,@13,@3]];
    
    
    NSString* sql_query=@"select* from table_down";
    FMResultSet* result=[db executeQuery:sql_query];
    
    while ([result next]) {
        NSString* event=[result stringForColumn:@"name"];
        int  year=[result intForColumn:@"year"];
        int month=[result intForColumn:@"month"];
        int  day=[result intForColumn:@"day"];
        int  kind=[result intForColumn:@"kind"];
        
        NSDictionary* dict=@{@"event":event,@"year":[NSNumber numberWithInt:year],@"month":[NSNumber numberWithInt:month],@"day":[NSNumber numberWithInt:day]};
        switch (kind) {
            case 1:
                [self.mostEvent addObject:dict];
                break;
            case 2:
                [self.impEvents addObject:dict];
                break;
            case 3:
                [self.comEvents addObject:dict];
                break;
                
            default:
                break;
        }
    }
    
    
    
    [db close];
    
    [self reloadAllData];
}



/**
 *  更新全部数据
 */
-(void)reloadAllData{
    [self.tableView reloadData];
    [self setHeaderData];
}

/**
 *  更新头部数据
 */

-(void)setHeaderData{
    if (self.mostEvent.count>0) {
        
        NSInteger year=[self.mostEvent[0][@"year"] integerValue];
        NSInteger month=[self.mostEvent[0][@"month"] integerValue];
        NSInteger day=[self.mostEvent[0][@"day"] integerValue];
        
        self.ss_dateView.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
        self.ss_eventView.text=self.mostEvent[0][@"event"];
        
        NSString* daysLeft=[NSString stringWithFormat:@"%ld天",(long)[SStool daysWithOldYear:year oldMonth:month oldDay:day]];
        self.ss_leftView.text=daysLeft;
        
    }else{
        self.ss_dateView.text=@"";
        self.ss_eventView.text=@"";
        self.ss_leftView.text=@"";
    }
    
    
}




@end
