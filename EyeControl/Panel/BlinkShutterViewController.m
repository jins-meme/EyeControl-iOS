//
//  BlinkShutterViewController.m
//  JINS
//
//  Created by Celleus on 2015/11/09.
//  Copyright © 2015年 Celleus. All rights reserved.
//

#import "BlinkShutterViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface BlinkShutterViewController () {
    AVCaptureDeviceInput *frontFacingCameraDeviceInput;
    AVCaptureDeviceInput *backFacingCameraDeviceInput;
    
    UIButton *selectbutton;
    UIButton *changeDeviceButton;
    UIButton *shutterButton;
    UIButton *backButton;
}

@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) UIView *previewView;

@end

@implementation BlinkShutterViewController

- (void)loadView {
    [super loadView];
    
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationItem.titleView = nil;
    
    // プレビュー用のビューを生成
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                self.view.bounds.size.width,
                                                                self.view.bounds.size.height)];
    [self.view addSubview:self.previewView];
    
    
    CGFloat safeArea = 0;
    if ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812) {
        safeArea = 44;
    }
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    statusH + naviH,
                                                                    self.view.frame.size.width - 20*2,
                                                                    40)];
    titleLabel.text = @"まばたきシャッター";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    // ボタン
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (150 + safeAreaBottom), self.view.frame.size.width, (150 + safeAreaBottom))];
    view.backgroundColor = [Common colorWithHex:@"#3a4e61" alpha:0.3];
    [self.view addSubview:view];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                          0,
                                                                          self.view.frame.size.width - 20*2,
                                                                          50)];
    descriptionLabel.text = @"視線移動で選択し、まばたき2回で決定";
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:descriptionLabel];
    
    changeDeviceButton = [[UIButton alloc] initWithFrame:CGRectMake((view.frame.size.width / 3) * 0,
                                                                    descriptionLabel.frame.size.height,
                                                                    view.frame.size.width / 3,
                                                                    view.frame.size.height - (descriptionLabel.frame.size.height + safeAreaBottom))];
    [changeDeviceButton setImage:[UIImage imageNamed:@"camera_icon_change.png"] forState:UIControlStateNormal];
    [changeDeviceButton addTarget:self action:@selector(changeDevice) forControlEvents:UIControlEventTouchUpInside];
    changeDeviceButton.imageView.contentMode = UIViewContentModeCenter;
    [view addSubview:changeDeviceButton];
    
    shutterButton = [[UIButton alloc] initWithFrame:CGRectMake((view.frame.size.width / 3) * 1,
                                                               descriptionLabel.frame.size.height,
                                                               view.frame.size.width / 3,
                                                               view.frame.size.height - (descriptionLabel.frame.size.height + safeAreaBottom))];
    [shutterButton addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [shutterButton setImage:[UIImage imageNamed:@"camera_icon_shoot.png"] forState:UIControlStateNormal];
    shutterButton.imageView.contentMode = UIViewContentModeCenter;
    [view addSubview:shutterButton];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake((view.frame.size.width / 3) * 2,
                                                            descriptionLabel.frame.size.height,
                                                            view.frame.size.width / 3,
                                                            view.frame.size.height - (descriptionLabel.frame.size.height + safeAreaBottom))];
    [backButton setImage:[UIImage imageNamed:@"camera_icon_finish.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageView.contentMode = UIViewContentModeCenter;
    [view addSubview:backButton];
    
    
    // セットアップ
    [self setupAVCapture];
    
    selectbutton = shutterButton;
    [self selectButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"viewWillAppear")
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DLog(@"viewWillDisappear");
    [self.session stopRunning];
}

- (void)selectButton {
    DLog(@"selectButton")
    
    [changeDeviceButton setImage:[UIImage imageNamed:@"camera_icon_change.png"] forState:UIControlStateNormal];
    [shutterButton setImage:[UIImage imageNamed:@"camera_icon_shoot.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"camera_icon_finish.png"] forState:UIControlStateNormal];
    
    if (selectbutton == changeDeviceButton) {
        [changeDeviceButton setImage:[UIImage imageNamed:@"camera_icon_change_selected.png"] forState:UIControlStateNormal];
    }
    else if (selectbutton == shutterButton) {
        [shutterButton setImage:[UIImage imageNamed:@"camera_icon_shoot_selected.png"] forState:UIControlStateNormal];
    }
    else if (selectbutton == backButton) {
        [backButton setImage:[UIImage imageNamed:@"camera_icon_finish_selected.png"] forState:UIControlStateNormal];
    }
}

// セットアップ
- (void)setupAVCapture {
    DLog(@"setupAVCapture")
    
    NSError *error = nil;
    
    // 入力と出力からキャプチャーセッションを作成
    self.session = [[AVCaptureSession alloc] init];
    
    // アウトカメラとインカメラの作成
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            NSError *error = nil;
            if (device.position == AVCaptureDevicePositionBack) {
                backFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            }else{
                frontFacingCameraDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            }
        }
    }
    
    // アウトカメラを初期としてセッションにセット
    [self.session addInput:backFacingCameraDeviceInput];
    
    // 画像への出力を作成し、セッションに追加
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];
    
    // セッションからプレビュー表示を作成
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // プレビューを表示Viewのlayerに追加
    CALayer *previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
    // セッション開始
    [self.session startRunning];
}

