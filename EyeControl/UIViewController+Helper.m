//
//  UIViewController+Helper.m
//  RunNG
//
//  Created by Celleus on 2017/02/21.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "UIViewController+Helper.h"

@implementation UIViewController (Helper)

- (void)alert:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
