//
//  MEMEManager.m
//  TrackYourForm
//
//  Created by Celleus on 2017/01/25.
//  Copyright © 2017年 Celleus. All rights reserved.
//

#import "MEMEManager.h"

@implementation MEMEManager  {
    NSTimer *connectingTimer;
}

static MEMEManager *sharedInstance_ = nil;

+ (MEMEManager *)sharedInstance {
    if (!sharedInstance_) {
        sharedInstance_  = [[MEMEManager alloc] init];
    }
    return sharedInstance_;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.peripherals = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (void)setAppClientId:(NSString *)appClientId clientSecret:(NSString *)clientSecret {
    DLog(@"setAppClientId:%@ clientSecret:%@",appClientId,clientSecret);
    
    [MEMELib setAppClientId:appClientId clientSecret:clientSecret];
    
    [MEMELib sharedInstance].delegate = sharedInstance_;
    [[MEMELib sharedInstance] addObserver:sharedInstance_ forKeyPath:@"centralManagerEnabled" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)startScanningPeripherals
{
    DLog(@"startScanningPeripherals");
    
    if ([self.pairingDelegate respondsToSelector:@selector(willStartScanningPeripherals)]) {
        [self.pairingDelegate willStartScanningPeripherals];
    }
    
    [self checkMEMEStatus: [[MEMELib sharedInstance] stopScanningPeripherals]];
    
    [self.peripherals removeAllObjects];
    
    [self checkMEMEStatus: [[MEMELib sharedInstance] startScanningPeripherals]];
    
    if ([self.pairingDelegate respondsToSelector:@selector(didStartScanningPeripherals)]) {
        [self.pairingDelegate didStartScanningPeripherals];
    }
}

- (void)stopScanningPeripherals {
    DLog(@"stopScanningPeripherals");
    
    if ([self.pairingDelegate respondsToSelector:@selector(willStopScanningPeripherals)]) {
        [self.pairingDelegate willStopScanningPeripherals];
    }
    
    [self checkMEMEStatus: [[MEMELib sharedInstance] stopScanningPeripherals]];
    
    if ([self.pairingDelegate respondsToSelector:@selector(didStopScanningPeripherals)]) {
        [self.pairingDelegate didStopScanningPeripherals];
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    DLog(@"connectPeripheral");
    [self checkMEMEStatus: [[MEMELib sharedInstance] connectPeripheral:peripheral]];
    
    connectingTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                       target:self
                                                     selector:@selector(connectError)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)connectError {
    DLog(@"connectError");
    
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    if ([self.pairingDelegate respondsToSelector:@selector(connectError)]) {
        [self.pairingDelegate connectError];
    }
}

- (void)disconnectPeripheral
{
    DLog(@"disconnectPeripheral");
    [self checkMEMEStatus: [[MEMELib sharedInstance] disconnectPeripheral]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"observeValueForKeyPath:%@",keyPath);
    if ([keyPath isEqualToString: @"centralManagerEnabled"]){
    }
}

- (void)memeAppAuthorized:(MEMEStatus)status
{
    DLog(@"memeAppAuthorized");
}

- (void)checkMEMEStatus:(MEMEStatus) status
{
    if (status == MEME_ERROR_APP_AUTH){
        DLog(@"checkMEMEStatus: MEME_ERROR_APP_AUTH");
        [[[UIAlertView alloc] initWithTitle: @"App Auth Failed" message: @"Invalid Application ID or Client Secret " delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil] show];
    } else if (status == MEME_ERROR_SDK_AUTH){
        DLog(@"checkMEMEStatus: MEME_ERROR_SDK_AUTH");
        [[[UIAlertView alloc] initWithTitle: @"SDK Auth Failed" message: @"Invalid SDK. Please update to the latest SDK." delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil] show];
    } else if (status == MEME_OK){
        DLog(@"checkMEMEStatus: MEME_OK");
    }
    else if (status == MEME_ERROR_CONNECTION ) {
        DLog(@"checkMEMEStatus: MEME_ERROR_CONNECTION");
    }
    else if (status == MEME_ERROR ) {
        DLog(@"checkMEMEStatus: MEME_ERROR");
    }
}

- (void)memePeripheralFound:(CBPeripheral *)peripheral withDeviceAddress:(NSString *)address;
{
    DLog(@"memePeripheralFound:%@",[peripheral.identifier UUIDString]);
    
    BOOL isHit = NO;
    for (MEMEPeripheral *memePeripheral in self.peripherals) {
        if (memePeripheral.pripheral == peripheral) {
            isHit = YES;
            break;
        }
    }
    
    if (!isHit) {
        MEMEPeripheral *memePeripheral = [[MEMEPeripheral alloc] init];
        memePeripheral.pripheral = peripheral;
        memePeripheral.address = address;
        
        [self.peripherals addObject:memePeripheral];
        
        if ([self.pairingDelegate respondsToSelector:@selector(memePeripheralFound:withDeviceAddress:)]) {
            [self.pairingDelegate memePeripheralFound:peripheral withDeviceAddress:address];
        }
    }
}

- (void)memePeripheralConnected:(CBPeripheral *)peripheral
{
    DLog(@"memePeripheralConnected:%@",[peripheral.identifier UUIDString]);
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    MEMEPeripheral *memePeripheral;
    for (MEMEPeripheral *memePeri in self.peripherals) {
        if ([[memePeri.pripheral.identifier UUIDString] isEqualToString:[peripheral.identifier UUIDString]]) {
            memePeripheral = memePeri;
        }
    }
    
    self.connectingPeripheral = memePeripheral;
    self.reConnectPeripheral = nil;
    
    [[MEMELib sharedInstance] startDataReport];
    
    if ([self.pairingDelegate respondsToSelector:@selector(memePeripheralConnected:)]) {
        [self.pairingDelegate memePeripheralConnected:peripheral];
    }
}

- (void)memePeripheralDisconnected:(CBPeripheral *)peripheral
{
    DLog(@"memePeripheralDisconnected:%@",[peripheral.identifier UUIDString]);
    [connectingTimer invalidate];
    connectingTimer = nil;
    
    [[MEMELib sharedInstance] stopDataReport];
    
    self.reConnectPeripheral = self.connectingPeripheral;
    self.connectingPeripheral = nil;
    
    if ([self.pairingDelegate respondsToSelector:@selector(memePeripheralDisconnected:)]) {
        [self.pairingDelegate memePeripheralDisconnected:peripheral];
    }
}

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data
{
//    DLog(@"memeRealTimeModeDataReceived:%@",[data description]);
    
    if ([self.realTimeModeDataDelegate respondsToSelector:@selector(memeRealTimeModeDataReceived:)]) {
        [self.realTimeModeDataDelegate memeRealTimeModeDataReceived:data];
    }
}

@end
