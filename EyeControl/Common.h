//
//  Common.h
//  JINS
//
//  Created by Celleus on 2016/02/01.
//  Copyright © 2016年 Celleus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject

+ (void)setUserDefaults:(id)value forKey:(NSString *)key;
+ (id)getUserDefaultsForKey:(NSString *)key;

// hexカラー対応
+ (UIColor *)colorWithHex:(NSString *)colorCode;
+ (UIColor *)colorWithHex:(NSString *)colorCode alpha:(CGFloat)alpha;

@end
