//
//  PDFViewController.m
//  EyeControl
//
//  Created by Celleus on 2017/08/22.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController () <MEMEManagerRealTimeModeDataDelegate,EyeMoveManagerDelegate,NeckManagerDelegate,UIWebViewDelegate,UIScrollViewDelegate> {
    UILabel *titleLabel;
    UILabel *noneLabel;
    UILabel *descriptionLabel;
    UIButton *backButton;
    UIButton *forwardButton;
}

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                           statusH + naviH,
                                                           self.view.frame.size.width - 20*2,
                                                           40)];
    titleLabel.text = NSLocalizedString( @"PDFビューワー",nil);
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    CGFloat labelH = 30;
    CGFloat labelM = 10;
    CGFloat buttonH = 70;
    CGFloat bottonM = 10;
    
    noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                          titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                          self.view.frame.size.width - 20*2,
                                                          self.view.frame.size.height - (titleLabel.frame.origin.y + titleLabel.frame.size.height + labelH + labelM + buttonH + safeAreaBottom))];
    noneLabel.text = NSLocalizedString( @"他のアプリからPDFファイルをこのアプリで開き、\nこの画面にPDFファイルを表示してください。",nil);
    noneLabel.font = [UIFont systemFontOfSize:14];
    noneLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    noneLabel.numberOfLines = -1;
    noneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noneLabel];
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                 self.view.frame.size.height - (labelH + labelM + buttonH + safeAreaBottom),
                                                                 self.view.frame.size.width - 20*2,
                                                                 labelH)];
    descriptionLabel.text = NSLocalizedString( @"視線移動でページを送ろう",nil);
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:descriptionLabel];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                            descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + labelM,
                                                            self.view.frame.size.width / 2,
                                                            buttonH)];
    [backButton setImage:[UIImage imageNamed:NSLocalizedString(@"pdf_icon_back.png",nil)] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2,
                                                               descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + labelM,
                                                               self.view.frame.size.width / 2,
                                                               buttonH)];
    [forwardButton setImage:[UIImage imageNamed:NSLocalizedString(@"pdf_icon_forward.png",nil)] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardButton];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                               statusH + naviH,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height - (statusH + naviH))];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webView.scrollView setTag:noDisableHorizontalScrollTag];
    [self.webView.scrollView setTag:noDisableVerticalScrollTag];
    [self.view addSubview:self.webView];

    NSString *pdfUrlString = [Common getUserDefaultsForKey:PDF_URL];
    if (pdfUrlString) {
        DLog(@"pdfUrlString:%@",pdfUrlString);
        self.pdfPageCount = [[Common getUserDefaultsForKey:PDF_PAGE_COUNT] intValue];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pdfUrlString]];
        [self.webView loadRequest:request];

        self.webView.hidden = NO;
        
        titleLabel.hidden = YES;
        noneLabel.hidden = YES;
        descriptionLabel.hidden = YES;
        backButton.hidden = YES;
        forwardButton.hidden = YES;
    }
    else {
        self.webView.hidden = YES;
        
        titleLabel.hidden = NO;
        noneLabel.hidden = NO;
        descriptionLabel.hidden = NO;
        backButton.hidden = NO;
        forwardButton.hidden = NO;
    }
}

- (BOOL)shouldAutorotate {
    DLog(@"shouldAutorotate")
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    DLog(@"supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    DLog(@"willAnimateRotationToInterfaceOrientation interfaceOrientation%ld duration:%f",(long)interfaceOrientation,duration)
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait){
        // 縦（ホームボタンが下）
        DLog(@"UIInterfaceOrientationPortrait")
        [self layoutPortraitPortraitUpsideDown];
    }
    else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        // 縦（ホームボタンが上）
        DLog(@"UIInterfaceOrientationPortraitUpsideDown")
        [self layoutPortraitPortraitUpsideDown];
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        // 横（ホームボタンが左）
        DLog(@"UIInterfaceOrientationLandscapeLeft")
        [self layoutLeftRight];
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        // 横（ホームボタン右）
        DLog(@"UIInterfaceOrientationLandscapeRight")
        [self layoutLeftRight];
    }
}

- (void)layoutPortraitPortraitUpsideDown{
    DLog(@"layoutPortraitPortraitUpsideDown");
    CGFloat labelH = 30;
    CGFloat labelM = 10;
    CGFloat buttonH = 70;
    CGFloat bottonM = 10;
    
    titleLabel.frame = CGRectMake(20,
                                  statusH + naviH,
                                  self.view.frame.size.width - 20*2,
                                  40);
    
    noneLabel.frame = CGRectMake(20,
                                 titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                 self.view.frame.size.width - 20*2,
                                 self.view.frame.size.height - (titleLabel.frame.origin.y + titleLabel.frame.size.height + labelH + labelM + buttonH + safeAreaBottom));
    
    descriptionLabel.frame = CGRectMake(20,
                                        self.view.frame.size.height - (labelH + labelM + buttonH + safeAreaBottom),
                                        self.view.frame.size.width - 20*2,
                                        labelH);
    backButton.frame = CGRectMake(0,
                                  descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + labelM,
                                  self.view.frame.size.width / 2,
                                  buttonH);
    forwardButton.frame = CGRectMake(self.view.frame.size.width / 2,
                                     descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + labelM,
                                     self.view.frame.size.width / 2,
                                     buttonH);
    
    self.webView.frame = CGRectMake(0,
                                    statusH + naviH,
                                    self.view.frame.size.width,
                                    self.view.frame.size.height - (statusH + naviH));
}

