//
//  FallOutViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/08/02.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "FallOutViewController.h"

#import "FallOutGameViewController.h"

@interface FallOutViewController () <MEMEManagerRealTimeModeDataDelegate,UIScrollViewDelegate,EyeMoveManagerDelegate,NeckManagerDelegate> {
    UIScrollView *scrollView;
    UIButton *leftButton;
    UIButton *rightButton;
    
    CheckView *checkView;
}

@end

@implementation FallOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    statusH + naviH,
                                                                    self.view.frame.size.width - 20*2,
                                                                    40)];
    titleLabel.text = NSLocalizedString(@"落ちたらアウト！",nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#ef2880"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                          titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                                          self.view.frame.size.width - 20*2,
                                                                          50)];
    descriptionLabel.text = NSLocalizedString(@"まばたきでボールをジャンプ！\n落ちないようにボールをコントロールしよう！！",nil);
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor = [Common colorWithHex:@"#ffffff"];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 2;
    [self.view addSubview:descriptionLabel];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusH + naviH, self.view.frame.size.width, self.view.frame.size.height - (statusH + naviH + safeAreaBottom))];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30 + self.view.frame.size.width*i,
                                                                      scrollView.frame.size.height / 2 - 300/2,
                                                                      self.view.frame.size.width - 30*2,
                                                                      300)];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i == 1) {
            [button setImage:[UIImage imageNamed:NSLocalizedString(@"icon_start.png",nil)] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(gameStart) forControlEvents:UIControlEventTouchUpInside];
        }
        [scrollView addSubview:button];
        
       
        if (i == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.view.frame.size.width*i,
                                                                       button.frame.origin.y + button.frame.size.height + 20,
                                                                       self.view.frame.size.width - 10*2,
                                                                       20)];
            label.font = [UIFont systemFontOfSize:18.0];
            label.textAlignment = NSTextAlignmentCenter;
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString: @"Back"];
            [attributedText addAttribute:NSKernAttributeName
                                   value:[NSNumber numberWithFloat:5]
                                   range:NSMakeRange(0, attributedText.length)];
            label.attributedText = attributedText;
            label.textColor = [Common colorWithHex:@"#ffffff"];
            [scrollView addSubview:label];
        }
        else if (i == 1) {
            UILabel *actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.view.frame.size.width*i,
                                                                             button.frame.origin.y - 20,
                                                                             self.view.frame.size.width - 10*2,
                                                                             20)];
            actionLabel.text = NSLocalizedString(@"まばたき2回でスタート",nil);
            actionLabel.font = [UIFont systemFontOfSize:14];
            actionLabel.textColor = [Common colorWithHex:@"#ffffff"];
            actionLabel.textAlignment = NSTextAlignmentCenter;
            [scrollView addSubview:actionLabel];
        }
    }
    
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20 + 44, 30, self.view.frame.size.height - (20 + 44))];
    [leftButton setImage:[UIImage imageNamed:@"arrow_left.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftScroll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 30, 20 + 44, 30, self.view.frame.size.height - (20 + 44))];
    [rightButton setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightScroll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];

    checkView = [[CheckView alloc] initWithFrame:CGRectMake(0,
                                                            self.view.frame.size.height - 70 - 10 - safeAreaBottom,
                                                            self.view.frame.size.width,
                                                            70)];
    [self.view addSubview:checkView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back {
    DLog(@"back")
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gameStart {
    DLog(@"gameStart")
    FallOutGameViewController *fallOutGameViewController = [[FallOutGameViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fallOutGameViewController];
    [self presentViewController:navigationController animated:NO completion:nil];
}

- (void)leftScroll {
    DLog(@"leftScroll")
    leftButton.enabled = NO;
    rightButton.enabled = NO;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x - scrollView.frame.size.width, 0) animated:YES];
}

- (void)rightScroll {
    DLog(@"rightScroll")
    leftButton.enabled = NO;
    rightButton.enabled = NO;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + scrollView.frame.size.width, 0) animated:YES];
}

- (void)left:(int)move {
    DLog(@"left move:%d",move)
    CGFloat newX = scrollView.contentOffset.x - scrollView.frame.size.width * move;
    if (newX < 0) {
        newX = 0;
    }
    [scrollView setContentOffset:CGPointMake(newX, 0) animated:YES];
}

- (void)right:(int)move {
    DLog(@"right move:%d",move)
    CGFloat newX = scrollView.contentOffset.x + scrollView.frame.size.width * move;
    if (newX > scrollView.frame.size.width*1) {
        newX = scrollView.frame.size.width*1;
    }
    [scrollView setContentOffset:CGPointMake(newX, 0) animated:YES];
}

- (void)up:(int)move {
    // 今回は使用しない
}
- (void)down:(int)move {
    // 今回は使用しない
}

//**************************************************
// UIScrollViewDelegate
//**************************************************

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (scrollView.contentOffset.x + (0.5*scrollView.bounds.size.width)) / scrollView.bounds.size.width + 1;
    if (page == 1) {
        leftButton.hidden = YES;
        rightButton.hidden = NO;
    }
    else if (page == 2) {
        leftButton.hidden = NO;
        rightButton.hidden = YES;
    }
    else {
        leftButton.hidden = NO;
        rightButton.hidden = NO;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    DLog(@"scrollViewDidEndScrollingAnimation")
    leftButton.enabled = YES;
    rightButton.enabled = YES;
}


//**************************************************
// MEMEManagerRealTimeModeDataDelegate
//**************************************************

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    [super memeRealTimeModeDataReceived:data];
    
    if ([[Common getUserDefaultsForKey:EYE_SWITCH] boolValue]) {
        [[EyeMoveManager sharedInstance] memeRealTimeModeDataReceived:data];
        
        if (data.eyeMoveLeft == 1) {
            [checkView setCheckHighlight:checkView.left1];
        }
        else if (data.eyeMoveLeft == 2) {
            [checkView setCheckHighlight:checkView.left2];
        }
        else if (data.eyeMoveLeft == 3) {
            [checkView setCheckHighlight:checkView.left3];
        }
        else if (data.eyeMoveRight == 1) {
            [checkView setCheckHighlight:checkView.right1];
        }
        else if (data.eyeMoveRight == 2) {
            [checkView setCheckHighlight:checkView.right2];
        }
        else if (data.eyeMoveRight == 3) {
            [checkView setCheckHighlight:checkView.right3];
        }
    }
    
    if ([[Common getUserDefaultsForKey:NECK_SWITCH] boolValue]) {
        [[NeckManager sharedInstance] memeRealTimeModeDataReceived:data];
    }
    
    if (data.blinkSpeed) {
        double now = [[NSDate date] timeIntervalSince1970];
        
        [checkView setCheckHighlight:checkView.blink];
        
        if (now - blinkDateDouble <= [[Common getUserDefaultsForKey:Blink_EMC2] floatValue]) {
            
            self.view.backgroundColor = [Common colorWithHex:@"516577"];
            [NSThread sleepForTimeInterval:0.2];
            
            // 決定
            int page = (scrollView.contentOffset.x + (0.5*scrollView.bounds.size.width)) / scrollView.bounds.size.width + 1;
            if (page == 1) {
                [self pop];
            }
            else if (page == 2) {
                [self gameStart];
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
// 首振りの片道
- (void)peakNeck:(int)direction {
    DLog(@"peakNeck direction:%d",direction);
    
    if (direction == NeckManagerDirectionLeft) {
        [checkView setCheckHighlight:checkView.left1];
    }
    else if (direction == NeckManagerDirectionRight) {
        [checkView setCheckHighlight:checkView.right1];
    }
}


@end
