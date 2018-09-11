//
//  UIImageView+Helper.m
//  Browser
//
//  Created by Celleus on 2016/12/05.
//  Copyright © 2016年 Celleus. All rights reserved.
//

#import "UIImageView+Helper.h"

@implementation UIImageView (Helper)

-(void)setAlpha:(CGFloat)alpha{
    if(self.superview.tag == noDisableVerticalScrollTag){
        if(alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin){
            if(self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width){
                UIScrollView *sc = (UIScrollView *)self.superview;
                if(sc.frame.size.height < sc.contentSize.height){
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    return;
                }
            }
        }
    }
    
    [super setAlpha:alpha];
}

@end