- (void)layoutLeftRight {
    DLog(@"layoutLeftRight");
    CGFloat labelH = 30;
    CGFloat labelM = 10;
    CGFloat buttonH = 70;
    CGFloat bottonM = 10;
    
    titleLabel.frame = CGRectMake(20,
                                  naviH/3*2,
                                  self.view.frame.size.width - 20*2,
                                  40);
    
    noneLabel.frame = CGRectMake(20,
                                 titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                 self.view.frame.size.width - 20*2,
                                 self.view.frame.size.height - (titleLabel.frame.origin.y + titleLabel.frame.size.height + labelH + labelM + buttonH + safeAreaBottom));
    
    descriptionLabel.frame = CGRectMake(20,
                                        self.view.frame.size.height - (labelH + labelM + buttonH + safeAreaBottom),
                                        self.view.frame.size.width - 20*2,
                                        labelH);
    backButton.frame = CGRectMake(0,
                                  descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + labelM,
                                  self.view.frame.size.width / 2,
                                  buttonH);
    forwardButton.frame = CGRectMake(self.view.frame.size.width / 2,
                                     descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + labelM,
                                     self.view.frame.size.width / 2,
                                     buttonH);
    
    self.webView.frame = CGRectMake(safeAreaTop,
                                    naviH/3*2,
                                    self.view.frame.size.width - (safeAreaTop + safeAreaTop),
                                    self.view.frame.size.height - (naviH/2 + safeAreaBottom));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.pdfURL != nil) {
        DLog(@"self.pdfURL:%@",self.pdfURL)
        
        // PDFをNSDataに変換し、その後.pdfとしてドキュメントフォルダに保存 ----- -----
        NSData *pdfData = [NSData dataWithContentsOfURL:self.pdfURL];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
        NSString *dir = [paths objectAtIndex:0];
        dir = [dir stringByAppendingPathComponent:@"pdf"];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:dir]) {
            [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *path = [dir stringByAppendingPathComponent:@"tmp.pdf"];
        [pdfData writeToFile:path atomically:YES];
        
        DLog(@"path:%@",path)
        
        [Common setUserDefaults:path forKey:PDF_URL];
        // ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
        
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)self.pdfURL);
        self.pdfPageCount = (int)CGPDFDocumentGetNumberOfPages(pdf);
        
         [Common setUserDefaults:[NSNumber numberWithInt:self.pdfPageCount] forKey:PDF_PAGE_COUNT];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.pdfURL];
        [self.webView loadRequest:request];
        
        self.webView.hidden = NO;
        
        titleLabel.hidden = YES;
        noneLabel.hidden = YES;
        descriptionLabel.hidden = YES;
        backButton.hidden = YES;
        forwardButton.hidden = YES;
        
        self.pdfURL = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 最初
- (void)first {
    if (self.currentPageCount > 0) {
        [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

// 戻
- (void)back {
    DLog(@"back")
    if (self.currentPageCount > 0) {
        int page = self.currentPageCount - 1;
        [self.webView.scrollView setContentOffset:CGPointMake(0, page*self.pdfPageHeight) animated:YES];
    }
    else {
        [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
// 次
- (void)go {
    DLog(@"go")
    if (self.currentPageCount < self.pdfPageCount) {
        int page = self.currentPageCount;
        if (page*self.pdfPageHeight == self.webView.scrollView.contentOffset.y) {
            if (page+1 < self.pdfPageCount) {
                [self.webView.scrollView setContentOffset:CGPointMake(0, (page+1)*self.pdfPageHeight) animated:YES];
            }
            else {
                [self.webView.scrollView setContentOffset:CGPointMake(0, (page)*self.pdfPageHeight) animated:YES];
            }
        }
        else {
            [self.webView.scrollView setContentOffset:CGPointMake(0, page*self.pdfPageHeight) animated:YES];
        }
    }
}

// 最後
- (void)last {
    if (self.currentPageCount < self.pdfPageCount) {
        [self.webView.scrollView setContentOffset:CGPointMake(0, self.webView.scrollView.contentSize.height - self.webView.frame.size.height) animated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat contentHeight = webView.scrollView.contentSize.height;
    
    self.pdfPageHeight = contentHeight / self.pdfPageCount;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float verticalContentOffset = self.webView.scrollView.contentOffset.y;
    
    self.currentPageCount = ceilf(verticalContentOffset / self.pdfPageHeight);
    
    DLog(@"self.currentPageCount:%d",self.currentPageCount);
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
            // まばたきで動作するものは今の所ない
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
    else {
        
        // モード1
        if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 0) {
            if (count > 1) {
                if (direction == EyeMoveManagerDirectionLeft) {
                    [self go];
                }
                else if (direction == EyeMoveManagerDirectionRight) {
                    [self back];
                }
            }
        }
        // モード2
        else if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 1) {
            if (count > 1) {
                if (direction == EyeMoveManagerDirectionLeft) {
                    [self go];
                }
                else if (direction == EyeMoveManagerDirectionRight) {
                    [self back];
                }
            }
        }
        // モード3
        else if ([[Common getUserDefaultsForKey:EYE_MOVE_MODE] intValue] == 2) {
            if (count > 1) {
                if (direction == EyeMoveManagerDirectionLeft) {
                    [self go];
                }
                else if (direction == EyeMoveManagerDirectionRight) {
                    [self back];
                }
            }
        }
        // モード4
        else {
            if (direction == EyeMoveManagerDirectionLeft) {
                [self go];
            }
            else if (direction == EyeMoveManagerDirectionRight) {
                [self back];
            }
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
        
        if (direction == EyeMoveManagerDirectionLeft) {
            [self back];
        }
        else if (direction == EyeMoveManagerDirectionRight) {
            [self go];
        }
    }
}

@end
