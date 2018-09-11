//
//  DialogViewController.h
//  EyeControl
//
//  Created by Celleus on 2018/08/10.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomViewController;

@interface DialogViewController : UIViewController {
    double blinkDateDouble;
}

@property (nonatomic) CustomViewController *viewController;

@end
