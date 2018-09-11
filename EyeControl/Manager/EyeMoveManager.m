//
//  EyeMoveManager.m
//  JINS
//
//  Created by Celleus on 2016/12/27.
//  Copyright © 2016年 Celleus. All rights reserved.
//

#import "EyeMoveManager.h"

@implementation EyeMoveManager {
    long index;
    
    int rl_ep;
    NSMutableArray *d1ma3RL;
    NSMutableArray *datasRL;
    NSMutableArray *datasRLPeak;
    int ud_ep;
    NSMutableArray *d1ma3UD;
    NSMutableArray *datasUD;
    NSMutableArray *datasUDPeak;
}

static EyeMoveManager *sharedInstance_ = nil;

+ (EyeMoveManager *)sharedInstance {
    if (!sharedInstance_) {
        
        sharedInstance_  = [[EyeMoveManager alloc] init];;
        
    }
    return sharedInstance_;
}

- (id)init {
    self = [super init];
    
    if (self) {
        
        index = 0;
        
        // 左右
        rl_ep = 0;
        
        d1ma3RL = [[NSMutableArray alloc] init];
        [d1ma3RL addObject:[NSNumber numberWithFloat:0]];
        
        datasRL = [[NSMutableArray alloc] init];
        NSMutableDictionary *dicRL = [[NSMutableDictionary alloc] init];
        double unixtime = [[NSDate date] timeIntervalSince1970] - 1.0;
        [dicRL setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];
        [dicRL setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
        [dicRL setObject:[NSNumber numberWithInt:0] forKey:@"count"];
        [dicRL setObject:[NSNumber numberWithInt:0] forKey:@"sign"];
        [dicRL setObject:[NSNumber numberWithInt:0] forKey:@"id"];
        [dicRL setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        [dicRL setObject:[NSNumber numberWithInt:0] forKey:@"eyeMove"];
        [datasRL addObject:dicRL];
        
        datasRLPeak = [[NSMutableArray alloc] init];
        
        _timeDifRL = [[Common getUserDefaultsForKey:TIME_DIF_EYE_MOVE] floatValue];
        
        // 上下
        ud_ep = 0;
        
        d1ma3UD = [[NSMutableArray alloc] init];
        [d1ma3UD addObject:[NSNumber numberWithFloat:0]];
        
        datasUD = [[NSMutableArray alloc] init];
        NSMutableDictionary *dicUD = [[NSMutableDictionary alloc] init];
        double unixtime_ = [[NSDate date] timeIntervalSince1970] - 1.0;
        [dicUD setObject:[NSNumber numberWithDouble:unixtime_] forKey:@"date"];
        [dicUD setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
        [dicUD setObject:[NSNumber numberWithInt:0] forKey:@"count"];
        [dicUD setObject:[NSNumber numberWithInt:0] forKey:@"sign"];
        [dicUD setObject:[NSNumber numberWithInt:0] forKey:@"id"];
        [dicUD setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
        [dicUD setObject:[NSNumber numberWithInt:0] forKey:@"eyeMove"];
        [datasUD addObject:dicUD];
        
        datasUDPeak = [[NSMutableArray alloc] init];
        
        _timeDifUD = [[Common getUserDefaultsForKey:TIME_DIF_EYE_MOVE] floatValue];
    }
    
    return self;
}

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    
    // 左右
    if (data.eyeMoveLeft || data.eyeMoveRight) {
        rl_ep++;
        
        int d1ma3 = 0;
        if (data.eyeMoveLeft) {
            d1ma3 = -data.eyeMoveLeft;
        }
        else if (data.eyeMoveRight) {
            d1ma3 = data.eyeMoveRight;
        }
        
        [d1ma3RL insertObject:[NSNumber numberWithInt:(int)d1ma3] atIndex:0];
        if ([d1ma3RL count] > 2) {
            [d1ma3RL removeObjectAtIndex:2];
        }
        
        NSMutableDictionary *last = [datasRL lastObject];
        
        // ピークバッファ
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        int sign = 0;
        if ([d1ma3RL[0] floatValue] >= 0.0) {
            sign = 1;
        }
        else if ([d1ma3RL[0] floatValue] < 0.0) {
            sign = -1;
        }
        
        int sign_ = 0;
        if ([d1ma3RL[1] floatValue] >= 0.0) {
            sign_ = 1;
        }
        else if ([d1ma3RL[1] floatValue] < 0.0) {
            sign_ = -1;
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];
        if (unixtime - unixtime_ <= _timeDifRL && sign != sign_) {
            int count = [last[@"count"] intValue] + 1;
            [dic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
            [dic setObject:[NSNumber numberWithInt:count] forKey:@"count"];
            [dic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [dic setObject:[NSNumber numberWithInt:rl_ep] forKey:@"rl_ep"];
            [dic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
            [dic setObject:last[@"eyeMove"] forKey:@"eyeMove"];
            [dic setObject:[NSNumber numberWithLong:index] forKey:@"id"];
        }
        else {
            [dic setObject:[NSNumber numberWithInt:1] forKey:@"startFlag"];
            [dic setObject:[NSNumber numberWithInt:1] forKey:@"count"];
            [dic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [dic setObject:[NSNumber numberWithInt:rl_ep] forKey:@"rl_ep"];
            [dic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
            [dic setObject:[NSNumber numberWithInt:d1ma3] forKey:@"eyeMove"];
            [dic setObject:[NSNumber numberWithLong:index] forKey:@"id"];
        }
        
        // ピークサマリ
        if ([dic[@"startFlag"] intValue] == 1
            && unixtime - unixtime_ <= _timeDifRL
            && [last[@"summaryFlag"] intValue] == 0) {
            
            // ピークサマリーに追加
            [datasRLPeak addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール
            [self operationRL:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [datasRL count]-1; i++) {
                [removeArray addObject:datasRL[i]];
            }
            [datasRL removeObjectsInArray:removeArray];
        }
        
        [datasRL addObject:dic];
    }
    else {
        
        NSMutableDictionary *last = [datasRL lastObject];
        
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        if (unixtime - unixtime_ > _timeDifRL
            && [last[@"summaryFlag"] intValue] == 0) {
            // ピークサマリーに追加
            [datasRLPeak addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール
            [self operationRL:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [datasRL count]-1; i++) {
                [removeArray addObject:datasRL[i]];
            }
            [datasRL removeObjectsInArray:removeArray];
        }
    }
    
    // 上下
    if (data.eyeMoveUp || data.eyeMoveDown) {
        ud_ep++;
        
        int d1ma3 = 0;
        if (data.eyeMoveDown) {
            d1ma3 = -data.eyeMoveDown;
        }
        else if (data.eyeMoveUp) {
            d1ma3 = data.eyeMoveUp;
        }
        
        [d1ma3UD insertObject:[NSNumber numberWithInt:(int)d1ma3] atIndex:0];
        if ([d1ma3UD count] > 2) {
            [d1ma3UD removeObjectAtIndex:2];
        }
        
        NSMutableDictionary *last = [datasUD lastObject];
        
        // ピークバッファ
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        
        int sign = 0;
        if ([d1ma3UD[0] floatValue] >= 0.0) {
            sign = 1;
        }
        else if ([d1ma3UD[0] floatValue] < 0.0) {
            sign = -1;
        }
        
        int sign_ = 0;
        if ([d1ma3UD[1] floatValue] >= 0.0) {
            sign_ = 1;
        }
        else if ([d1ma3UD[1] floatValue] < 0.0) {
            sign_ = -1;
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithDouble:unixtime] forKey:@"date"];
        if (unixtime - unixtime_ <= _timeDifUD && sign != sign_) {
            int count = [last[@"count"] intValue] + 1;
            [dic setObject:[NSNumber numberWithInt:0] forKey:@"startFlag"];
            [dic setObject:[NSNumber numberWithInt:count] forKey:@"count"];
            [dic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [dic setObject:[NSNumber numberWithInt:ud_ep] forKey:@"ud_ep"];
            [dic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
            [dic setObject:last[@"eyeMove"] forKey:@"eyeMove"];
            [dic setObject:[NSNumber numberWithLong:index] forKey:@"id"];
        }
        else {
            [dic setObject:[NSNumber numberWithInt:1] forKey:@"startFlag"];
            [dic setObject:[NSNumber numberWithInt:1] forKey:@"count"];
            [dic setObject:[NSNumber numberWithInt:sign] forKey:@"sign"];
            [dic setObject:[NSNumber numberWithInt:ud_ep] forKey:@"ud_ep"];
            [dic setObject:[NSNumber numberWithInt:0] forKey:@"summaryFlag"];
            [dic setObject:[NSNumber numberWithInt:d1ma3] forKey:@"eyeMove"];
            [dic setObject:[NSNumber numberWithLong:index] forKey:@"id"];
        }
        
        // ピークサマリ
        if ([dic[@"startFlag"] intValue] == 1
            && unixtime - unixtime_ <= _timeDifUD
            && [last[@"summaryFlag"] intValue] == 0) {
            
            // ピークサマリーに追加
            [datasRLPeak addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール
            [self operationUD:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [datasUD count]-1; i++) {
                [removeArray addObject:datasUD[i]];
            }
            [datasUD removeObjectsInArray:removeArray];
        }
        
        [datasUD addObject:dic];
    }
    else {
        
        NSMutableDictionary *last = [datasUD lastObject];
        
        double unixtime = [[NSDate date] timeIntervalSince1970];
        double unixtime_ = [last[@"date"] doubleValue];
        
        if (unixtime - unixtime_ > _timeDifUD
            && [last[@"summaryFlag"] intValue] == 0) {
            // ピークサマリーに追加
            [datasUDPeak addObject:last];
            [last setObject:[NSNumber numberWithInt:1] forKey:@"summaryFlag"];
            
            // コントロール
            [self operationUD:last];
            
            // ピークサマリーにれたのでピークの余分な行を消す
            NSMutableArray *removeArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [datasUD count]-1; i++) {
                [removeArray addObject:datasUD[i]];
            }
            [datasUD removeObjectsInArray:removeArray];
        }
    }
    
    index++;
}

- (void)operationRL:(NSMutableDictionary *)last {
    //DLog(@"operationRL");
    
    int sing = [last[@"sign"] intValue];
    int count = [last[@"count"] intValue];
    int eyeMove = [last[@"eyeMove"] intValue];
    
    if (count % 2 == 0) {
        sing = sing * 1;
    }
    else if (count % 2 == 1) {
        sing = sing * -1;
    }
    
    int direction;
    if (sing > 0) {
        direction = EyeMoveManagerDirectionRight;
    }
    else {
        direction = EyeMoveManagerDirectionLeft;
    }
    
    if ([self.delegate respondsToSelector:@selector(didPeakEyeMove:count:eyeMove:)]) {
        [self.delegate didPeakEyeMove:direction count:count eyeMove:eyeMove];
    }
    
    // 削除
    if ([datasRLPeak count] > 10) {
        [datasRLPeak removeObject:[datasRLPeak firstObject]];
    }
}

- (void)operationUD:(NSMutableDictionary *)last {
    //DLog(@"operationUD");
    
    int sing = [last[@"sign"] intValue];
    int count = [last[@"count"] intValue];
    int eyeMove = [last[@"eyeMove"] intValue];
    
    if (count % 2 == 0) {
        sing = sing * 1;
    }
    else if (count % 2 == 1) {
        sing = sing * -1;
    }
    
    int direction;
    if (sing > 0) {
        direction = EyeMoveManagerDirectionUp;
    }
    else {
        direction = EyeMoveManagerDirectionDown;
    }
    
    if ([self.delegate respondsToSelector:@selector(didPeakEyeMove:count:eyeMove:)]) {
        [self.delegate didPeakEyeMove:direction count:count eyeMove:eyeMove];
    }
    
    // 削除
    if ([datasUDPeak count] > 10) {
        [datasUDPeak removeObject:[datasUDPeak firstObject]];
    }
}

@end
