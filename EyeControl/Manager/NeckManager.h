//
//  NeckManager.h
//  JINS
//
//  Created by Celleus on 2017/01/13.
//  Copyright © 2017年 Celleus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NeckManagerDirectionUp         = 0,
    NeckManagerDirectionRight      = 1,
    NeckManagerDirectionDown       = 2,
    NeckManagerDirectionLeft       = 3,
} NeckManagerDirection;

@protocol NeckManagerDelegate <NSObject>

- (void)didPeakNeck:(int)direction count:(int)count;
- (void)peakNeck:(int)direction;

@end

@interface NeckManager : NSObject

+ (NeckManager *)sharedInstance;

@property (nonatomic,weak) id <NeckManagerDelegate> delegate;


@property (nonatomic) float yawPeackTimeDif;
@property (nonatomic) float pitchPeackTimeDif;

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data;

@end
