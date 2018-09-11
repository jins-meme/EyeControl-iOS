//
//  EyeMoveManager.h
//  JINS
//
//  Created by Celleus on 2016/12/27.
//  Copyright © 2016年 Celleus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    EyeMoveManagerDirectionUp         = 0,
    EyeMoveManagerDirectionRight      = 1,
    EyeMoveManagerDirectionDown       = 2,
    EyeMoveManagerDirectionLeft       = 3,
} EyeMoveManagerDirection;


@protocol EyeMoveManagerDelegate <NSObject>

- (void)didPeakEyeMove:(EyeMoveManagerDirection)direction count:(int)count eyeMove:(int)eyeMove;

@end

@interface EyeMoveManager : NSObject

+ (EyeMoveManager *)sharedInstance;

@property (nonatomic,weak) id <EyeMoveManagerDelegate> delegate;

@property (nonatomic) float timeDifRL;
@property (nonatomic) float timeDifUD;

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data;

@end
