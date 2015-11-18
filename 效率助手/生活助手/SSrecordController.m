//
//  SSrecordController.m
//  生活助手
//
//  Created by weichuang on 10/8/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#define kWidth self.view.frame.size.width

#import "SSrecordController.h"
#import "SSrecord.h"
#import "SSrecordFrame.h"
#import "SSrecordCell.h"
#import "SSrecordView.h"
#import "FMDB.h"
#import "SStool.h"

@interface SSrecordController ()<recordViewDelegate,recordCellDelegate>

@property(nonatomic,strong)NSMutableArray* dictArray;
@property(nonatomic,strong)NSMutableArray* recoredFrames;
@property(nonatomic,weak)SSrecordView* recordView;

@end

@implementation SSrecordController

int flag_addOredit=0;
int edit_row=0;


-(SSrecordView *)recordView{
    if (_recordView==nil) {
        SSrecordView* recordView=[[SSrecordView alloc] initWithFrame:CGRectMake(10, 72, kWidth-20, 200)];
        [self.view.superview addSubview:recordView];
        self.recordView=recordView;
        self.recordView.delegate=self;
        
        
    }
    return _recordView;
}

-(NSMutableArray *)recoredFrames{
    if (_recoredFrames==nil) {
        _recoredFrames=[NSMutableArray array];
        
        for (int i=0; i<self.dictArray.count; i++) {
            SSrecord* record=[SSrecord recordWithDict:self.dictArray[i]];
            SSrecordFrame* frame=[[SSrecordFrame alloc] init];
            frame.ss_record=record;
            [_recoredFrames addObject:frame];
        }
    }
    return _recoredFrames;
}

-(NSMutableArray *)dictArray{
    if (_dictArray==nil) {
        _dictArray=[NSMutableArray array];
        
    }
    return _dictArray;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.tableView.backgroundView.alpha=0.9;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加记录" style:UIBarButtonItemStylePlain target:self action:@selector(addRecord)];
    
    [self refreshData];
    
}

-(void)refreshData{
    
 
    
    FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
    
    if (![db open]) {
        return;
    }
    
    NSString* sql_table=@"create table if not exists table_record (id integer primary key,content text,date text)";
    
    
    if (![db executeUpdate:sql_table]) {
        return;
    }
    
    NSString* sql_query=@"select* from table_record";
    FMResultSet* result=[db executeQuery:sql_query];
    
    while ([result next]) {
        NSString* content=[result stringForColumn:@"content"];
        NSString* date=[result stringForColumn:@"date"];
        NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:date,@"ss_date",content,@"ss_detail", nil];
        [self.dictArray addObject:dict];
        
    }
    
    [self.tableView reloadData];

}

-(void)addRecord{
    self.recordView.hidden=NO;
    flag_addOredit=0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dictArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID=@"cell";
    SSrecordCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[SSrecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.delegate=self;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView=nil;
    cell.recordFrame=self.recoredFrames[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSrecordFrame* frame=self.recoredFrames[indexPath.row];
    return frame.ss_rowHeight;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(void)recordViewCancelWith:(SSrecordView *)recordView{
    
    self.recordView.hidden=YES;
}

-(void)recordViewConfirmWith:(SSrecordView *)recordView content:(NSString *)content{
    
    if ([content isEqualToString:@""]) {
        UIAlertAction* action=[UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController* alertCtrl=[UIAlertController alertControllerWithTitle:@"提示" message:@"内容不能为空哦，亲" preferredStyle:UIAlertControllerStyleAlert];
        [alertCtrl addAction:action];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }else{
        
        NSDateComponents* comps=[SStool getDateComponent];
        NSString* date=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)[comps year],(long)[comps month],(long)[comps day]];
        
        FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
        
        if (![db open]) {
            return;
        }
        
        if (flag_addOredit==0) {
            NSString* sql_insert=@"insert into table_record (content,date) values (?,?)";
            [db executeUpdate:sql_insert withArgumentsInArray:@[content,date]];
            NSMutableDictionary* dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:date,@"ss_date",content,@"ss_detail", nil];
            [self.dictArray addObject:dict];
            
            
            //frame
            
            SSrecord* record=[SSrecord recordWithDict:dict];
            SSrecordFrame* frame=[[SSrecordFrame alloc] init];
            frame.ss_record=record;
            [self.recoredFrames addObject:frame];
            
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:self.dictArray.count-1 inSection:0];
            
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }else if (flag_addOredit==1){
            NSString* sql_update=@"update table_record set content = (?) where content = (?)";
            [db executeUpdate:sql_update withArgumentsInArray:@[content,self.dictArray[edit_row][@"ss_detail"]]];
            NSLog(@"edit_row=%d",edit_row);
            
            self.dictArray[edit_row][@"ss_detail"]=content;
            
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:edit_row inSection:0];
            
            
            SSrecord* record=[SSrecord recordWithDict:self.dictArray[edit_row]];
            SSrecordFrame* frame=[[SSrecordFrame alloc] init];
            frame.ss_record=record;
            _recoredFrames[edit_row]=frame;
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        
        
        self.recordView.hidden=YES;
    }
    
    
}

#pragma recordCellDelegate

-(void)recordCellLongPressWithrecordCell:(SSrecordCell *)cell{
    NSIndexPath* indexPath=[self.tableView indexPathForCell:cell];
    
    NSInteger row=indexPath.row;
    
    UIAlertAction* delete=[UIAlertAction actionWithTitle:@"删除该项" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除数据
        FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
        
        if (![db open]) {
            return;
        }
        
        NSString* sql_delete=@"delete from table_record where content = (?)";
        
        [db executeUpdate:sql_delete withArgumentsInArray:@[self.dictArray[row][@"ss_detail"]]];
        
        [self.dictArray removeObjectAtIndex:row];
        [self.recoredFrames removeObjectAtIndex:row];
        NSIndexPath* indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }];
    
    UIAlertAction* edit=[UIAlertAction actionWithTitle:@"编辑该项" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        edit_row=(int)row;
        flag_addOredit=1;
        self.recordView.hidden=NO;
        
    }];
    
    UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"" message:@"您正在编辑记录" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:delete];
    [alert addAction:edit];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
