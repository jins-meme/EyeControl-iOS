//
//  CustomViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/08/03.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "CustomViewController.h"

#import "PairingViewController.h"

@interface CustomViewController () <MEMEManagerPairingDelegate,MEMEManagerRealTimeModeDataDelegate,EyeMoveManagerDelegate,NeckManagerDelegate> {
    UIButton *backButtonItem;
    UIBarButtonItem *rightBarButtonItem;
    UIBarButtonItem *leftSpacer;
}

@end

@implementation CustomViewController

- (void)loadView {
    [super loadView];
    
    safeAreaTop = 0;
    safeAreaBottom = 0;
    if ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812) {
        safeAreaTop = 44;
        safeAreaBottom = 34;
    }
    
    statusH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    naviH = self.navigationController.navigationBar.frame.size.height;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    backButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButtonItem setImage:[UIImage imageNamed:@"meme_not_connect.png"] forState:UIControlStateNormal];
    [backButtonItem addTarget:self action:@selector(pairing) forControlEvents:UIControlEventTouchUpInside];
    
    rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButtonItem];
    [[rightBarButtonItem.customView.widthAnchor constraintEqualToConstant:40.0] setActive:YES];
    [[rightBarButtonItem.customView.heightAnchor constraintEqualToConstant:40.0] setActive:YES];
    
    leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    leftSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:leftSpacer, rightBarButtonItem, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"viewWillAppear");
    
    self.view.backgroundColor = [Common colorWithHex:@"#3a4e61"];
    
    [self pairingCheck];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"viewDidAppear");
    
    [EyeMoveManager sharedInstance].delegate = self;
    [NeckManager sharedInstance].delegate = self;
    [MEMEManager sharedInstance].realTimeModeDataDelegate = self;
    [MEMEManager sharedInstance].pairingDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DLog(@"viewWillDisappear");
    
    [EyeMoveManager sharedInstance].delegate = nil;
    [NeckManager sharedInstance].delegate = nil;
    [MEMEManager sharedInstance].realTimeModeDataDelegate = nil;
    [MEMEManager sharedInstance].pairingDelegate = nil;
}

- (void)pop {
    DLog(@"pop")
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pairing {
    DLog(@"pairing");
    
    PairingViewController *pairingViewController = [[PairingViewController alloc] init];
    UINavigationController *pairingNavigationController = [[UINavigationController alloc] initWithRootViewController:pairingViewController];
    [self presentViewController:pairingNavigationController animated:YES completion:nil];
}

- (void)pairingCheck {
    DLog(@"pairingCheck");
    if ([MEMELib sharedInstance].isConnected) {
        [backButtonItem setImage:[UIImage imageNamed:@"meme_connect_100.png"] forState:UIControlStateNormal];
    }
    else {
        [backButtonItem setImage:[UIImage imageNamed:@"meme_not_connect.png"] forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotate {
    DLog(@"shouldAutorotate")
    return NO;
}

//**************************************************
// MEMEManagerPairingDelegate
//**************************************************

// ペリフェルとの切断
- (void)memePeripheralDisconnected:(CBPeripheral *)peripheral {
    DLog(@"memePeripheralDisconnected:%@",[peripheral.identifier UUIDString]);
    
    [[MEMEManager sharedInstance].peripherals removeAllObjects];
    
    [self pairingCheck];
    
    [self alert:@"MEMEとの接続が切れました" message:@""];
}

//**************************************************
// MEMEManagerRealTimeModeDataDelegate
//**************************************************

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    
    if ([MEMELib sharedInstance].isConnected) {
        if (data.powerLeft == 5) {
            [backButtonItem setImage:[UIImage imageNamed:@"meme_connect_100.png"] forState:UIControlStateNormal];
        }
        else if (data.powerLeft == 4) {
            [backButtonItem setImage:[UIImage imageNamed:@"meme_connect_80.png"] forState:UIControlStateNormal];
        }
        else if (data.powerLeft == 3) {
            [backButtonItem setImage:[UIImage imageNamed:@"meme_connect_60.png"] forState:UIControlStateNormal];
        }
        else if (data.powerLeft == 2) {
            [backButtonItem setImage:[UIImage imageNamed:@"meme_connect_40.png"] forState:UIControlStateNormal];
        }
        else if (data.powerLeft == 1) {
            [backButtonItem setImage:[UIImage imageNamed:@"meme_connect_20.png"] forState:UIControlStateNormal];
        }
        else {
            [backButtonItem setImage:[UIImage imageNamed:@"meme_not_connect.png"] forState:UIControlStateNormal];
        }
    }
    else {
        [backButtonItem setImage:[UIImage imageNamed:@"meme_not_connect.png"] forState:UIControlStateNormal];
    }
}

@end