// カメラ切替
-(void)changeDevice {
    DLog(@"changeDevice")
    
    [self.session beginConfiguration];
    
    AVCaptureDeviceInput *deviceInput = (AVCaptureDeviceInput *)[self.session.inputs objectAtIndex:0];
    AVCaptureDevice *device = deviceInput.device;
    AVCaptureDeviceInput *nextDeviceInput;
    if (device.position == AVCaptureDevicePositionBack) {
        nextDeviceInput = frontFacingCameraDeviceInput;
    }else{
        nextDeviceInput = backFacingCameraDeviceInput;
    }
    [self.session removeInput:deviceInput];
    [self.session addInput:nextDeviceInput];
    
    [self.session commitConfiguration];
}

// 画像保存
- (void)savePhoto {
    DLog(@"savePhoto");
    
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }
    
    // ビデオ入力から画像を非同期で取得。ブロックで定義されている処理が呼び出され、画像データを引数から取得する
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         
         // JPEGデータからUIImageを作成
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         // アルバムに画像を保存
         UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
     }];
}

- (void)left:(int)move {
    DLog(@"left move:%d",move)
    if (move > 0) {
        if (selectbutton == changeDeviceButton) {
        }
        else if (selectbutton == shutterButton) {
            selectbutton = changeDeviceButton;
        }
        else if (selectbutton == backButton) {
            if (move == 1) {
                selectbutton = shutterButton;
            }
            else if (move == 2) {
                selectbutton = changeDeviceButton;
            }
        }
        [self selectButton];
    }
}

- (void)right:(int)move {
    DLog(@"right move:%d",move)
    if (move > 0) {
        if (selectbutton == changeDeviceButton) {
            if (move == 1) {
                selectbutton = shutterButton;
            }
            else if (move == 2) {
                selectbutton = backButton;
            }
        }
        else if (selectbutton == shutterButton) {
            selectbutton = backButton;
        }
        else if (selectbutton == backButton) {
            
        }
        [self selectButton];
    }
}

- (void)up:(int)move {
    // 今回は使用しない
}
- (void)down:(int)move {
    // 今回は使用しない
}

//**************************************************
// MEMEManagerRealTimeModeDataDelegate
//**************************************************

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    [super memeRealTimeModeDataReceived:data];
    
    if ([[Common getUserDefaultsForKey:EYE_SWITCH] boolValue]) {
        [[EyeMoveManager sharedInstance] memeRealTimeModeDataReceived:data];
    }
    
    if ([[Common getUserDefaultsForKey:NECK_SWITCH] boolValue]) {
        [[NeckManager sharedInstance] memeRealTimeModeDataReceived:data];
    }
    
    if (data.blinkSpeed) {
        double now = [[NSDate date] timeIntervalSince1970];
        if (now - blinkDateDouble <= [[Common getUserDefaultsForKey:Blink_EMC2] floatValue]) {
            
            // 決定
            if (selectbutton == changeDeviceButton) {
                [self changeDevice];
            }
            else if (selectbutton == shutterButton) {
                [self savePhoto];
            }
            else if (selectbutton == backButton) {
                [self pop];
            }
            
        }
        blinkDateDouble = now;
    }
}

//**************************************************
// EyeMoveManagerDelegate
//**************************************************

- (void)didPeakEyeMove:(EyeMoveManagerDirection)direction count:(int)count eyeMove:(int)eyeMove {
    DLog(@"didPeakEyeMove direction:%d count:%d eyeMove:%d",direction,count,eyeMove);
    
    int move = 0;
    
    if ( (count >= 4 && direction == EyeMoveManagerDirectionLeft)
        || (count >= 4 && direction == EyeMoveManagerDirectionRight) ) {
        DialogViewController *viewController = [[DialogViewController alloc] init];
        viewController.viewController = self;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else {
        // モード1
        if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 0) {
            move = 0;
            if (count > 1) {
                move = 1;
                if (abs(eyeMove) > 1) {
                    move = 2;
                }
            }
        }
        // モード2
        else if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 1) {
            move = 0;
            if (count > 1) {
                move = 1;
            }
        }
        // モード3
        else if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 2) {
            move = 0;
            if (count > 1 && abs(eyeMove) > 1) {
                move = 1;
            }
        }
        // モード4
        else {
            move = 0;
            if (abs(eyeMove) > 1) {
                move = 1;
            }
        }
        
        if (direction == EyeMoveManagerDirectionUp) {
            [self down:move];
        }
        else if (direction == EyeMoveManagerDirectionLeft) {
            [self right:move];
        }
        else if (direction == EyeMoveManagerDirectionDown) {
            [self up:move];
        }
        else if (direction == EyeMoveManagerDirectionRight) {
            [self left:move];
        }
    }
}

//**************************************************
// NeckManagerDelegate
//**************************************************

- (void)didPeakNeck:(int)direction count:(int)count {
    DLog(@"didPeakNeck direction:%d count:%d",direction,count);
    
    if ( (count >= 4 && direction == EyeMoveManagerDirectionLeft)
        || (count >= 4 && direction == EyeMoveManagerDirectionRight) ) {
        DialogViewController *viewController = [[DialogViewController alloc] init];
        viewController.viewController = self;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else if (count >= 2) {
        int move = 1;
        
        if (direction == EyeMoveManagerDirectionUp) {
            [self up:move];
        }
        else if (direction == EyeMoveManagerDirectionLeft) {
            [self left:move];
        }
        else if (direction == EyeMoveManagerDirectionDown) {
            [self down:move];
        }
        else if (direction == EyeMoveManagerDirectionRight) {
            [self right:move];
        }
    }
}

@end
