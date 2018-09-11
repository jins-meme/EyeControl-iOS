//
//  PDFViewController.h
//  EyeControl
//
//  Created by Celleus on 2017/08/22.
//  Copyright © 2017年 celleus. All rights reserved.
//

#import "CustomViewController.h"

@interface PDFViewController : CustomViewController

@property (nonatomic) NSURL *pdfURL;

@property (nonatomic) int pdfPageCount;
@property (nonatomic) int pdfPageHeight;
@property (nonatomic) int currentPageCount;
@property (nonatomic) UIWebView *webView;

- (void)first;
- (void)last;

@end
