//
//  RidingDB.h
//  rainsync
//
//  Created by xorox64 on 12. 11. 5..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface RidingDB : NSObject{
    sqlite3 *ridingDB;
    NSString *databasePath; // db파일 경로
}
- (void)saveRecordingTime:(NSString *)time withDistance:(NSString *)distance withAverageSpeed:(NSString *)speed withAltidude:(NSString *)altitude withCalories:(NSString *)calorie;
- (NSMutableArray *)loadDB;
@end
