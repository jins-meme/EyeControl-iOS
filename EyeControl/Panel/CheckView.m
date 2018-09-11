//
//  CheckView.m
//  EyeControl
//
//  Created by Celleus on 2018/08/17.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "CheckView.h"

@implementation CheckView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat labelH = 30;
        CGFloat checkH = 40;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                   0,
                                                                   self.frame.size.width - 20*2,
                                                                   labelH)];
        label.text = @"視線移動強度チェック";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [Common colorWithHex:@"#ffffff"];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        CGFloat margin = (self.frame.size.width - checkH*7) / 8;
        
        self.left3 = [[UIView alloc] initWithFrame:CGRectMake(margin + (checkH + margin)*0,
                                                         label.frame.origin.y + label.frame.size.height,
                                                         checkH,
                                                         checkH)];
        self.left3.layer.cornerRadius = checkH/2;
        self.left3.clipsToBounds = YES;
        [self setCheckNomal:self.left3];
        [self addSubview:self.left3];
        
        self.left2 = [[UIView alloc] initWithFrame:CGRectMake(margin + (checkH + margin)*1,
                                                              label.frame.origin.y + label.frame.size.height,
                                                              checkH,
                                                              checkH)];
        self.left2.layer.cornerRadius = checkH/2;
        self.left2.clipsToBounds = YES;
        [self setCheckNomal:self.left2];
        [self addSubview:self.left2];
        
        self.left1 = [[UIView alloc] initWithFrame:CGRectMake(margin + (checkH + margin)*2,
                                                              label.frame.origin.y + label.frame.size.height,
                                                              checkH,
                                                              checkH)];
        self.left1.layer.cornerRadius = checkH/2;
        self.left1.clipsToBounds = YES;
        [self setCheckNomal:self.left1];
        [self addSubview:self.left1];
        
        self.blink = [[UIView alloc] initWithFrame:CGRectMake(margin + (checkH + margin)*3,
                                                              label.frame.origin.y + label.frame.size.height,
                                                              checkH,
                                                              checkH)];
        [self setCheckNomal:self.blink];
        [self addSubview:self.blink];
        
        self.right1 = [[UIView alloc] initWithFrame:CGRectMake(margin + (checkH + margin)*4,
                                                               label.frame.origin.y + label.frame.size.height,
                                                               checkH,
                                                               checkH)];
        self.right1.layer.cornerRadius = checkH/2;
        self.right1.clipsToBounds = YES;
        [self setCheckNomal:self.right1];
        [self addSubview:self.right1];
        
        self.right2 = [[UIView alloc] initWithFrame:CGRectMake(margin + (checkH + margin)*5,
                                                               label.frame.origin.y + label.frame.size.height,
                                                               checkH,
                                                               checkH)];
        self.right2.layer.cornerRadius = checkH/2;
        self.right2.clipsToBounds = YES;
        [self setCheckNomal:self.right2];
        [self addSubview:self.right2];
        
        self.right3 = [[UIView alloc] initWithFrame:CGRectMake(margin + (checkH + margin)*6,
                                                               label.frame.origin.y + label.frame.size.height,
                                                               checkH,
                                                               checkH)];
        self.right3.layer.cornerRadius = checkH/2;
        self.right3.clipsToBounds = YES;
        [self setCheckNomal:self.right3];
        [self addSubview:self.right3];
    }
    
    return self;
}

- (void)setCheckNomal:(UIView *)view {
    view.backgroundColor = [UIColor whiteColor];
}
- (void)setCheckHighlight:(UIView *)view {
    view.backgroundColor = [Common colorWithHex:@"52d0b0"];
    
    if (view == self.left1) {
        if (leftTimer1) {
            [leftTimer1 invalidate];
            leftTimer1 = nil;
        }
        leftTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * timer){
            [self setCheckNomal:self.left1];
        }];
    }
    else if (view == self.left2) {
        if (leftTimer2) {
            [leftTimer2 invalidate];
            leftTimer2 = nil;
        }
        leftTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * timer){
            [self setCheckNomal:self.left2];
        }];
    }
    else if (view == self.left3) {
        if (leftTimer3) {
            [leftTimer3 invalidate];
            leftTimer3 = nil;
        }
        leftTimer3 = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * timer){
            [self setCheckNomal:self.left3];
        }];
    }
    else if (view == self.blink) {
        if (blinkTimer) {
            [blinkTimer invalidate];
            blinkTimer = nil;
        }
        blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 repeats:NO block:^(NSTimer * timer){
            [self setCheckNomal:self.blink];
        }];
    }
    else if (view == self.right1) {
        if (rightTimer1) {
            [rightTimer1 invalidate];
            rightTimer1 = nil;
        }
        rightTimer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * timer){
            [self setCheckNomal:self.right1];
        }];
    }
    else if (view == self.right2) {
        if (rightTimer2) {
            [rightTimer2 invalidate];
            rightTimer2 = nil;
        }
        rightTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * timer){
            [self setCheckNomal:self.right2];
        }];
    }
    else if (view == self.right3) {
        if (rightTimer3) {
            [rightTimer3 invalidate];
            rightTimer3 = nil;
        }
        rightTimer3 = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * timer){
            [self setCheckNomal:self.right3];
        }];
    }
}

@end
