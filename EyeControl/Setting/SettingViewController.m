//
//  SettingViewController.m
//  EyeControl
//
//  Created by Celleus on 2017/08/22.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "SettingViewController.h"

#import "TutorialUseViewController.h"
#import "TutorialModeViewController.h"

@interface SettingViewController () <MEMEManagerRealTimeModeDataDelegate,EyeMoveManagerDelegate,NeckManagerDelegate> {
    
    UISwitch *eyeSwitch;
    UISwitch *neckSwitch;
    UISegmentedControl *segmentedControl;
    CLSSliderView *silderEMO;
    CLSSliderView *silderBC;
    CLSSliderView *silderNO;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:scrollView];
    
    CGFloat safeArea = 0;
    if ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812) {
        safeArea = 44;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    statusH + naviH,
                                                                    self.view.frame.size.width - 20*2,
                                                                    40)];
    titleLabel.text = @"SETTING";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#fce437"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    CGFloat naviBarHeight = self.navigationController.navigationBar.frame.size.height + 20 + safeArea;
    CGFloat buttonSize = 50;
    CGFloat switchSize = 50;
    CGFloat segmentSize = 40;
    CGFloat sliderSize = 50;
    CGFloat sectionMargin = 30;
    
    // チュートリアル
    UILabel *tutorialLaebl = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                       sectionMargin,
                                                                      self.view.frame.size.width - 10*2,
                                                                      20)];
    tutorialLaebl.text = @"チュートリアル";
    tutorialLaebl.textColor = [UIColor whiteColor];
    tutorialLaebl.font = [UIFont boldSystemFontOfSize:14];
    [scrollView addSubview:tutorialLaebl];
    
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, tutorialLaebl.frame.origin.y + tutorialLaebl.frame.size.height, self.view.frame.size.width, 1)];
//    line1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//    [scrollView addSubview:line1];
//
//    UIButton *tutorialUseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, line1.frame.origin.y + line1.frame.size.height, self.view.frame.size.width, buttonSize)];
//    [tutorialUseButton addTarget:self action:@selector(tutorialUse) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:tutorialUseButton];
//
//    UILabel *tutorialUseButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, tutorialUseButton.frame.size.height)];
//    tutorialUseButtonLabel.text = @"使い方";
//    tutorialUseButtonLabel.textColor = [UIColor lightGrayColor];
//    [tutorialUseButton addSubview:tutorialUseButtonLabel];
//
//    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tutorialUseButton.frame.size.width - 45,
//                                                                                0,
//                                                                                45,
//                                                                                45)];
//    arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
//    arrowImageView.contentMode = UIViewContentModeCenter;
//    [tutorialUseButton addSubview:arrowImageView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, tutorialLaebl.frame.origin.y + tutorialLaebl.frame.size.height, self.view.frame.size.width, 1)];
    line2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line2];
    
    UIButton *tutorialModeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, line2.frame.origin.y + line2.frame.size.height, self.view.frame.size.width, buttonSize)];
    [tutorialModeButton addTarget:self action:@selector(tutorialMode) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tutorialModeButton];
    
    UILabel *tutorialModeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, tutorialModeButton.frame.size.height)];
    tutorialModeButtonLabel.text = @"モードの説明";
    tutorialModeButtonLabel.textColor = [UIColor lightGrayColor];
    [tutorialModeButton addSubview:tutorialModeButtonLabel];
    
    UIImageView *arrowImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(tutorialModeButton.frame.size.width - 45,
                                                                                0,
                                                                                45,
                                                                                45)];
    arrowImageView2.image = [UIImage imageNamed:@"arrow_right.png"];
    arrowImageView2.contentMode = UIViewContentModeCenter;
    [tutorialModeButton addSubview:arrowImageView2];
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, tutorialModeButton.frame.origin.y + tutorialModeButton.frame.size.height, self.view.frame.size.width, 1)];
    line3.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line3];
    
    
    
    // 視線
    UILabel *eyeModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                      line3.frame.origin.y + line3.frame.size.height + sectionMargin,
                                                                      self.view.frame.size.width - 10*2,
                                                                      20)];
    eyeModeLabel.text = @"視線の設定";
    eyeModeLabel.textColor = [UIColor whiteColor];
    eyeModeLabel.font = [UIFont boldSystemFontOfSize:14];
    [scrollView addSubview:eyeModeLabel];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, eyeModeLabel.frame.origin.y + eyeModeLabel.frame.size.height, self.view.frame.size.width, 1)];
    line4.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line4];
    
    UILabel *eyeSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                        line4.frame.origin.y + line4.frame.size.height,
                                                                        self.view.frame.size.width/4,
                                                                        switchSize)];
    eyeSwitchLabel.text = @"視線モード";
    eyeSwitchLabel.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:eyeSwitchLabel];
    
    eyeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70,
                                                           line4.frame.origin.y + line4.frame.size.height + (switchSize-30)/2,
                                                           200,
                                                           switchSize)];
    eyeSwitch.on = [[Common getUserDefaultsForKey:EYE_SWITCH] boolValue];
    [eyeSwitch addTarget:self action:@selector(eyeSwitch:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:eyeSwitch];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, eyeSwitchLabel.frame.origin.y + eyeSwitchLabel.frame.size.height, self.view.frame.size.width, 1)];
    line5.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line5];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"モード1",@"モード2",@"モード3",@"モード4"]];
    segmentedControl.frame = CGRectMake(10,
                                        line5.frame.origin.y + line5.frame.size.height + 10,
                                        self.view.frame.size.width - 10*2,
                                        segmentSize);
    segmentedControl.selectedSegmentIndex = [[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue];
    segmentedControl.tintColor = [Common colorWithHex:@"#4d94e9"];
    [segmentedControl addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.enabled = [[Common getUserDefaultsForKey:EYE_SWITCH] boolValue];
    [scrollView addSubview:segmentedControl];
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, segmentedControl.frame.origin.y + segmentedControl.frame.size.height + 10, self.view.frame.size.width, 1)];
    line6.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line6];
    
    silderEMO = [[CLSSliderView alloc] initWithFrame:CGRectMake(0,
                                                                line6.frame.origin.y + line6.frame.size.height,
                                                                self.view.frame.size.width,
                                                                sliderSize)];
    silderEMO.titleLabel.text = @"連続と判定する間隔";
    silderEMO.titleLabel.textColor = [UIColor lightGrayColor];
    silderEMO.valueLabel.text = [NSString stringWithFormat:@"%0.2f",[EyeMoveManager sharedInstance].timeDifRL];
    silderEMO.valueLabel.textColor = [UIColor lightGrayColor];
    silderEMO.slider.minimumValue = 0.1;
    silderEMO.slider.maximumValue = 1;
    silderEMO.slider.value = [EyeMoveManager sharedInstance].timeDifRL;
    silderEMO.slider.minimumTrackTintColor = [Common colorWithHex:@"#4d94e9"];
    [silderEMO.slider addTarget:self action:@selector(silderEMO:) forControlEvents:UIControlEventValueChanged];
    silderEMO.slider.enabled = [[Common getUserDefaultsForKey:EYE_SWITCH] boolValue];
    silderEMO.titleLabelSize = 120;
    [scrollView addSubview:silderEMO];
    
    UIView *line7 = [[UIView alloc] initWithFrame:CGRectMake(0, silderEMO.frame.origin.y + silderEMO.frame.size.height, self.view.frame.size.width, 1)];
    line7.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line7];
    
    // 首振り
    UILabel *neckModeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                      line7.frame.origin.y + line7.frame.size.height + sectionMargin,
                                                                      self.view.frame.size.width - 10*2,
                                                                      20)];
    neckModeLabel.text = @"首振りの設定";
    neckModeLabel.textColor = [UIColor whiteColor];
    neckModeLabel.font = [UIFont boldSystemFontOfSize:14];
    [scrollView addSubview:neckModeLabel];
    
    UIView *line8 = [[UIView alloc] initWithFrame:CGRectMake(0, neckModeLabel.frame.origin.y + neckModeLabel.frame.size.height, self.view.frame.size.width, 1)];
    line8.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line8];
    
    UILabel *neckSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                         line8.frame.origin.y + line8.frame.size.height,
                                                                         200,
                                                                         switchSize)];
    neckSwitchLabel.text = @"首振りモード";
    neckSwitchLabel.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:neckSwitchLabel];
    
    neckSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 70,
                                                            line8.frame.origin.y + line8.frame.size.height + (switchSize-30)/2,
                                                            self.view.frame.size.width/4,
                                                            switchSize)];
    neckSwitch.on = [[Common getUserDefaultsForKey:NECK_SWITCH] boolValue];
    [neckSwitch addTarget:self action:@selector(neckSwitch:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:neckSwitch];
    
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(0, neckSwitchLabel.frame.origin.y + neckSwitchLabel.frame.size.height, self.view.frame.size.width, 1)];
    line9.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line9];
    
    silderNO = [[CLSSliderView alloc] initWithFrame:CGRectMake(0,
                                                               line9.frame.origin.y + line9.frame.size.height,
                                                               self.view.frame.size.width,
                                                               sliderSize)];
    silderNO.titleLabel.text = @"連続と判定する間隔";
    silderNO.titleLabel.textColor = [UIColor lightGrayColor];
    silderNO.valueLabel.text = [NSString stringWithFormat:@"%0.2f",[NeckManager sharedInstance].yawPeackTimeDif];
    silderNO.valueLabel.textColor = [UIColor lightGrayColor];
    silderNO.slider.minimumValue = 0.1;
    silderNO.slider.maximumValue = 1;
    silderNO.slider.value = [NeckManager sharedInstance].yawPeackTimeDif;
    silderNO.slider.minimumTrackTintColor = [Common colorWithHex:@"#4d94e9"];
    [silderNO.slider addTarget:self action:@selector(silderNO:) forControlEvents:UIControlEventValueChanged];
    silderNO.slider.enabled = [[Common getUserDefaultsForKey:NECK_SWITCH] boolValue];
    silderNO.titleLabelSize = 120;
    [scrollView addSubview:silderNO];
    
    UIView *line10 = [[UIView alloc] initWithFrame:CGRectMake(0, silderNO.frame.origin.y + silderNO.frame.size.height, self.view.frame.size.width, 1)];
    line10.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line10];
  
    // まばたき
    UILabel *blinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                       line10.frame.origin.y + line10.frame.size.height + sectionMargin,
                                                                       self.view.frame.size.width - 10*2,
                                                                       20)];
    blinkLabel.text = @"まばたきの設定";
    blinkLabel.textColor = [UIColor whiteColor];
    blinkLabel.font = [UIFont boldSystemFontOfSize:14];
    [scrollView addSubview:blinkLabel];
    
    UIView *line11 = [[UIView alloc] initWithFrame:CGRectMake(0, blinkLabel.frame.origin.y + blinkLabel.frame.size.height, self.view.frame.size.width, 1)];
    line11.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line11];
    
    silderBC = [[CLSSliderView alloc] initWithFrame:CGRectMake(0,
                                                               line11.frame.origin.y + line11.frame.size.height,
                                                               self.view.frame.size.width,
                                                               sliderSize)];
    silderBC.titleLabel.text = @"連続と判定する間隔";
    silderBC.titleLabel.textColor = [UIColor lightGrayColor];
    silderBC.valueLabel.text = [NSString stringWithFormat:@"%0.2f",[[Common getUserDefaultsForKey:Blink_EMC2] floatValue]];
    silderBC.valueLabel.textColor = [UIColor lightGrayColor];
    silderBC.slider.minimumValue = 0.1;
    silderBC.slider.maximumValue = 1;
    silderBC.slider.minimumTrackTintColor = [Common colorWithHex:@"#4d94e9"];
    silderBC.slider.value = [[Common getUserDefaultsForKey:Blink_EMC2] floatValue];
    [silderBC.slider addTarget:self action:@selector(silderBC:) forControlEvents:UIControlEventValueChanged];
    silderBC.titleLabelSize = 120;
    [scrollView addSubview:silderBC];
    
    UIView *line12 = [[UIView alloc] initWithFrame:CGRectMake(0, silderBC.frame.origin.y + silderBC.frame.size.height, self.view.frame.size.width, 1)];
    line12.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [scrollView addSubview:line12];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, line12.frame.origin.y + line12.frame.size.height + sectionMargin);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eyeSwitch:(UISwitch *)sw {
    DLog(@"eyeSwitch");
    [Common setUserDefaults:[NSNumber numberWithBool:sw.on] forKey:EYE_SWITCH];
    segmentedControl.enabled = sw.on;
    silderEMO.slider.enabled = sw.on;
}

