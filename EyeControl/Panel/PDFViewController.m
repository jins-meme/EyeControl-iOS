//
//  PDFViewController.m
//  EyeControl
//
//  Created by Celleus on 2017/08/22.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController () <MEMEManagerRealTimeModeDataDelegate,EyeMoveManagerDelegate,NeckManagerDelegate,UIWebViewDelegate,UIScrollViewDelegate>

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                    statusH + naviH,
                                                                    self.view.frame.size.width - 20*2,
                                                                    40)];
    titleLabel.text = @"PDFビューワー";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    CGFloat labelH = 40;
    CGFloat buttonH = 70;
    CGFloat bottomM = 10;
    
    UILabel *noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                   titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                                   self.view.frame.size.width - 20*2,
                                                                   self.view.frame.size.height - (titleLabel.frame.origin.y + titleLabel.frame.size.height +
                                                                                                  + buttonH + safeAreaBottom))];
    noneLabel.text = @"他のアプリからPDFファイルをこのアプリで開き、\nこの画面にPDFファイルを表示してください。";
    noneLabel.font = [UIFont systemFontOfSize:14];
    noneLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    noneLabel.numberOfLines = -1;
    noneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noneLabel];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                               titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                                               self.view.bounds.size.width,
                                                               self.view.frame.size.height - (titleLabel.frame.origin.y + titleLabel.frame.size.height + labelH + buttonH + safeAreaBottom + bottomM))];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webView.scrollView setTag:noDisableHorizontalScrollTag];
    [self.webView.scrollView setTag:noDisableVerticalScrollTag];
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                          self.webView.frame.origin.y + self.webView.frame.size.height,
                                                                          self.view.frame.size.width - 20*2,
                                                                          labelH)];
    descriptionLabel.text = @"視線移動でページを送ろう";
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    descriptionLabel.textColor = [Common colorWithHex:@"#52d0b0"];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:descriptionLabel];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height,
                                                                      self.view.frame.size.width / 2,
                                                                      buttonH)];
    [backButton setImage:[UIImage imageNamed:@"pdf_icon_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2,
                                                                         descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height,
                                                                         self.view.frame.size.width / 2,
                                                                         buttonH)];
    [forwardButton setImage:[UIImage imageNamed:@"pdf_icon_forward.png"] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardButton];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.pdfURL != nil && self.webView.hidden == YES) {
        CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)self.pdfURL);
        self.pdfPageCount = (int)CGPDFDocumentGetNumberOfPages(pdf);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.pdfURL];
        [self.webView loadRequest:request];
        self.webView.hidden = NO;
        
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
