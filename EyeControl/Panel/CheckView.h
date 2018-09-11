//
//  CheckView.h
//  EyeControl
//
//  Created by Celleus on 2018/08/17.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckView : UIView {
    NSTimer *leftTimer1;
    NSTimer *leftTimer2;
    NSTimer *leftTimer3;
    NSTimer *blinkTimer;
    NSTimer *rightTimer1;
    NSTimer *rightTimer2;
    NSTimer *rightTimer3;
}

@property (nonatomic) UIView *left1;
@property (nonatomic) UIView *left2;
@property (nonatomic) UIView *left3;
@property (nonatomic) UIView *blink;
@property (nonatomic) UIView *right1;
@property (nonatomic) UIView *right2;
@property (nonatomic) UIView *right3;

- (void)setCheckHighlight:(UIView *)view;

@end