- (void)neckSwitch:(UISwitch *)sw {
    DLog(@"neckSwitch");
    [Common setUserDefaults:[NSNumber numberWithBool:sw.on] forKey:NECK_SWITCH];
    silderNO.slider.enabled = sw.on;
}

- (void)segmentedControl:(UISegmentedControl *)sc {
    DLog(@"segmentedControl");
    [Common setUserDefaults:[NSNumber numberWithInt:(int)sc.selectedSegmentIndex] forKey:EYE_MOVE_MODE];
}

- (void)silderEMO:(UISlider *)slider {
    [EyeMoveManager sharedInstance].timeDifRL = [[NSString stringWithFormat:@"%.2f", slider.value] floatValue];
    [EyeMoveManager sharedInstance].timeDifUD = [[NSString stringWithFormat:@"%.2f", slider.value] floatValue];
    
    silderEMO.valueLabel.text = [NSString stringWithFormat:@"%0.2f",[EyeMoveManager sharedInstance].timeDifRL];
    [Common setUserDefaults:[NSNumber numberWithFloat:[EyeMoveManager sharedInstance].timeDifRL] forKey:TIME_DIF_EYE_MOVE];
}

- (void)silderBC:(UISlider *)slider {
    silderBC.valueLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    [Common setUserDefaults:[NSNumber numberWithFloat:[silderBC.valueLabel.text floatValue]] forKey:Blink_EMC2];
}

