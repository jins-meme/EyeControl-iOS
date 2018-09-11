//
//  MEMEManager.h
//  TrackYourForm
//
//  Created by Celleus on 2017/01/25.
//  Copyright © 2017年 Celleus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MEMEPeripheral.h"

@protocol MEMEManagerPairingDelegate <NSObject>

// 検索開始直前
- (void)willStartScanningPeripherals;
// 検索開始直後
- (void)didStartScanningPeripherals;

// 検索停止直前
- (void)willStopScanningPeripherals;
// 検索停止直後
- (void)didStopScanningPeripherals;

// ペリフェラルの取得
- (void)memePeripheralFound:(CBPeripheral *)peripheral withDeviceAddress:(NSString *)address;
// ペリフェルとの接続
- (void)memePeripheralConnected:(CBPeripheral *)peripheral;
// ペリフェルとの切断
- (void)memePeripheralDisconnected:(CBPeripheral *)peripheral;

// ペリフェルとの接続に失敗
- (void)connectError;

@end

@protocol MEMEManagerRealTimeModeDataDelegate <NSObject>

// リアルタイムモードのデータ取得
- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data;

@end

@interface MEMEManager : NSObject <MEMELibDelegate,MEMEManagerPairingDelegate,MEMEManagerRealTimeModeDataDelegate>

@property (nonatomic,weak) id <MEMEManagerPairingDelegate> pairingDelegate;
@property (nonatomic,weak) id <MEMEManagerRealTimeModeDataDelegate> realTimeModeDataDelegate;

@property (nonatomic) NSMutableArray *peripherals;
@property (nonatomic) MEMEPeripheral *connectingPeripheral;
@property (nonatomic) MEMEPeripheral *reConnectPeripheral;

+ (MEMEManager *)sharedInstance;
+ (void)setAppClientId:(NSString *)appClientId clientSecret:(NSString *)clientSecret;

// 検索
- (void)startScanningPeripherals;
// 検索停止
- (void)stopScanningPeripherals;
// 接続
- (void)connectPeripheral:(CBPeripheral *)peripheral;
// 切断
- (void)disconnectPeripheral;

@end
