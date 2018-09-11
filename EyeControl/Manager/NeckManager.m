//
//  NeckManager.m
//  JINS
//
//  Created by Celleus on 2017/01/13.
//  Copyright © 2017年 Celleus. All rights reserved.
//

#import "NeckManager.h"

@implementation NeckManager {
    NSMutableArray *datas;
    
    // 左右
    float p_yawd1_th;
    int yaw_ep;
    NSMutableArray *yawd1ma3Peak;
    NSMutableArray *yawPeak;
    NSMutableArray *yawPeakSummary;
    
    // 上下
    float p_pitchd1_th;
    int pitch_ep;
    NSMutableArray *pitchd1ma3Peak;
    NSMutableArray *pitchPeak;
    NSMutableArray *pitchPeakSummary;
}

static NeckManager *sharedInstance_ = nil;

+ (NeckManager *)sharedInstance {
    if (!sharedInstance_) {
        
        sharedInstance_  = [[NeckManager alloc] init];;
        
    }
    return sharedInstance_;
}

- (id)init {
    self = [super init];
    
    if (self) {
        
        datas = [[NSMutableArray alloc] init];
        
        // 左右
        p_yawd1_th = 2.6;
        yaw_ep = 0;
        
        yawd1ma3Peak = [[NSMutableArray alloc] init];
        [yawd1ma3Peak addObject:[NSNumber numberWithFloat:0]];
        
        yawPeak = [[NSMutableArray alloc] init];
        NSMutableDictionary *yawPeakDic = [[NSMutableDictionary alloc] init];
        double unixtime = [[NSDate date] timeIntervalSince1970] - 1.0;
        [yawPeakDic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];
        [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
        [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"count"];
        [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"sign"];
        [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"id"];
        [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        [yawPeak addObject:yawPeakDic];
        
        yawPeakSummary = [[NSMutableArray alloc] init];
        
        _yawPeackTimeDif = [[Common getUserDefaultsForKey:TIME_DIF_NECK] floatValue];
        
        // 上下
        p_pitchd1_th = 1.0;
        pitch_ep = 0;
        
        pitchd1ma3Peak = [[NSMutableArray alloc] init];
        [pitchd1ma3Peak addObject:[NSNumber numberWithFloat:0]];
        
        pitchPeak = [[NSMutableArray alloc] init];
        NSMutableDictionary *pitchPeakDic = [[NSMutableDictionary alloc] init];
        [pitchPeakDic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];
        [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
        [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"count"];
        [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"sign"];
        [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"id"];
        [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        [pitchPeak addObject:pitchPeakDic];
        
        pitchPeakSummary = [[NSMutableArray alloc] init];
        
        _pitchPeackTimeDif = [[Common getUserDefaultsForKey:TIME_DIF_NECK] floatValue];
    }
    
    return self;
}

// リセット
- (void)reset {
    DLog(@"reset");
    
    [datas removeAllObjects];
    
    // 左右
    yaw_ep = 0;
    
    [yawd1ma3Peak removeAllObjects];
    [yawd1ma3Peak addObject:[NSNumber numberWithFloat:0]];
    
    [yawPeak removeAllObjects];
    NSMutableDictionary *yawPeakDic = [[NSMutableDictionary alloc] init];
    double unixtime = [[NSDate date] timeIntervalSince1970] - 1.0;
    [yawPeakDic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];
    [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
    [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"count"];
    [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"sign"];
    [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"id"];
    [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
    [yawPeak addObject:yawPeakDic];
    
    [yawPeakSummary removeAllObjects];
    
    // 上下
    pitch_ep = 0;
    
    [pitchd1ma3Peak removeAllObjects];
    [pitchd1ma3Peak addObject:[NSNumber numberWithFloat:0]];
    
    [pitchPeak removeAllObjects];
    NSMutableDictionary *pitchPeakDic = [[NSMutableDictionary alloc] init];
    [pitchPeakDic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];
    [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
    [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"count"];
    [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"sign"];
    [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"id"];
    [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
    [pitchPeak addObject:pitchPeakDic];
    
    [pitchPeakSummary removeAllObjects];
}

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    
    [datas addObject:data];
    
    if ([datas count] > 4) {
        
        [self yawCheck];
        [self pitchCheck];
        
        [datas removeObject:[datas firstObject]];
    }
}

- (void)yawCheck {

    // 左右
    // 0
    NSMutableArray *yaw = [[NSMutableArray alloc] init];
    for (MEMERealTimeData *rtd in datas) {
        [yaw addObject:[NSNumber numberWithFloat:rtd.yaw]];
    }
//    DLog(@"yaw:%@",yaw);
    
    NSMutableArray *yawm1 = [[NSMutableArray alloc] init];
    
    // 2
    [yawm1 addObject:yaw[0]];
    
    // 1
    for (int i = 1; i < [yaw count]; i++) {
        [yawm1 addObject:yaw[i-1]];
    }
//    DLog(@"yawm1:%@",yawm1);
    
    // 3
    NSMutableArray *yaw2 = [[NSMutableArray alloc] init];
    int rotetions = 0;
    for (int i = 0; i < [yaw count]; i++) {
        
        if (fabs([yaw[i] floatValue] - [yawm1[i] floatValue]) > 300) {
            if ([yaw[i] floatValue] - [yawm1[i] floatValue] > 0) {
                rotetions = rotetions - 1;
            }
            else {
                rotetions = rotetions + 1;
            }
        }
        
        [yaw2 addObject:[NSNumber numberWithFloat:rotetions * 360 + [yaw[i] floatValue]]];
    }
//    DLog(@"yaw2:%@",yaw2);
    
    // 5
    NSMutableArray *yawd1ma3 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [yawd1ma3 addObject:[NSNumber numberWithFloat:( ([yaw2[i] floatValue] - [yaw2[i+1] floatValue]) + ([yaw2[i+1] floatValue] - [yaw2[i+2] floatValue]) + ([yaw2[i+2] floatValue] - [yaw2[i+3] floatValue]) ) / 3.0]];
    }
//    DLog(@"yawd1ma3:%@",yawd1ma3);
    
    
    // 6
    NSMutableArray *yaw_io = [[NSMutableArray alloc] init];
    int count = 0;
    for (NSNumber *number in yawd1ma3) {
        if ( fabs([number floatValue]) > p_yawd1_th) {
            [yaw_io insertObject:[NSNumber numberWithInt:1] atIndex:count];
        }
        else {
            [yaw_io insertObject:[NSNumber numberWithInt:0] atIndex:count];
        }
        count++;
    }
//    DLog(@"yaw_io:%@",yaw_io);
    
    int sign = 0;
    if ([yawd1ma3[0] floatValue] >= 0.0) {
        sign = 1;
    }
    else if ([yawd1ma3[0] floatValue] < 0.0) {
        sign = -1;
    }
    
    int sign_ = 0;
    if ([yawd1ma3[1] floatValue] >= 0.0) {
        sign_ = 1;
    }
    else if ([yawd1ma3[1] floatValue] < 0.0) {
        sign_ = -1;
    }
    
    //7.カウンターyaw_epを作る
    if (([yaw_io[0] intValue] == 1 && [yaw_io[1] intValue] == 0)
        ||
        ([yaw_io[0] intValue] == 1 && [yaw_io[1] intValue] == 1 && sign != sign_)) {
        yaw_ep++;
        
        [yawd1ma3Peak insertObject:yawd1ma3[0] atIndex:0];
        if ([yawd1ma3Peak count] > 2) {
            [yawd1ma3Peak removeObject:[yawd1ma3Peak lastObject]];
        }
        
        NSMutableDictionary *last = [yawPeak lastObject];
        
        // ピークバッファ
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        int sign = 0;
        if ([yawd1ma3Peak[0] floatValue] >= 0.0) {
            sign = 1;
        }
        else if ([yawd1ma3Peak[0] floatValue] < 0.0) {
            sign = -1;
        }
        
        // 片道のピーク ---
        int direction;
        if (sign > 0) {
            direction = NeckManagerDirectionLeft;
        }
        else {
            direction = NeckManagerDirectionRight;
        }
        if ([self.delegate respondsToSelector:@selector(peakNeck:)]) {
            [self.delegate peakNeck:direction];
        }
        //  ---
        
        int sign_ = 0;
        if ([yawd1ma3Peak[1] floatValue] >= 0.0) {
            sign_ = 1;
        }
        else if ([yawd1ma3Peak[1] floatValue] < 0.0) {
            sign_ = -1;
        }
        
        NSMutableDictionary *yawPeakDic = [[NSMutableDictionary alloc] init];
        [yawPeakDic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];

        if (unixtime - unixtime_ <= _yawPeackTimeDif && sign != sign_) {
            int count = [last[@"count"] intValue] + 1;
            [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
            [yawPeakDic setObject:[NSNumber numberWithInt:count] forKey:@"count"];
            [yawPeakDic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [yawPeakDic setObject:[NSNumber numberWithInt:yaw_ep] forKey:@"id"];
            [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        }
        else {
            [yawPeakDic setObject:[NSNumber numberWithInt:1] forKey:@"startFlag"];
            [yawPeakDic setObject:[NSNumber numberWithInt:1] forKey:@"count"];
            [yawPeakDic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [yawPeakDic setObject:[NSNumber numberWithInt:yaw_ep] forKey:@"id"];
            [yawPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        }
        
        // ピークサマリ
        if ([yawPeakDic[@"startFlag"] intValue] == 1
            && unixtime - unixtime_ <= _yawPeackTimeDif
            && [last[@"summaryFlag"] intValue] == 0) {
            
            // ピークサマリーに追加
            [yawPeakSummary addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール
            [self operationRL:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [yawPeak count]-1; i++) {
                [removeArray addObject:yawPeak[i]];
            }
            [yawPeak removeObjectsInArray:removeArray];
        }
        
        [yawPeak addObject:yawPeakDic];
    }
    else {
        
        NSMutableDictionary *last = [yawPeak lastObject];
        
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        if (unixtime - unixtime_ > _yawPeackTimeDif
            && [last[@"summaryFlag"] intValue] == 0) {
            // ピークサマリーに追加
            [yawPeakSummary addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール
            [self operationRL:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [yawPeak count]-1; i++) {
                [removeArray addObject:yawPeak[i]];
            }
            [yawPeak removeObjectsInArray:removeArray];
        }
    }
}

- (void)pitchCheck {
    // 上下
    // 0
    NSMutableArray *pitch = [[NSMutableArray alloc] init];
    for (MEMERealTimeData *rtd in datas) {
        [pitch addObject:[NSNumber numberWithFloat:rtd.pitch]];
    }
    
    // 2
    NSMutableArray *pitch1 = [[NSMutableArray alloc] init];
    [pitch1 addObject:pitch[0]];
    
    // 1
    for (int i = 1; i < [pitch count]; i++) {
        [pitch1 addObject:pitch[i-1]];
    }
    //DLog(@"yawm1:%@",yawm1);
    
    // 3
    NSMutableArray *pitch2 = [[NSMutableArray alloc] init];
    int rotetions = 0;
    for (int i = 0; i < [pitch count]; i++) {
        
        if (fabs([pitch[i] floatValue] - [pitch1[i] floatValue]) > 300) {
            if ([pitch[i] floatValue] - [pitch1[i] floatValue] > 0) {
                rotetions = rotetions - 1;
            }
            else {
                rotetions = rotetions + 1;
            }
        }
        
        [pitch2 addObject:[NSNumber numberWithFloat:rotetions * 360 + [pitch[i] floatValue]]];
    }
    //DLog(@"yaw2:%@",yaw2);
    
    // 5
    NSMutableArray *pitchd1ma3 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [pitchd1ma3 addObject:[NSNumber numberWithFloat:( ([pitch2[i] floatValue] - [pitch2[i+1] floatValue]) + ([pitch2[i+1] floatValue] - [pitch2[i+2] floatValue]) + ([pitch2[i+2] floatValue] - [pitch2[i+3] floatValue]) ) / 3.0]];
    }
    //DLog(@"yawd1ma3:%@",yawd1ma3);
    
    // 6
    NSMutableArray *pitch_io = [[NSMutableArray alloc] init];
    int count = 0;
    for (NSNumber *number in pitchd1ma3) {
        if ( fabs([number floatValue]) > p_yawd1_th) {
            [pitch_io insertObject:[NSNumber numberWithInt:1] atIndex:count];
        }
        else {
            [pitch_io insertObject:[NSNumber numberWithInt:0] atIndex:count];
        }
        count++;
    }
    //DLog(@"yaw_io:%@",yaw_io);
    
    int sign = 0;
    if ([pitchd1ma3[0] floatValue] >= 0.0) {
        sign = 1;
    }
    else if ([pitchd1ma3[0] floatValue] < 0.0) {
        sign = -1;
    }
    
    int sign_ = 0;
    if ([pitchd1ma3[1] floatValue] >= 0.0) {
        sign_ = 1;
    }
    else if ([pitchd1ma3[1] floatValue] < 0.0) {
        sign_ = -1;
    }
    
    //7.カウンターpitch_epを作る
    if (([pitch_io[0] intValue] == 1 && [pitch_io[1] intValue] == 0)
        ||
        ([pitch_io[0] intValue] == 1 && [pitch_io[1] intValue] == 1 && sign != sign_)) {
        pitch_ep++;
        
        [pitchd1ma3Peak insertObject:pitchd1ma3[0] atIndex:0];
        if ([pitchd1ma3Peak count] > 2) {
            [pitchd1ma3Peak removeObject:[pitchd1ma3Peak lastObject]];
        }
        
        NSMutableDictionary *last = [pitchPeak lastObject];
        
        // ピークバッファ
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        int sign = 0;
        if ([pitchd1ma3Peak[0] floatValue] >= 0.0) {
            sign = 1;
        }
        else if ([pitchd1ma3Peak[0] floatValue] < 0.0) {
            sign = -1;
        }
        
        int sign_ = 0;
        if ([pitchd1ma3Peak[1] floatValue] >= 0.0) {
            sign_ = 1;
        }
        else if ([pitchd1ma3Peak[1] floatValue] < 0.0) {
            sign_ = -1;
        }
        
        NSMutableDictionary *pitchPeakDic = [[NSMutableDictionary alloc] init];
        [pitchPeakDic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];

        if (unixtime - unixtime_ <= _yawPeackTimeDif && sign != sign_) {
            int count = [last[@"count"] intValue] + 1;
            [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:count] forKey:@"count"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:yaw_ep] forKey:@"id"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        }
        else {
            [pitchPeakDic setObject:[NSNumber numberWithInt:1] forKey:@"startFlag"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:1] forKey:@"count"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:yaw_ep] forKey:@"id"];
            [pitchPeakDic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        }
        
        // ピークサマリ
        if ([pitchPeakDic[@"startFlag"] intValue] == 1
            && unixtime - unixtime_ <= _pitchPeackTimeDif
            && [last[@"summaryFlag"] intValue] == 0) {
            
            // ピークサマリーに追加
            [pitchPeakSummary addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール（結果）
            [self operationUD:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [pitchPeak count]-1; i++) {
                [removeArray addObject:pitchPeak[i]];
            }
            [pitchPeak removeObjectsInArray:removeArray];
        }
        
        [pitchPeak addObject:pitchPeakDic];
    }
    else {
        
        NSMutableDictionary *last = [pitchPeak lastObject];
        
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        if (unixtime - unixtime_ > _pitchPeackTimeDif
            && [last[@"summaryFlag"] intValue] == 0) {
            // ピークサマリーに追加
            [pitchPeakSummary addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール（結果）
            [self operationUD:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [pitchPeak count]-1; i++) {
                [removeArray addObject:pitchPeak[i]];
            }
            [pitchPeak removeObjectsInArray:removeArray];
        }
    }
}


- (void)operationRL:(NSMutableDictionary *)last {
    //DLog(@"operationRL");
    
    int sing = [last[@"sign"] intValue];
    int count = [last[@"count"] intValue];
    
    if (count % 2 == 0) {
        sing = sing * 1;
    }
    else if (count % 2 == 1) {
        sing = sing * -1;
    }
    
    int direction;
    if (sing > 0) {
        direction = NeckManagerDirectionRight;
    }
    else {
        direction =NeckManagerDirectionLeft;
    }
    
    if ([self.delegate respondsToSelector:@selector(didPeakNeck:count:)]) {
        [self.delegate didPeakNeck:direction count:count];
    }
    
    // 削除
    if ([yawPeakSummary count] > 10) {
        [yawPeakSummary removeObject:[yawPeakSummary firstObject]];
    }
}

- (void)operationUD:(NSMutableDictionary *)last {
    //DLog(@"operationUD");
    
    int sing = [last[@"sign"] intValue];
    int count = [last[@"count"] intValue];
    
    if (count % 2 == 0) {
        sing = sing * 1;
    }
    else if (count % 2 == 1) {
        sing = sing * -1;
    }
    
    int direction;
    if (sing > 0) {
        direction = NeckManagerDirectionDown;
    }
    else {
        direction = NeckManagerDirectionUp;
    }
    
    if ([self.delegate respondsToSelector:@selector(didPeakNeck:count:)]) {
        [self.delegate didPeakNeck:direction count:count];
    }
    
    // 削除
    if ([pitchPeakSummary count] > 10) {
        [pitchPeakSummary removeObject:[pitchPeakSummary firstObject]];
    }
}

@end
