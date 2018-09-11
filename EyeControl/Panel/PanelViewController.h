//
//  PanelViewController.h
//  EyeControl
//
//  Created by Celleus on 2017/08/21.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "CustomViewController.h"

@interface PanelViewController : CustomViewController

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data;

- (void)firstPanel;
- (void)secondPanel;
- (void)thirdPanel;

- (void)call:(BOOL)boolean;
- (void)clearText;

@end
