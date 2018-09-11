//
//  Scaffold.m
//  RunAction
//
//  Created by Celleus on 2014/06/17.
//  Copyright (c) 2014年 RunAction. All rights reserved.
//

#import "Scaffold.h"

@implementation Scaffold

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.flag = YES;
        self.down = NO;
        self.score = NO;
    }
    return self;
}

@end
