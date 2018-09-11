//
//  ABCPanelView.m
//  EyeControl
//
//  Created by Celleus on 2017/08/21.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "ABCPanelView.h"

@implementation ABCPanelView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.buttonArray = [[NSMutableArray alloc] init];
        self.buttonTitleArray = @[@[@"A",@"F",@"K",@"P",@"U",@"Z"],
                                  @[@"B",@"G",@"L",@"Q",@"V",@"."],
                                  @[@"C",@"H",@"M",@"R",@"W",@","],
                                  @[@"D",@"I",@"N",@"S",@"X",@" "],
                                  @[@"E",@"J",@"O",@"T",@"Y",@" "]];
        
        CGFloat margin = 10;
        CGFloat sizeW = (self.frame.size.width - margin*7)/6;
        CGFloat sizeH = (self.frame.size.height - margin*6)/5;
        
        // タイル
        for (int i = 0; i < 5; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int j = 0; j < 6; j++) {
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin + (sizeW + margin) * j,
                                                                              margin + (sizeH + margin) * i,
                                                                              sizeW,
                                                                              sizeH)];
                button.titleLabel.numberOfLines = 3;
                [button setTitle:self.buttonTitleArray[i][j] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                //[button addTarget:self action:@selector(changeButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 0;
                [self addSubview:button];
                
                [array addObject:button];
            }
            [self.buttonArray addObject:array];
        }
        
    }
    
    return self;
}

@end
