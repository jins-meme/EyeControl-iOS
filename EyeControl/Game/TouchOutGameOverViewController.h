//
//  TouchOutGameOverViewController.h
//  EyeControl
//
//  Created by Celleus on 2018/08/17.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "CustomViewController.h"

@class TouchOutGameViewController;

@interface TouchOutGameOverViewController : CustomViewController

@property (nonatomic) TouchOutGameViewController *touchOutGameViewController;

@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *highScore;

@end
