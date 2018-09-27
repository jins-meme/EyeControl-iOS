//
//  TouchOutGameViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/08/02.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "TouchOutGameViewController.h"

#import "TouchOutGameOverViewController.h"

#import "Player.h"
#import "Enemy.h"

@interface TouchOutGameViewController () <MEMEManagerRealTimeModeDataDelegate> {
    UITouch *touch;
    
    Player *player;
    NSMutableArray *playerArray;
    
    NSMutableArray *enemyArray;
    
    int score;
    UIView *swipe;
    
    NSTimer *timer;
}

@end

@implementation TouchOutGameViewController

- (void)loadView {
    [super loadView];
   
    playerArray = [[NSMutableArray alloc] init];
    enemyArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    statusH + naviH,
                                                                    self.view.frame.size.width - 20*2,
                                                                    40)];
    titleLabel.text = NSLocalizedString(@"触れたらアウト！",nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#ef2880"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                          titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                                          self.view.frame.size.width - 20*2,
                                                                          50)];
    descriptionLabel.text = NSLocalizedString(@"首を傾けてボールをコントロール！\n落ちてくるボールをかわし続けよう！！",nil);
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor = [Common colorWithHex:@"#ffffff"];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 2;
    [self.view addSubview:descriptionLabel];
    
    // player
    player = [[Player alloc] initWithFrame:CGRectMake( (self.view.frame.size.width - 30)/2 , self.view.frame.size.height - 40 - 30 -1, 30, 30)];
    player.backgroundColor = [Common colorWithHex:@"#ef2880"];
    player.layer.cornerRadius = player.frame.size.width / 2;
    player.clipsToBounds = YES;
    [self.view addSubview:player];
    
    // Enemy
    CGFloat size = arc4random()%118+10;
    int x = (self.view.frame.size.width-size);
    Enemy *enemy = [[Enemy alloc] initWithFrame:CGRectMake(arc4random()%x,
                                                           -size,
                                                           size,
                                                           size)];
    [self.view addSubview:enemy];
    [enemyArray addObject:enemy];
    
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
    
    // プレイヤー移動
    if (touch) {
        CGPoint location = [touch locationInView:self.view];
        player.frame = CGRectMake(location.x - (player.frame.size.width/2),
                                  player.frame.origin.y,
                                  player.frame.size.width,
                                  player.frame.size.height);
    }
    
    // 敵の移動
    for (Enemy *enemy in enemyArray) {
        
        if (enemy.flag) {
            enemy.frame = CGRectMake(enemy.frame.origin.x,
                                     enemy.frame.origin.y + 3,
                                     enemy.frame.size.width,
                                     enemy.frame.size.height);
            
            if (self.view.frame.size.height < enemy.frame.origin.y - enemy.frame.size.height/2) {
                enemy.flag = NO;
                enemy.hidden = YES;
            }
        }
    }
    
    // 敵の追加
    if (count % 10 == 0) {
        for (int i = 0; i < 5; i++) {
            BOOL addFlag = YES;
            int size = arc4random()%118+10;
            int x = (self.view.frame.size.width-size);
            Enemy *enemy = [[Enemy alloc] initWithFrame:CGRectMake(arc4random()%x,
                                                                   -size,
                                                                   size,
                                                                   size)];
            for (Enemy *enemy_ in enemyArray) {
                if (enemy.flag) {
                    CGFloat x = ((enemy_.frame.origin.x+enemy_.frame.size.width/2) - (enemy.frame.origin.x+enemy.frame.size.width/2))*((enemy_.frame.origin.x+enemy_.frame.size.width/2) - (enemy.frame.origin.x+enemy.frame.size.width/2));
                    CGFloat y = ((enemy_.frame.origin.y+enemy_.frame.size.width/2) - (enemy.frame.origin.y+enemy.frame.size.width/2))*((enemy_.frame.origin.y+enemy_.frame.size.width/2) - (enemy.frame.origin.y+enemy.frame.size.width/2));
                    CGFloat r = ((enemy_.frame.size.width+128)/2 + enemy.frame.size.width/2)*((enemy_.frame.size.width+128)/2 + enemy.frame.size.width/2);
                    if (x + y <= r) {
                        addFlag = NO;
                    }
                }
            }
            
            if (addFlag) {
                [self.view addSubview:enemy];
                [enemyArray addObject:enemy];
                break;
            }
        }
    }
    
    [self.view bringSubviewToFront:swipe];
    
    // あたり判定
    for (Enemy *enemy in enemyArray) {
        if (enemy.flag) {
            CGFloat x = ((player.frame.origin.x+player.frame.size.width/2) - (enemy.frame.origin.x+enemy.frame.size.width/2))*((player.frame.origin.x+player.frame.size.width/2) - (enemy.frame.origin.x+enemy.frame.size.width/2));
            CGFloat y = ((player.frame.origin.y+player.frame.size.width/2) - (enemy.frame.origin.y+enemy.frame.size.width/2))*((player.frame.origin.y+player.frame.size.width/2) - (enemy.frame.origin.y+enemy.frame.size.width/2));
            CGFloat r = (player.frame.size.width/2 + enemy.frame.size.width/2)*(player.frame.size.width/2 + enemy.frame.size.width/2);
            CGFloat r1 = ((player.frame.size.width+10)/2 + enemy.frame.size.width/2)*((player.frame.size.width+10)/2 + enemy.frame.size.width/2);
            CGFloat r2 = ((player.frame.size.width+24)/2 + enemy.frame.size.width/2)*((player.frame.size.width+24)/2 + enemy.frame.size.width/2);
            CGFloat r3 = ((player.frame.size.width+60)/2 + enemy.frame.size.width/2)*((player.frame.size.width+60)/2 + enemy.frame.size.width/2);
            
            if ( x + y <= r) {
                // ゲームオーバー
                [timer invalidate];
                timer = nil;
                [self  performSelector:@selector(gameover) withObject:nil afterDelay:1.5];
            }
            else if ( x + y <= r1) {
                score = score + 10;
            }
            else if ( x + y <= r2) {
                score = score + 5;
            }
            else if ( x + y <= r3) {
                score = score + 1;
            }
        }
    }
}

