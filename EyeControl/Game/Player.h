//
//  Player.h
//  Circle
//
//  Created by Celleus on 2014/06/11.
//  Copyright (c) 2014年 Circle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Player : UIView

@property (readwrite) CGFloat speedX;
@property (readwrite) CGFloat speedY;

@property (readwrite) CGFloat speedVX;
@property (readwrite) CGFloat speedVY;

@property (readwrite) CGFloat jumpPow;
@property (readwrite) CGFloat jumpCountMax;
@property (readwrite) CGFloat jumpCount;

@property (readwrite) BOOL flag;

@end
