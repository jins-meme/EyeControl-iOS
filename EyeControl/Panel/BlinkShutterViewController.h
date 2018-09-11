//
//  BlinkShutterViewController.h
//  JINS
//
//  Created by Celleus on 2015/11/09.
//  Copyright © 2015年 Celleus. All rights reserved.
//

#import "CustomViewController.h"

@interface BlinkShutterViewController : CustomViewController {
    BOOL isRequireTakePhoto;
    BOOL isProcessingTakePhoto;
    void *bitmap;
}

@property (nonatomic, retain) UIImage *imageBuffer;

@end
