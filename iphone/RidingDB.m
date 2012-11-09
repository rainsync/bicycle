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
    //[filemgr removeItemAtPath:databasePath error:nil];
    
    if ([filemgr fileExistsAtPath: databasePath] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &ridingDB) == SQLITE_OK) {
            
            sqlite3_stmt *statement;
            
            statement = [self getSQLStatement:ridingDB WithQuery:@"CREATE TABLE IF NOT EXISTS RIDINGS (ID INTEGER PRIMARY KEY AUTOINCREMENT, DAY TEXT, TIME TEXT, DISTANCE TEXT, SPEED TEXT, CALORIE TEXT)"];


            //sqlite3_exec 와는 다르게 sqlite3_step은 성공시 sqlite_done을 반환 함으로써 성공을 알린다.
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Failed to create table");
            }
            
            sqlite3_finalize(statement);
            
            statement = [self getSQLStatement:ridingDB WithQuery:@"CREATE TABLE IF NOT EXISTS LOCATION (ID INTEGER, LATITUDE REAL, LONGITUDE REAL, ALTITUDE REAL, TIME_STAMP REAL, FOREIGN KEY(ID) REFERENCES RIDINGS (ID))"];
            
            if (sqlite3_step(statement)  != SQLITE_DONE) {
                NSLog(@"Failed to create table");
            }
            
            sqlite3_finalize(statement);
            
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


- (sqlite3_stmt*)getSQLStatement:(sqlite3*)db WithQuery:(NSString*)query{
    sqlite3_stmt *statement;
    const char *str = [query UTF8String];
    int result = sqlite3_prepare_v2(ridingDB, str, -1, &statement, NULL);
    if(result!=0){
        NSLog(@"ERROR %d with query %@", result, query);
        return nil;
    }
    return statement;

}

- (void)saveRecordingTime:(NSString *)time withDistance:(NSString *)distance withAverageSpeed:(NSString *)speed withlocation:(NSMutableArray *)locations withCalories:(NSString *)calorie {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    
    [form setDateStyle:NSDateFormatterFullStyle];
    [form setTimeStyle:NSDateFormatterShortStyle];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
    [form setLocale:locale];
    NSLog(@"%@", [form stringFromDate:date]);
    // set Date data
    
    sqlite3_stmt *statement;
    int result=0;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &ridingDB) == SQLITE_OK) {
        
        statement = [self getSQLStatement:ridingDB WithQuery:[NSString stringWithFormat:@"INSERT INTO RIDINGS (day, time, distance, speed, calorie) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", [form stringFromDate:date], time, distance, speed, calorie]];
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Record Added");
        }
        else {
            NSLog(@"Failed to add Record");
        }
        

        int row_id = sqlite3_last_insert_rowid(ridingDB);
        //(ID INTEGER PRIMARY KEY, LATITUDE REAL, LONGITUDE REAL, ALTITUDE REAL, TIME_STAMP INTEGER, FOREIGN KEY(ID) REFERENCES RIDINGS (ID))
        for (CLLocation * location in locations) {
            sqlite3_stmt *statement2 = [self getSQLStatement:ridingDB WithQuery:[NSString stringWithFormat:@"INSERT INTO LOCATION (ID, LATITUDE, LONGITUDE, ALTITUDE, TIME_STAMP) VALUES (\"%d\", \"%f\", \"%f\", \"%f\", \"%f\")", row_id, location.coordinate.latitude, location.coordinate.longitude, location.altitude, [location.timestamp timeIntervalSince1970]]];
            
            
            int code= sqlite3_step(statement2);
            NSLog(@"code %d %f %f", code, location.coordinate.latitude, location.coordinate.longitude);
            //sqlite3_finalize(statement);
        }

        
        //sqlite3_finalize(statement);
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
        
        statement = [self getSQLStatement:ridingDB WithQuery:[NSString stringWithFormat:@"SELECT * FROM ridings ORDER BY id DESC"]];

        if (statement) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                int riding_id = sqlite3_column_int(statement, 0);
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] forKey:@"day"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)] forKey:@"time"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)] forKey:@"distance"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] forKey:@"speed"];
                [dic setObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] forKey:@"calorie"];
                
                
                //(ID INTEGER PRIMARY KEY, LATITUDE REAL, LONGITUDE REAL, ALTITUDE REAL, TIME_STAMP REAL
                  
                sqlite3_stmt *statement2 =[self getSQLStatement:ridingDB WithQuery:[NSString stringWithFormat:@"SELECT * FROM location WHERE ID=%d ORDER BY TIME_STAMP ASC", riding_id]];
                NSMutableArray * locations = [[NSMutableArray alloc] init];
                while(sqlite3_step(statement2)== SQLITE_ROW){
                    double lat = sqlite3_column_double(statement2, 1);
                    double lng = sqlite3_column_double(statement2, 2);
                    double alti = sqlite3_column_double(statement2, 3);
                    [locations addObject:[[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) altitude:alti horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]]];
                     
                }
                [dic setObject:locations forKey:@"locations"];
                
                //NSString *timeField = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                [db addObject:dic];
                
            }            
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
