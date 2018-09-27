//
//  PairingViewController.m
//  JINS
//
//  Created by Celleus on 2015/10/20.
//  Copyright © 2015年 Celleus. All rights reserved.
//

#import "PairingViewController.h"

@interface PairingViewController () <UITableViewDelegate,UITableViewDataSource,MEMEManagerPairingDelegate,CBPeripheralManagerDelegate> {
    UITableView *tableView;
    NSTimer *scanStopTimer;
    CBPeripheralManager *peripheralManager;
    
    UIImageView *powerImageView;
    UILabel *powerLabel;
    
    UIImageView *statusImageView;
    UILabel *memeFoundLabel;
    UIButton *retryButton;
    UIButton *notFoundButton;
    
    UILabel *connectLabel;
    UILabel *connectingDeviceLabel;
    
    UIButton *disConnectButton;
    UIButton *finishButton;
    
    CGFloat statusH;
    CGFloat naviH;
    CGFloat safeAreaTop;
    CGFloat safeAreaBottom;
}

@end

@implementation PairingViewController

- (void)loadView {
    [super loadView];
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:@{CBPeripheralManagerOptionShowPowerAlertKey:@"YES"}];
    
    safeAreaTop = 0;
    safeAreaBottom = 0;
    if ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812) {
        safeAreaTop = 44;
        safeAreaBottom = 34;
    }
    
    statusH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    naviH = self.navigationController.navigationBar.frame.size.height;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        DLog(@"bluetooth OFF");
        [self alert:NSLocalizedString(@"端末のBluetoothをオンにしてください",nil) message:@""];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        DLog(@"bluetooth ON");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    self.view.backgroundColor = [Common colorWithHex:@"#3a4e61"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"閉じる",nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(close)];
    
    // 電源on 〜　memeが見つかるまで
    powerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2,
                                                                    (self.view.frame.size.height - statusH - naviH - safeAreaBottom ) / 2 - 100/2,
                                                                    100,
                                                                    100)];
    powerImageView.animationImages = @[[UIImage imageNamed:@"meme_power_off.png"],[UIImage imageNamed:@"meme_power_on.png"]];
    powerImageView.animationDuration = 0.15;
    powerImageView.animationRepeatCount = 0;
    [self.view addSubview:powerImageView];
    [powerImageView startAnimating];
    powerImageView.hidden = YES;
    
    powerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                           powerImageView.frame.origin.y + powerImageView.frame.size.height + 40,
                                                           self.view.frame.size.width,
                                                           20)];
    powerLabel.text = NSLocalizedString(@"青点滅するまで電源ボタンを長押ししてください",nil);
    powerLabel.font = [UIFont boldSystemFontOfSize:13];
    powerLabel.textAlignment = NSTextAlignmentCenter;
    powerLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:powerLabel];
    powerLabel.hidden = YES;
    
    // memeが見つかってから 〜　接続まで
    statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 120)/2,
                                                                   20 + 44 + 50,
                                                                   120,
                                                                   120)];
    statusImageView.image = [UIImage imageNamed:@"meme_not_connect.png"];
    [self.view addSubview:statusImageView];
    statusImageView.hidden = YES;

    memeFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                            statusImageView.frame.origin.y + statusImageView.frame.size.height + 40,
                                                            self.view.frame.size.width,
                                                            20)];
    memeFoundLabel.text = NSLocalizedString(@"接続するJINS MEMEを選択してください",nil);
    memeFoundLabel.font = [UIFont boldSystemFontOfSize:13];
    memeFoundLabel.textAlignment = NSTextAlignmentCenter;
    memeFoundLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:memeFoundLabel];
    memeFoundLabel.hidden = YES;
    
    tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    tableView.hidden = YES;
    
    retryButton = [[UIButton alloc] init];
    [retryButton setTitle:NSLocalizedString(@"もう一度接続",nil) forState:UIControlStateNormal];
    [retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    retryButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [retryButton addTarget:self action:@selector(statusMEMEScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retryButton];
    retryButton.hidden = YES;
    
    notFoundButton = [[UIButton alloc] initWithFrame:CGRectMake(20,
                                                                self.view.frame.size.height - (24 + safeAreaBottom),
                                                                self.view.frame.size.width-20*2,
                                                                24)];
    [notFoundButton setTitle:NSLocalizedString(@"見つからなかった場合",nil) forState:UIControlStateNormal];
    [notFoundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [notFoundButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    notFoundButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:notFoundButton];
    notFoundButton.hidden = YES;

    // 接続完了
    connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                             statusImageView.frame.origin.y + statusImageView.frame.size.height + 40,
                                                             self.view.frame.size.width,
                                                             20)];
    connectLabel.text = NSLocalizedString(@"接続中のJINS MEME",nil);
    connectLabel.font = [UIFont boldSystemFontOfSize:13];
    connectLabel.textAlignment = NSTextAlignmentCenter;
    connectLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:connectLabel];
    connectLabel.hidden = YES;
    
    connectingDeviceLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       connectLabel.frame.origin.y + connectLabel.frame.size.height + 20,
                                                                       self.view.frame.size.width,
                                                                       60)];
    connectingDeviceLabel.backgroundColor = [UIColor whiteColor];
    connectingDeviceLabel.text = @"";
    connectingDeviceLabel.textColor = [Common colorWithHex:@"#4d94e9"];
    connectingDeviceLabel.font = [UIFont boldSystemFontOfSize:12];
    connectingDeviceLabel.textAlignment = NSTextAlignmentCenter;
    connectingDeviceLabel.numberOfLines = 2;
    [self.view addSubview:connectingDeviceLabel];
    connectingDeviceLabel.hidden = YES;
    
    disConnectButton = [[UIButton alloc] initWithFrame:CGRectMake(20,
                                                                  connectingDeviceLabel.frame.origin.y + connectingDeviceLabel.frame.size.height + 20,
                                                                  self.view.frame.size.width-20*2,
                                                                  24)];
    [disConnectButton setTitle:NSLocalizedString(@"JINS MEMEと接続解除する",nil) forState:UIControlStateNormal];
    [disConnectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [disConnectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    disConnectButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [disConnectButton addTarget:self action:@selector(disConnect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:disConnectButton];
    disConnectButton.hidden = YES;


    finishButton= [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                             self.view.frame.size.height - (50 + safeAreaBottom),
                                                             self.view.frame.size.width,
                                                             50)];
    finishButton.backgroundColor = [UIColor whiteColor];
    [finishButton setTitle:NSLocalizedString(@"完了",nil) forState:UIControlStateNormal];
    [finishButton setTitleColor:[Common colorWithHex:@"#3a4e61"] forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [finishButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    finishButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"viewWillAppear");
    
    [MEMEManager sharedInstance].pairingDelegate = self;
    
    [self statusMEMEScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 閉じる
- (void)close {
    DLog(@"close");
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 切断
- (void)disConnect {
    DLog(@"disConnect");
    
    [[MEMEManager sharedInstance] disconnectPeripheral];
}
// 検索開始
- (void)scan {
    DLog(@"scan");
    scanStopTimer = nil;
    [scanStopTimer invalidate];
    [[MEMEManager sharedInstance] startScanningPeripherals];
}
// 検索停止
- (void)stopScan {
    DLog(@"stopScan");
    scanStopTimer = nil;
    [scanStopTimer invalidate];
    [[MEMEManager sharedInstance] stopScanningPeripherals];
}

- (void)statusMEMEScan {
    DLog(@"statusMEMEScan");
    
    if ([MEMELib sharedInstance].isConnected) {
        [self statusConnected];
        return;
    }
    
    powerImageView.hidden = NO;
    powerLabel.hidden = NO;
    
    statusImageView.hidden = YES;
    memeFoundLabel.hidden = YES;
    tableView.hidden = YES;
    retryButton.hidden = YES;
    notFoundButton.hidden = YES;
    tableView.layer.borderWidth = 0;
    tableView.layer.borderColor = [[UIColor clearColor] CGColor];
    
    connectLabel.hidden = YES;
    connectingDeviceLabel.hidden = YES;
    
    disConnectButton.hidden = YES;
    finishButton.hidden = YES;
    
    [self scan];
}
- (void)statusMEMEFound {
    DLog(@"statusMEMEFound");
    
    if ([MEMELib sharedInstance].isConnected) {
        [self statusConnected];
        return;
    }
    
    powerImageView.hidden = YES;
    powerLabel.hidden = YES;
    
    statusImageView.hidden = NO;
    memeFoundLabel.hidden = NO;
    tableView.hidden = NO;
    retryButton.hidden = NO;
    notFoundButton.hidden = NO;
    tableView.frame = CGRectMake(-1,
                                 memeFoundLabel.frame.origin.y + memeFoundLabel.frame.size.height + 30,
                                 self.view.frame.size.width+2,
                                 50*[[MEMEManager sharedInstance].peripherals count]);
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    retryButton.frame = CGRectMake(20,
                                   tableView.frame.origin.y + tableView.frame.size.height + 20,
                                   self.view.frame.size.width-20*2,
                                   24);
    [tableView reloadData];
    
    disConnectButton.hidden = YES;
    finishButton.hidden = YES;
    
    scanStopTimer = nil;
    [scanStopTimer invalidate];
    scanStopTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                     target:self
                                                   selector:@selector(stopScan)
                                                   userInfo:nil
                                                    repeats:NO];
}
- (void)statusConnected {
    DLog(@"statusConnected");
    
    powerImageView.hidden = YES;
    powerLabel.hidden = YES;
    
    memeFoundLabel.hidden = YES;
    tableView.hidden = YES;
    retryButton.hidden = YES;
    notFoundButton.hidden = YES;
    
    statusImageView.hidden = NO;
    connectLabel.hidden = NO;
    connectingDeviceLabel.hidden = NO;
    disConnectButton.hidden = NO;
    finishButton.hidden = NO;
    statusImageView.image = [UIImage imageNamed:@"meme_connect_100.png"];
    connectingDeviceLabel.text = [NSString stringWithFormat:@"%@\n%@",[[MEMEManager sharedInstance].connectingPeripheral.pripheral.identifier UUIDString],[NSString stringWithFormat:@"Firmware %@",[[MEMELib sharedInstance] getFWVersion]]];
}

//**************************************************
// MEMEManagerPairingDelegate
//**************************************************

// 検索開始直前
- (void)willStartScanningPeripherals {
    DLog(@"willStartScanningPeripherals")
}
// 検索開始直後
- (void)didStartScanningPeripherals {
    DLog(@"didStartScanningPeripherals")
}
// 検索停止直前
- (void)willStopScanningPeripherals {
    DLog(@"willStopScanningPeripherals")
}
// 検索停止直後
- (void)didStopScanningPeripherals {
    DLog(@"didStopScanningPeripherals")
}

// ペリフェラルの取得
- (void)memePeripheralFound:(CBPeripheral *)peripheral withDeviceAddress:(NSString *)address;
{
    DLog(@"memePeripheralFound:%@",[peripheral.identifier UUIDString]);
    
    [self statusMEMEFound];
}
// ペリフェルとの接続
- (void)memePeripheralConnected:(CBPeripheral *)peripheral
{
    DLog(@"memePeripheralConnected:%@",[peripheral.identifier UUIDString]);
    [SVProgressHUD dismiss];
    
    [self statusConnected];
}

// 接続に失敗
- (void)connectError {
    DLog(@"connectError");
    [SVProgressHUD dismiss];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"エラー",nil)
                                                                             message:NSLocalizedString(@"MEMEとの接続に失敗しました。MEMEが接続可能な状態かお確かめください。",nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [tableView reloadData];
}

// ペリフェルとの切断
- (void)memePeripheralDisconnected:(CBPeripheral *)peripheral
{
    DLog(@"memePeripheralDisconnected:%@",[peripheral.identifier UUIDString]);
    
    [[MEMEManager sharedInstance].peripherals removeAllObjects];
    [tableView reloadData];
    
    [self statusMEMEScan];
    
    [self alert:NSLocalizedString(@"MEMEとの接続が切れました",nil) message:@""];
}

//**************************************************
// table
//**************************************************

// セクション
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セクション高さ
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
// ロウ
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[MEMEManager sharedInstance].peripherals count];
}
// ロウ高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
// ロウ表示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    MEMEPeripheral *memePeripheral = [[MEMEManager sharedInstance].peripherals objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = memePeripheral.pripheral;

    cell.textLabel.text = [peripheral.identifier UUIDString];
    cell.detailTextLabel.text = memePeripheral.address;

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}
// タップ
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![MEMELib sharedInstance].isConnected) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [Common colorWithHex:@"#4d94e9"];
        cell.detailTextLabel.textColor = [Common colorWithHex:@"#4d94e9"];
        
        MEMEPeripheral *memePeripheral = [[MEMEManager sharedInstance].peripherals objectAtIndex: indexPath.row];
        CBPeripheral *peripheral = memePeripheral.pripheral;
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"接続中",nil) maskType:SVProgressHUDMaskTypeBlack];
        [[MEMEManager sharedInstance] connectPeripheral:peripheral];
    }
    else {
        [self alert:NSLocalizedString(@"既にMEMEと接続しています",nil) message:@""];
        [self statusConnected];
    }
}

@end
