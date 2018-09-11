//
//  Common.m
//  Live
//
//  Created by Celleus on 2016/02/01.
//  Copyright © 2016年 Celleus. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (void)setUserDefaults:(id)value forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    
    if(value != nil){
        //保存
        [userDefaults setObject:data forKey:key];
    }
    else{
        //削除
        [userDefaults removeObjectForKey:key];
    }
    
    [userDefaults synchronize];
}

+ (id)getUserDefaultsForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:key];
    
    if(nil != data){
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

// hexカラー対応
+ (UIColor *)colorWithHex:(NSString *)colorCode
{
    return [self colorWithHex:colorCode alpha:1];
}

+ (UIColor *)colorWithHex:(NSString *)colorCode alpha:(CGFloat)alpha
{
    if ([[colorCode substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"]) {
        colorCode = [colorCode substringWithRange:NSMakeRange(1, colorCode.length - 1)];
    }
    
    if ([colorCode length] == 3) {
        NSMutableString *_colorCode = [[NSMutableString alloc] init];
        
        for (NSInteger i = 0; i < colorCode.length; i++) {
            [_colorCode appendString:[colorCode substringWithRange:NSMakeRange(i, 1)]];
            [_colorCode appendString:[colorCode substringWithRange:NSMakeRange(i, 1)]];
        }
        
        colorCode = [_colorCode copy];
    }
    
    NSString *hexCodeStr;
    const char *hexCode;
    char *endptr;
    CGFloat red, green, blue;
    
    for (NSInteger i = 0; i < 3; i++) {
        hexCodeStr = [NSString stringWithFormat:@"+0x%@", [colorCode substringWithRange:NSMakeRange(i * 2, 2)]];
        hexCode    = [hexCodeStr cStringUsingEncoding:NSASCIIStringEncoding];
        
        switch (i) {
            case 0:
                red   = strtol(hexCode, &endptr, 16);
                break;
                
            case 1:
                green = strtol(hexCode, &endptr, 16);
                break;
                
            case 2:
                blue  = strtol(hexCode, &endptr, 16);
                
            default:
                break;
        }
    }
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}


@end
