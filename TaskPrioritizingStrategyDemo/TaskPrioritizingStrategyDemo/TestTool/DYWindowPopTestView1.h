//
//  DYWindowPopTestView1.h
//  huhuAudio
//
//  Created by Kevin Chen on 2021/11/29.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYWindowPopInfo.h"

NS_ASSUME_NONNULL_BEGIN

@class DYWindowPopTestView1;
@protocol DYWindowPopTestView1Delegate <NSObject>

- (void)dyWindowPopTestView1DismissWithView:(DYWindowPopTestView1 *)view;

@end

@interface DYWindowPopTestView1 : UILabel

@property (weak, nonatomic) id <DYWindowPopTestView1Delegate> delegate;

@property (weak, nonatomic) DYWindowPopInfo *info;

@end

NS_ASSUME_NONNULL_END
