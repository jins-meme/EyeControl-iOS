//
//  FallOutGameViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/08/02.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "FallOutGameViewController.h"

#import "FallOutGameOverViewController.h"

#import "Player.h"
#import "Scaffold.h"

@interface FallOutGameViewController () <MEMEManagerRealTimeModeDataDelegate> {
    
    UITouch *touch;
    
    Player *player;
    NSMutableArray *playerArray;
    
    NSMutableArray *scaffoldArray;
    
    int score;
    
    NSTimer *timer;
    
    float brinkSpeed;
}

@end

@implementation FallOutGameViewController

- (void)loadView {
    [super loadView];
    
    playerArray = [[NSMutableArray alloc] init];
    scaffoldArray = [[NSMutableArray alloc] init];
    
    score = 0;
    brinkSpeed = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    statusH + naviH,
                                                                    self.view.frame.size.width - 20*2,
                                                                    40)];
    titleLabel.text = @"落ちたらアウト！";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#ef2880"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                          titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                                          self.view.frame.size.width - 20*2,
                                                                          50)];
    descriptionLabel.text = @"まばたきでボールをジャンプ！\n落ちないようにボールをコントロールしよう！！";
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor = [Common colorWithHex:@"#ffffff"];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 2;
    [self.view addSubview:descriptionLabel];
    
    // player
    player = [[Player alloc] initWithFrame:CGRectMake(50, 0, 30, 30)];
    player.backgroundColor = [UIColor clearColor];
    player.layer.cornerRadius = player.frame.size.width / 2;
    player.clipsToBounds = YES;
    player.layer.borderColor = [[Common colorWithHex:@"#ef2880"] CGColor];
    player.layer.borderWidth = 2.0f;
    [self.view addSubview:player];
    
    Scaffold *scaffold = [[Scaffold alloc] initWithFrame:CGRectMake(150,
                                                                    self.view.frame.size.height / 2 - 100 + (arc4random()%200),
                                                                    (arc4random()%50) + 100 + 50,
                                                                    5)];
    scaffold.backgroundColor = [Common colorWithHex:@"#ef2880"];
    [self.view addSubview:scaffold];
    [scaffoldArray addObject:scaffold];
    
    // タイマー
    CGFloat l = 1.0f / 60.0f;
    timer = [NSTimer
             timerWithTimeInterval:l
             target:self
             selector:@selector(loop:)
             userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int count = 0;
- (void)loop:(NSTimer *)timer_ {
    count++;
    
    // 足場の移動
    for (Scaffold *scaffold in scaffoldArray) {
        if (scaffold.flag) {
            if (scaffold.down) {
                scaffold.frame = CGRectMake(scaffold.frame.origin.x - player.speedX,
                                            scaffold.frame.origin.y + 3,
                                            scaffold.frame.size.width,
                                            scaffold.frame.size.height);
            }
            else {
                scaffold.frame = CGRectMake(scaffold.frame.origin.x - player.speedX,
                                            scaffold.frame.origin.y,
                                            scaffold.frame.size.width,
                                            scaffold.frame.size.height);
            }
        }
    }
    
    Scaffold *s = [scaffoldArray lastObject];
    if (s.frame.origin.x < self.view.frame.size.width) {
        CGFloat y = 0;
        while (!y) {
            y = s.frame.origin.y - 50 + (arc4random()%250);
            if (y < 75 || y > self.view.frame.size.height - 100) {
                y = 0;
            }
        }
        Scaffold *scaffold = [[Scaffold alloc] initWithFrame:CGRectMake(s.frame.origin.x + s.frame.size.width + (arc4random()%75) + 50,
                                                                        y,
                                                                        (arc4random()%100) + 50 + 60,
                                                                        5)];
        scaffold.backgroundColor = [Common colorWithHex:@"#ef2880"];
        [self.view addSubview:scaffold];
        [scaffoldArray addObject:scaffold];
    }
    
    
    // プレイヤーの移動
    if (player.flag) {
        
        // ジャンプかそのままか
        if (touch
            && player.jumpCount > 0) {
            player.speedVY = -(player.speedY * player.jumpPow);
            player.frame = CGRectMake(player.frame.origin.x,
                                      player.frame.origin.y + player.speedVY,
                                      player.frame.size.width,
                                      player.frame.size.height);
            player.jumpCount--;
            touch = nil;
        }
        else if (brinkSpeed
                 && player.jumpCount > 0) {
            player.speedVY = -brinkSpeed/15;
            player.frame = CGRectMake(player.frame.origin.x,
                                      player.frame.origin.y + player.speedVY,
                                      player.frame.size.width,
                                      player.frame.size.height);
            player.jumpCount--;
            brinkSpeed = 0;
        }
        else {
            player.frame = CGRectMake(player.frame.origin.x,
                                      player.frame.origin.y + player.speedVY,
                                      player.frame.size.width,
                                      player.frame.size.height);
            player.speedVY = player.speedVY + 0.3;
        }
        
        
        // 足場の判定
        for (Scaffold *scaffold in scaffoldArray) {
            if (scaffold.flag) {
                if (scaffold.frame.origin.y <= player.frame.origin.y + player.frame.size.height
                    && scaffold.frame.origin.y + player.speedVY >= player.frame.origin.y + player.frame.size.height
                    && ( (scaffold.frame.origin.x < player.frame.origin.x
                          && scaffold.frame.origin.x + scaffold.frame.size.width > player.frame.origin.x)
                        || (scaffold.frame.origin.x < player.frame.origin.x + player.frame.size.width
                            && scaffold.frame.origin.x + scaffold.frame.size.width > player.frame.origin.x + player.frame.size.width) )
                    ) {
                    
                    player.frame = CGRectMake(player.frame.origin.x,
                                              scaffold.frame.origin.y - player.frame.size.height,
                                              player.frame.size.width,
                                              player.frame.size.height);
                    
                    player.speedVY = player.speedY;
                    player.jumpCount = player.jumpCountMax;
                    
                    scaffold.down = YES;
                    
                    if (!scaffold.score) {
                        scaffold.score = YES;
                        score = score + 1;
                    }
                }
                else {
                    
                }
            }
        }
    }
    
    // ゲームオーバー
    if (player.frame.origin.y + player.frame.size.height > self.view.frame.size.height
        || player.frame.origin.x + player.frame.size.width < 0) {
        [timer invalidate];
        timer = nil;
        [self  performSelector:@selector(gameover) withObject:nil afterDelay:1];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touch = [touches anyObject];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (player.speedVY < 0) {
        player.speedVY = player.speedVY / 2;
    }
    touch = nil;
}

- (void)gameover {
    DLog(@"gameover")
    
    NSString *highScore = [Common getUserDefaultsForKey:FALL_OUT_HIGH_SCORE];
    // ハイスコア更新
    if ([highScore intValue] < score) {
        [Common setUserDefaults:[NSString stringWithFormat:@"%d",score] forKey:FALL_OUT_HIGH_SCORE];
    }
    
    FallOutGameOverViewController *fallOutGameOverViewController = [[FallOutGameOverViewController alloc] init];
    fallOutGameOverViewController.score = [NSString stringWithFormat:@"%d",score];
    fallOutGameOverViewController.highScore = [Common getUserDefaultsForKey:FALL_OUT_HIGH_SCORE];
    fallOutGameOverViewController.fallOutGameViewController = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fallOutGameOverViewController];
    [self presentViewController:navigationController animated:NO completion:nil];
}

- (void)clearScaffold {
    for (Scaffold *scaffold in scaffoldArray) {
        [scaffold removeFromSuperview];
    }
    [scaffoldArray removeAllObjects];
}

- (void)restart {
    
    score = 0;
    
    player.frame = CGRectMake(50, 0, 30, 30);
    player.speedVY = 0;
    
    Scaffold *scaffold = [[Scaffold alloc] initWithFrame:CGRectMake(150,
                                                                    self.view.frame.size.height / 2 - 100 + (arc4random()%200),
                                                                    (arc4random()%50) + 100 + 50,
                                                                    5)];
    scaffold.backgroundColor = [Common colorWithHex:@"#ef2880"];
    [self.view addSubview:scaffold];
    [scaffoldArray addObject:scaffold];
    
    // タイマー
    CGFloat l = 1.0f / 60.0f;
    timer = [NSTimer
             timerWithTimeInterval:l
             target:self
             selector:@selector(loop:)
             userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

//**************************************************
// MEMEManagerRealTimeModeDataDelegate
//**************************************************

- (void)memeRealTimeModeDataReceived:(MEMERealTimeData *)data {
    [super memeRealTimeModeDataReceived:data];
    
    if (timer) {
        brinkSpeed = data.blinkSpeed;
    }
}

@end
