//
//  TutorialUseViewController.m
//  EyeControl
//
//  Created by Celleus on 2018/06/12.
//  Copyright © 2018年 celleus. All rights reserved.
//

#import "TutorialUseViewController.h"

@interface TutorialUseViewController () {
    UIView *contentView;
}

@end

@implementation TutorialUseViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height + 20, self.view.frame.size.width - 20*2, self.view.frame.size.height - 20*2)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10;
    contentView.clipsToBounds = YES;
    [self.view addSubview:contentView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, contentView.frame.size.width - 5*2, 44)];
    titleLabel.text = @"使い方";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [contentView addSubview:titleLabel];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 60, 44)];
    [closeButton setTitle:@"閉じる" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:closeButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                               contentView.frame.size.width - 10*2,
                                                               contentView.frame.size.height - (titleLabel.frame.origin.y + titleLabel.frame.size.height) - 10)];
    label.text = @"(1)接続画面でJINS MEMEと接続\n・JINS MEMEの電源ボタンを2秒長押しし、LEDを青点滅させます\n・スマートフォンで接続待ちのJINS MEMEが表示されるのでタップして接続します\n\n(2)基本設定\n・視線、首振りをどちらでコントロールを行うかを選択します（両方をオンにすると競合する場合がありますので片方のみオンをおススメいたします）\n・モードを選択します（どのような動きで反応するかの詳細はモードのヘルプをご覧ください）\n\n(3)パネルを使用する\n・左右のコマンドによってカーソル（赤枠）が移動します\n・まばたきを2回連続で行うとカーソルが反転します\n・パネル１（左）、パネル２（中央）ではパネルをタップすると表示文字列を変更できます\n\n(4)PDFファイルを閲覧する\n・他のアプリ（Safari、ストレージアプリ等）から「アプリで開く」を選択するとEye Controlアプリアイコンが表示されますのでタップするとPDFファイルが本アプリ内で開きます\n・左右のコマンドによってページ送りができます\n\n(5)コントロールを呼び出す\n・左右の移動を4回以上連続で行うとコントロールが表示されます\n・呼び出しでカーソルを反転させると呼びたし音が鳴ります\n";
    label.numberOfLines = -1;
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    [contentView addSubview:label];
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
