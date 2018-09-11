//
//  Enemy.m
//  Game
//
//  Created by Celleus on 2014/08/13.
//  Copyright (c) 2014年 Game. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = frame.size.width / 2;
        self.clipsToBounds = YES;
        self.layer.borderColor = [[Common colorWithHex:@"#ef2880"] CGColor];
        self.layer.borderWidth = 2.0f;
        
        self.flag = YES;
    }
    return self;
}

@end
