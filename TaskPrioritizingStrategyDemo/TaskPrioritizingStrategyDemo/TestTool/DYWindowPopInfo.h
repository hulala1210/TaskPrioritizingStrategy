//
//  DYWindowPopInfo.h
//  huhuAudio
//
//  Created by Kevin Chen on 2021/10/25.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPSTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYWindowPopInfo : NSObject <TPSTask>

@property (nonatomic, strong) UIView *view;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) TPSTaskWorkingStrategy strategy;
@property (nonatomic, assign) NSInteger coverPriority;
@property (nonatomic, assign) NSInteger antiCoverPriority;
@property (nonatomic, assign) NSInteger occupyPriority;
@property (nonatomic, assign) NSInteger antiOccupyPriority;
@property (nonatomic, assign) BOOL receiveEventInPopViewOnly;

@end

NS_ASSUME_NONNULL_END