// 自分のキャラクタ移動用のため ***********
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touch = [touches anyObject];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    touch = [touches anyObject];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    touch = nil;
}
// ***********************************

- (void)gameover {
    DLog(@"gameover")
    
    NSString *highScore = [Common getUserDefaultsForKey:TOUCH_OUT_HIGH_SCORE];
    // ハイスコア更新
    if ([highScore intValue] < score) {
        [Common setUserDefaults:[NSString stringWithFormat:@"%d",score] forKey:TOUCH_OUT_HIGH_SCORE];
    }
    
    TouchOutGameOverViewController *touchOutGameOverViewController = [[TouchOutGameOverViewController alloc] init];
    touchOutGameOverViewController.score = [NSString stringWithFormat:@"%d",score];
    touchOutGameOverViewController.highScore = [Common getUserDefaultsForKey:TOUCH_OUT_HIGH_SCORE];
    touchOutGameOverViewController.touchOutGameViewController = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:touchOutGameOverViewController];
    [self presentViewController:navigationController animated:NO completion:nil];
}

- (void)clearEnemy {
    for (Enemy *enemy in enemyArray) {
        [enemy removeFromSuperview];
    }
    [enemyArray removeAllObjects];
}
- (void)restart {
    
    score = 0;
    
    player.frame = CGRectMake(self.view.frame.size.width/2 - (player.frame.size.width/2),
                              player.frame.origin.y,
                              player.frame.size.width,
                              player.frame.size.height);
    
    CGFloat size = arc4random()%118+10;
    int x = (self.view.frame.size.width-size);
    Enemy *enemy = [[Enemy alloc] initWithFrame:CGRectMake(arc4random()%x,
                                                           -size,
                                                           size,
                                                           size)];
    [self.view addSubview:enemy];
    [enemyArray addObject:enemy];
    
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
        int x = self.view.frame.size.width/2 - (player.frame.size.width/2) - (data.roll * 5);
        if (x < 0) {
            x = 0;
        }
        else if (self.view.frame.size.width - (player.frame.size.width/2) < x ) {
            x = self.view.frame.size.width - (player.frame.size.width/2);
        }
        player.frame = CGRectMake(x,
                                  player.frame.origin.y,
                                  player.frame.size.width,
                                  player.frame.size.height);
    }
}


@end
