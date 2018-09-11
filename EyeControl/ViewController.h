//
//  ViewController.h
//  EyeControl
//
//  Created by Celleus on 2017/08/08.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "CustomViewController.h"

@interface ViewController : CustomViewController

@property (nonatomic) UITabBarController *tabBarController;

- (void)controlDialog;

- (void)pdf:(NSURL *)url;

@end

