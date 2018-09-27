//
//  TutorialModeViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/06/12.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "TutorialModeViewController.h"

@interface TutorialModeViewController () {
    UIView *contentView;
}

@end

@implementation TutorialModeViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height + 20, self.view.frame.size.width - 20*2, self.view.frame.size.height - 20*2)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10;
    contentView.clipsToBounds = YES;
    [self.view addSubview:contentView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, contentView.frame.size.width - 5*2, 44)];
    titleLabel.text = NSLocalizedString(@"モードの説明",nil);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor darkGrayColor];
    [contentView addSubview:titleLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                               contentView.frame.size.width - 10*2,
                                                               contentView.frame.size.height - (titleLabel.frame.origin.y + titleLabel.frame.size.height + 10 + 50))];
    label.text = NSLocalizedString(@"モード1: 往復以上（カウント2以上）の強度1で1回、強度2,3で2回反応します\nモード2: 往復以上（カウント2以上）強度1,2,3で1回反応します\nモード3: 往復以上（カウント2以上）強度2,3で1回反応します\nモード4: 片道以上（カウント1以上）の強度2,3で1回反応します\n※強度とは視線を動かした距離を3段階で判別、カウントとは左右または上下に途切れず何回連続で動かしたかにより判定されます。\n※視線移動はノイズにより誤判定が発生しやすい場合があります。あまり頭を動かさず、電極が確実に接地し強く押し付けすぎないように装着してください。",nil);
    label.numberOfLines = -1;
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:label];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             contentView.frame.size.height - 50 - 1,
                                                             contentView.frame.size.width,
                                                             1)];
    line1.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [contentView addSubview:line1];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height - 50, contentView.frame.size.width, 50)];
    [closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    [closeButton setTitleColor:[Common colorWithHex:@"#57e6be"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentView addSubview:closeButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                     }
                     completion:^(BOOL finish){
                         
                         [UIView animateWithDuration:0.2
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              contentView.frame = CGRectMake(20, 20, self.view.frame.size.width - 20*2, self.view.frame.size.height - 20*2);
                                          }
                                          completion:^(BOOL finish){
                                              
                                          }];
                         
                         
                     }];
}


- (void)close {
    DLog(@"close");
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.view.backgroundColor = [UIColor clearColor];
                         contentView.frame = CGRectMake(20,self.view.frame.size.height + 20, self.view.frame.size.width - 20*2, self.view.frame.size.height - 20*2);
                     }
                     completion:^(BOOL finish){
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
    
}
@end
