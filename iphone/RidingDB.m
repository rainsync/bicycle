//
//  RidingDB.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "RidingDB.h"

@implementation RidingDB

-(id)init
{
    // db 생성 및 확인
    NSString *docsDir;
    NSArray *dirPaths;
    
    // documents 디렉토리 확인하기
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // 데이터베이스 파일 경로 구성하기
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"ridings.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &ridingDB) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS RIDINGS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DAY TEXT, TIME TEXT, DISTANCE TEXT, SPEED TEXT, ALTITUDE TEXT, CALORIE TEXT)";
            if (sqlite3_exec(ridingDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(ridingDB);
        }
        else {
             NSLog(@"Failed to open/create database");
        }
    }
    else {
         NSLog(@"already exist db");
    }
    
    return self;
}

- (void)saveRecordingTime:(NSString *)time withDistance:(NSString *)distance withAverageSpeed:(NSString *)speed withAltidude:(NSString *)altitude withCalories:(NSString *)calorie {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    
    [form setDateStyle:NSDateFormatterFullStyle];
    [form setTimeStyle:NSDateFormatterShortStyle];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
    [form setLocale:locale];
    NSLog(@"%@", [form stringFromDate:date]);
    // set Date data
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &ridingDB) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO RIDINGS (day, time, distance, speed, altitude, calorie) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", [form stringFromDate:date], time, distance, speed, altitude, calorie];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(ridingDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Record Added");
        }
        else {
            NSLog(@"Failed to add Record");
        }
        sqlite3_finalize(statement);
        sqlite3_close(ridingDB);
    }

}

- (NSMutableArray *)loadDB {
    NSMutableArray *db = [[NSMutableArray alloc] init];
    
    // db 생성및확인
    NSString *docsDir;
    NSArray *dirPaths;
    
    // documents 디렉토리확인하기
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"ridings.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &ridingDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM ridings ORDER BY id DESC"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(ridingDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] forKey:@"day"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] forKey:@"time"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] forKey:@"distance"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] forKey:@"speed"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] forKey:@"altitude"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] forKey:@"calorie"];
                //NSString *timeField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [db addObject:dic];
                
            }
            NSLog(@"%@",[db[0] objectForKey:@"day"]);
            
        }
        else {
            NSLog(@"Match not found");
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(ridingDB);
    
    return db;
}
@end
