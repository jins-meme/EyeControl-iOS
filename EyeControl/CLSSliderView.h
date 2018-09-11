//
//  CLSSliderView.h
//  CLS
//
//  Created by Celleus on 2015/11/05.
//  Copyright © 2015年 Celleus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSSliderView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *valueLabel;

@property (nonatomic) CGFloat margin;
@property (nonatomic) CGFloat titleLabelSize;
@property (nonatomic) CGFloat valueLabelSize;

@end
