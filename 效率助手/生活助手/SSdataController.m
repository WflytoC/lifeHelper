//
//  SSdataController.m
//  生活助手
//
//  Created by weichuang on 10/15/15.
//  Copyright © 2015 com.onesetp.WflytoC. All rights reserved.
//

#import "SSdataController.h"
#import "SStool.h"
#import "FMDB.h"

@interface SSdataController ()

@property(nonatomic,strong)NSMutableArray* dataPublicArray;
@property(nonatomic,strong)NSMutableArray* dataPrivateArray;
@property(nonatomic,strong)NSMutableArray* titleArray;

@end

@implementation SSdataController

-(NSMutableArray *)dataPublicArray{
    if (_dataPublicArray==nil) {
        _dataPublicArray=[NSMutableArray array];
    }
    return _dataPublicArray;
}

-(NSMutableArray *)dataPrivateArray{
    if (_dataPrivateArray==nil) {
        _dataPrivateArray=[NSMutableArray array];
    }
    return _dataPrivateArray;
}

-(NSMutableArray *)titleArray{
    if (_titleArray==nil) {
        _titleArray=[NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addData)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self obtainDataFromDB];
}

-(void)obtainDataFromDB{
    
    FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
    
    if (![db open]) {
        return;
    }
    
    NSString* sql_table=@"create table if not exists table_info (id integer primary key,account text,password text,isprivate int)";
    
    
    if (![db executeUpdate:sql_table]) {
        return;
    }
    
    NSString* sql_query=@"select * from table_info";
    
    FMResultSet* result=[db executeQuery:sql_query];
    
    while ([result next]) {
        NSString* account=[result stringForColumn:@"account"];
        NSString* password=[result stringForColumn:@"password"];
        NSInteger isprivate=[result intForColumn:@"isprivate"];
        if (isprivate==0) {
            [self.dataPrivateArray addObject:@"**********"];
        }else{
            [self.dataPrivateArray addObject:password];
        }
        [self.titleArray addObject:account];
        [self.dataPublicArray addObject:password];

    }
    
    [self.tableView reloadData];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text=self.dataPrivateArray[indexPath.section];
    cell.textLabel.textColor=[UIColor blueColor];
    
    UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration=1.2;
    [cell addGestureRecognizer:longPress];
    
    
    return cell;
}

-(void)handleLongPress:(id)sender{
    
    UILongPressGestureRecognizer* longPress=(UILongPressGestureRecognizer*)sender;
    UITableViewCell* cell=(UITableViewCell*)longPress.view;
    NSIndexPath* indexPath=[self.tableView indexPathForCell:cell];
    NSInteger section=indexPath.section;
    if (longPress.state==UIGestureRecognizerStateBegan) {
        
        NSInteger isPrivate;
        NSString* modifyTitle;
        if ([self.dataPrivateArray[section] isEqualToString:@"**********"]) {
            isPrivate=0;
            modifyTitle=@"设为明文";
        }else{
            isPrivate=1;
            modifyTitle=@"设为暗文";
        }
        
        UIAlertAction* modify=[UIAlertAction actionWithTitle:modifyTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            
            //处理设置为明文
            if (isPrivate==0) {
                
                NSString* sql_update=@"update table_info set isprivate=1 where account=(?)";
                [db executeUpdate:sql_update withArgumentsInArray:@[self.titleArray[section]]];
                
                self.dataPrivateArray[section]=self.dataPublicArray[section];
                
                NSIndexPath* indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                
            }else if (isPrivate==1){//设置为暗文
                NSString* sql_update=@"update table_info set isprivate=0 where account=(?)";
                [db executeUpdate:sql_update withArgumentsInArray:@[self.titleArray[section]]];
                
                self.dataPrivateArray[section]=@"**********";
                
                NSIndexPath* indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            }
            
            
            
        }];
        
        UIAlertAction* delete=[UIAlertAction actionWithTitle:@"删除该项" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            //删除数据库中的数据
            
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            
            NSString* sql_delete=@"delete from table_info where account=(?) ";
            [db executeUpdate:sql_delete withArgumentsInArray:@[self.titleArray[section]]];
            [db close];
            
            //刷新界面
            [self.tableView beginUpdates];
            [self.titleArray removeObjectAtIndex:section];
            [self.dataPublicArray removeObjectAtIndex:section];
            [self.dataPrivateArray removeObjectAtIndex:section];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationBottom];
            
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            
            
        }];
        
        UIAlertAction* cancel=[UIAlertAction actionWithTitle:@"取消编辑" style:UIAlertActionStyleDefault handler:nil];
        
        NSString* message=[NSString stringWithFormat:@"您正在操作%@",self.titleArray[section]];
        
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:modify];
        [alert addAction:delete];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)addData{
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"添加信息" message:@"您可以添加邮箱、账号等信息" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"填写您的账户或信息类型";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"填写您的信息内容、密码等";
    }];
    
    UITextField* first=[alert.textFields objectAtIndex:0];
    UITextField* second=[alert.textFields objectAtIndex:1];
    
    UIAlertAction*  publicAdd=[UIAlertAction actionWithTitle:@"明文添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([first.text isEqualToString:@""]||[second.text isEqualToString:@""]) {
            [SStool alertWithController:self Title:@"提示" info:@"填写的内容不能为空哦" btnTitle:@"知道啦"];
        }else{
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            //添加数据到数据库
            NSString* sql_add=@"insert into table_info (account,password,isprivate) values (?,?,1)";
            [db executeUpdate:sql_add withArgumentsInArray:@[first.text,second.text]];
            [db close];
            //刷新界面
            [self.tableView beginUpdates];
            [self.titleArray addObject:first.text];
            [self.dataPublicArray addObject:second.text];
            [self.dataPrivateArray addObject:second.text];
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:(self.titleArray.count-1)] withRowAnimation:UITableViewRowAnimationBottom];
            
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:0 inSection:(self.dataPrivateArray.count-1)];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
        }
        
        }];
    UIAlertAction*  privateAdd=[UIAlertAction actionWithTitle:@"暗文添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([first.text isEqualToString:@""]||[second.text isEqualToString:@""]) {
            [SStool alertWithController:self Title:@"提示" info:@"填写的内容不能为空哦" btnTitle:@"知道啦"];
        }else{
            FMDatabase* db=[FMDatabase databaseWithPath:[SStool dbPathWithdbName:@"chuang.db"]];
            
            if (![db open]) {
                return;
            }
            //添加数据到数据库
            NSString* sql_add=@"insert into table_info (account,password,isprivate) values (?,?,0)";
            [db executeUpdate:sql_add withArgumentsInArray:@[first.text,second.text]];
            [db close];
            //刷新界面
            [self.tableView beginUpdates];
            [self.titleArray addObject:first.text];
            [self.dataPublicArray addObject:second.text];
            [self.dataPrivateArray addObject:@"**********"];
            NSIndexPath* indexPath=[NSIndexPath indexPathForRow:0 inSection:(self.dataPublicArray.count-1)];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:(self.titleArray.count-1)] withRowAnimation:UITableViewRowAnimationBottom];
            [self.tableView endUpdates];
            
        }

    }];
    UIAlertAction*  cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:publicAdd];
    [alert addAction:privateAdd];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}




@end
