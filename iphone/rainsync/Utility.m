//
//  Utility.m
//  rainsync
//
//  Created by xorox64 on 12. 11. 12..
//  Copyright (c) 2012년 rainsync. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+ (float)calculateCalorie:(float)avgSpd {
    float kcalConstant = 0.0f;
    if (avgSpd <=1){
        kcalConstant = 0;
    }
    else if (avgSpd <= 13) {
        kcalConstant = 0.065f;
    }
    else if (avgSpd <= 16) {
        kcalConstant = 0.0783f;
    }
    else if (avgSpd <= 19) {
        kcalConstant = 0.0939f;
    }
    else if (avgSpd <= 22) {
        kcalConstant = 0.113f;
    }
    else if (avgSpd <= 24) {
        kcalConstant = 0.124f;
    }
    else if (avgSpd <= 26) {
        kcalConstant = 0.136f;
    }
    else if (avgSpd <= 27) {
        kcalConstant = 0.149f;
    }
    else if (avgSpd <= 29) {
        kcalConstant = 0.163f;
    }
    else if (avgSpd <= 31) {
        kcalConstant = 0.179f;
    }
    else if (avgSpd <= 32) {
        kcalConstant = 0.196f;
    }
    else if (avgSpd <= 34) {
        kcalConstant = 0.215f;
    }
    else if (avgSpd <= 37) {
        kcalConstant = 0.259f;
    }
    else {  // avgSpeed 40km/h 이상
        kcalConstant = 0.311f;
    }
    
    return kcalConstant;
}

+(NSString*)getStringTime:(double)time
{
    int i_time = (int)time;
    int sec = i_time%60;
    int min = i_time/60%60;
    int hour = i_time/60/60%24;
    
    
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
    
}

+(NSString*)timeToDate:(double)time
{
    
    NSDate *date=[[NSDate alloc] initWithTimeIntervalSince1970:time];

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    return [dateFormatter stringFromDate:date];
}

+(double)metreTokilometre:(double)metre
{
    return metre/1000.0;
    
}

+(double)mpsTokph:(double)mps{
    return mps*3.6;
}

@end
