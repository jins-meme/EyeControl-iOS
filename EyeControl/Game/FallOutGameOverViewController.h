//
//  FallOutGameOverViewController.h
//  EyeControl
//
//  Created by Celleus on 2018/08/17.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "CustomViewController.h"

@class FallOutGameViewController;

@interface FallOutGameOverViewController : CustomViewController

@property (nonatomic) FallOutGameViewController *fallOutGameViewController;

@property (nonatomic,strong) NSString *score;
@property (nonatomic,strong) NSString *highScore;

@end
