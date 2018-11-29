//
//  DatabaseTool.m
//  welfare
//
//  Created by PC-wzj on 2018/11/26.
//  Copyright © 2018 PC-wzj. All rights reserved.
//

#import "DatabaseTool.h"

@interface DatabaseTool ()
@property (nonatomic, strong) FMDatabase *database;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation DatabaseTool

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSString *temp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path =[NSString stringWithFormat:@"%@/data.sqlite", temp];
        
        //        NSLog(@"path = %@", path);
        //初始化数据库对象
        self.database = [FMDatabase databaseWithPath:path];
        
        //初始化线程锁对象
        self.lock = [[NSLock alloc] init];
        
        //创建表
        [self createDatabase];
        
    }
    return self;
}

- (void) createDatabase {
    
    NSString *sql;
    
    //创建用户表
    sql = @"CREATE TABLE IF NOT EXISTS qxc (id INTEGER PRIMARY KEY AUTOINCREMENT, qxc_number VARCHAR(7))";
    [self updateWithSql:sql];
    
    sql = @"CREATE TABLE IF NOT EXISTS dlt (id INTEGER PRIMARY KEY AUTOINCREMENT, dlt_number VARCHAR(7))";
    [self updateWithSql:sql];
}

//更新数据库表操作方法
- (BOOL)updateWithSql:(NSString *)sql {
    [self.lock lock];
    [self.database open];
    
    BOOL status = [self.database executeUpdate:sql];
    //    NSLog(@"数据库SQL语句： %@", sql);
    NSLog(@"数据库更新 %d", status);
    [self.database close];
    [self.lock unlock];
    return status;
}

/**
 查询操作方法
 
 @param sql 查询语句
 @return 查询结果集
 */
- (FMResultSet *)selectDataWithSql:(NSString *)sql {
    [_lock lock];
    [_database open];
    
    FMResultSet *set = [_database executeQuery:sql];
    
    [_database close];
    [_lock unlock];
    return set;
}

- (BOOL) inspectWelfare:(NSString *)welfare number:(NSString *)number {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@_number = %@", welfare, welfare, number];
    FMResultSet *set = [self selectDataWithSql:sql];
    NSLog(@"%d", [set columnCount]);
    while ([set next]) {
        return YES;
    }
    return NO;
}

@end
