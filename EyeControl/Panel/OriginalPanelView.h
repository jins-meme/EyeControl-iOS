//
//  OriginalPanelView.h
//  EyeControl
//
//  Created by Celleus on 2017/08/22.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "PanelView.h"

@interface OriginalPanelView : PanelView

@property (nonatomic) NSString *udfKey;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate udfKey:(NSString *)udfKey;

@end
