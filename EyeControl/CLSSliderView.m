//
//  CLSSliderView.m
//  CLS
//
//  Created by Celleus on 2015/11/05.
//  Copyright © 2015年 Celleus. All rights reserved.
//

#import "CLSSliderView.h"

@implementation CLSSliderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.margin = 10;
        self.titleLabelSize = 50;
        self.valueLabelSize = 50;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.margin,
                                                                    self.margin,
                                                                    self.titleLabelSize,
                                                                    frame.size.height - self.margin*2)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        self.titleLabel.font = [UIFont fontWithName:nil size:16];
        self.titleLabel.minimumFontSize = 10.0;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - self.margin - self.valueLabelSize,
                                                                    self.margin,
                                                                    self.valueLabelSize,
                                                                    frame.size.height - self.margin*2)];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        self.valueLabel.font = [UIFont fontWithName:nil size:16];
        self.valueLabel.minimumFontSize = 10.0;
        self.valueLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.valueLabel];
        
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.margin + self.titleLabel.frame.size.width + self.margin,
                                                                 self.margin,
                                                                 frame.size.width - (self.titleLabel.frame.size.width + self.titleLabel.frame.size.width + self.margin*4),
                                                                 frame.size.height - self.margin*2)];
        [self addSubview:self.slider];
    }
    
    return self;
}

- (void)setMargin:(CGFloat)margin {
    _margin = margin;
    [self reSize];
}
- (void)setTitleLabelSize:(CGFloat)titleLabelSize {
    _titleLabelSize = titleLabelSize;
    [self reSize];
}
- (void)setValueLabelSize:(CGFloat)valueLabelSize {
    _valueLabelSize = valueLabelSize;
    [self reSize];
}

- (void)reSize {
    self.titleLabel.frame = CGRectMake(self.margin,
                                       self.margin,
                                       self.titleLabelSize,
                                       self.frame.size.height - self.margin*2);
    
    self.valueLabel.frame = CGRectMake(self.frame.size.width - self.margin - self.valueLabelSize,
                                       self.margin,
                                       self.valueLabelSize,
                                       self.frame.size.height - self.margin*2);
    
    self.slider.frame = CGRectMake(self.margin + self.titleLabel.frame.size.width + self.margin,
                                   self.margin,
                                   self.frame.size.width - (self.titleLabel.frame.size.width + self.valueLabel.frame.size.width + self.margin*4),
                                   self.frame.size.height - self.margin*2);
}

@end
