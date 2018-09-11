//
//  OriginalPanelView.m
//  EyeControl
//
//  Created by Celleus on 2017/08/22.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "OriginalPanelView.h"

@implementation OriginalPanelView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate udfKey:(NSString *)udfKey {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.udfKey = udfKey;
        
        self.buttonArray = [[NSMutableArray alloc] init];
        self.buttonTitleArray = [Common getUserDefaultsForKey:self.udfKey];
        
        CGFloat margin = 10;
        
        // タイル
        for (int i = 0; i < [self.buttonTitleArray count]; i++) {
            
            CGFloat sizeW = (self.frame.size.width - margin*([self.buttonTitleArray[i] count]+1)) / [self.buttonTitleArray[i] count];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < [self.buttonTitleArray[i] count]; j++) {
                
                CGFloat sizeH = (self.frame.size.height - margin*([self.buttonTitleArray count]+1)) / [self.buttonTitleArray count];
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin + (sizeW + margin) * j,
                                                                              margin + (sizeH + margin) * i,
                                                                              sizeW,
                                                                              sizeH)];
                button.titleLabel.numberOfLines = 3;
                [button setTitle:self.buttonTitleArray[i][j] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addTarget:delegate action:@selector(changeButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
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
