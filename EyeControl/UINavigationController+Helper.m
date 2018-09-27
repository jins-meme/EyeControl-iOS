//
//  UINavigationController+Helper.m
//  EyeControl
//
//  Created by Celleus on 2018/09/03.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "UINavigationController+Helper.h"

@implementation UINavigationController (Helper)

- (BOOL)shouldAutorotate {
    DLog(@"shouldAutorotate");
    DLog(@"self.viewControllers.lastObject:%@",self.viewControllers.lastObject)
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    DLog(@"willAnimateRotationToInterfaceOrientation interfaceOrientation%ld duration:%f",(long)interfaceOrientation,duration);
    [self.viewControllers.lastObject willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (NSUInteger)supportedInterfaceOrientations {
    DLog(@"supportedInterfaceOrientations");
    return  [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    DLog(@"preferredInterfaceOrientationForPresentation");
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
