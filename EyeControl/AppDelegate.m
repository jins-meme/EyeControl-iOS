//
//  AppDelegate.m
//  EyeControl
//
//  Created by Celleus on 2017/08/08.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate () {
    ViewController *viewController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // MEMEの初期設定
    [MEMEManager sharedInstance];
    [MEMEManager setAppClientId:MEME_APP_CLIENT_ID clientSecret:MEME_CLIENT_SECRET];
    
    // 設定関連の初期値の設定
    [self initSetting];
    
    viewController =  [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.shadowImage = [UIImage new];
    viewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    self.window.rootViewController = navigationController;
    
    // ナビゲーションバーのカスタマイズ
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DLog(@"application openURL:%@",url);
    
    [viewController.navigationController popToRootViewControllerAnimated:NO];
    [viewController pdf:url];
    
    return YES;
}

- (void)initSetting {
    DLog(@"initSetting");
    
    if (![Common getUserDefaultsForKey:TIME_DIF_EYE_MOVE]) {
        [Common setUserDefaults:@"0.5" forKey:TIME_DIF_EYE_MOVE];
    }
    
    if (![Common getUserDefaultsForKey:Blink_EMC2]) {
        [Common setUserDefaults:@"0.6" forKey:Blink_EMC2];
    }
    
    if (![Common getUserDefaultsForKey:TIME_DIF_NECK]) {
        [Common setUserDefaults:@"0.5" forKey:TIME_DIF_NECK];
    }
    
    if (![Common getUserDefaultsForKey:EYE_SWITCH]) {
        [Common setUserDefaults:[NSNumber numberWithBool:YES] forKey:EYE_SWITCH];
    }
    
    if (![Common getUserDefaultsForKey:NECK_SWITCH]) {
        [Common setUserDefaults:[NSNumber numberWithBool:NO] forKey:NECK_SWITCH];
    }
    
    if (![Common getUserDefaultsForKey:READ_SWITCH]) {
        [Common setUserDefaults:[NSNumber numberWithBool:NO] forKey:NECK_SWITCH];
    }
    
    if (![Common getUserDefaultsForKey:EYE_MOVE_MODE]) {
        [Common setUserDefaults:[NSNumber numberWithInt:2] forKey:EYE_MOVE_MODE];
    }
    
    if (![Common getUserDefaultsForKey:ORIGINAL_PANEL_2]) {
        NSMutableArray *buttonTitleArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        [array1 addObject:NSLocalizedString(@"おはよう",nil)];
        [array1 addObject:NSLocalizedString(@"調子良い",nil)];
        [array1 addObject:NSLocalizedString(@"おなかすいた",nil)];
        
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        [array2 addObject:NSLocalizedString(@"トイレ",nil)];
        [array2 addObject:NSLocalizedString(@"はい",nil)];
        [array2 addObject:NSLocalizedString(@"いいえ",nil)];
        
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        [array3 addObject:NSLocalizedString(@"くるしい",nil)];
        [array3 addObject:NSLocalizedString(@"ねむい",nil)];
        [array3 addObject:NSLocalizedString(@"何かよみたい",nil)];
        
        [buttonTitleArray addObject:array1];
        [buttonTitleArray addObject:array2];
        [buttonTitleArray addObject:array3];
        
        [Common setUserDefaults:buttonTitleArray forKey:ORIGINAL_PANEL_2];
    }
    
    if (![Common getUserDefaultsForKey:FALL_OUT_HIGH_SCORE]) {
        [Common setUserDefaults:@"0" forKey:FALL_OUT_HIGH_SCORE];
    }
    if (![Common getUserDefaultsForKey:TOUCH_OUT_HIGH_SCORE]) {
        [Common setUserDefaults:@"0" forKey:TOUCH_OUT_HIGH_SCORE];
    }
}

@end
