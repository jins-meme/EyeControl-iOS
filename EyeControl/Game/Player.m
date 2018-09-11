//
//  Player.m
//  Circle
//
//  Created by Celleus on 2014/06/11.
//  Copyright (c) 2014年 Circle. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.speedX = 4;
        self.speedY = 4;
        
        self.speedVX = 0;
        self.speedVY = 0;
        
        self.jumpPow = 2;
        self.jumpCountMax = 1;
        self.jumpCount = self.jumpCountMax;
        
        self.flag = YES;
    }
    return self;
}


@end
