//
//  CustomViewController.h
//  EyeControl
//
//  Created by Celleus on 2018/08/03.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DialogViewController.h"

@interface CustomViewController : UIViewController {
    double blinkDateDouble;
    
    CGFloat statusH;
    CGFloat naviH;
    CGFloat safeAreaTop;
    CGFloat safeAreaBottom;
}

- (void)pop;
- (void)pairingCheck;
- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data;

@end