- (void)silderNO:(UISlider *)slider {
    [NeckManager sharedInstance].yawPeackTimeDif = [[NSString stringWithFormat:@"%.2f", slider.value] floatValue];
    [NeckManager sharedInstance].pitchPeackTimeDif = [[NSString stringWithFormat:@"%.2f", slider.value] floatValue];
    
    silderNO.valueLabel.text = [NSString stringWithFormat:@"%.2f", [NeckManager sharedInstance].yawPeackTimeDif];
    [Common setUserDefaults:[NSNumber numberWithFloat:[EyeMoveManager sharedInstance].timeDifRL] forKey:TIME_DIF_NECK];
}

- (void)tutorialUse {
    DLog(@"tutorialUse");
    TutorialUseViewController *viewController = [[TutorialUseViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.tabBarController presentViewController:viewController animated:NO completion:nil];
}

- (void)tutorialMode {
    DLog(@"tutorialMode");
    TutorialModeViewController *viewController = [[TutorialModeViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:viewController animated:NO completion:nil];
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
        }
        blinkDateDouble = now;
    }
}

//**************************************************
// EyeMoveManagerDelegate
//**************************************************

- (void)didPeakEyeMove:(EyeMoveManagerDirection)direction count:(int)count eyeMove:(int)eyeMove {
    DLog(@"didPeakEyeMove direction:%d count:%d eyeMove:%d",direction,count,eyeMove);
        
    if ( (count >= 4 && direction == EyeMoveManagerDirectionLeft)
        || (count >= 4 && direction == EyeMoveManagerDirectionRight) ) {
        DialogViewController *viewController = [[DialogViewController alloc] init];
        viewController.viewController = self;
        viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewController animated:YES completion:nil];
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
}
@end
