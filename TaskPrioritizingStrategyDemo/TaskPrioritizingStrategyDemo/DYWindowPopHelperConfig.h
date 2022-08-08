//
//  DYWindowPopHelperConfig.h
//  huhuAudio
//
//  Created by Kevin Chen on 2022/3/25.
//  Copyright © 2022 XYWL. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const DYWindowPopHelperConfigDefaultCoverPriority = 500;
static NSInteger const DYWindowPopHelperConfigDefaultAntiCoverPriority = 500;
static NSInteger const DYWindowPopHelperConfigDefaultOccupyPriority = 500;
static NSInteger const DYWindowPopHelperConfigDefaultAntiOccupyPriority = 500;

NS_ASSUME_NONNULL_BEGIN

@interface DYWindowPopHelperConfig : NSObject

/// 默认为nil，当为nil的时候，所有的弹窗会被add在window上。如果有值，则弹窗会add在该popBackgroundView上。
@property (nonatomic, weak) UIView *popBackgroundView;

@property (nonatomic, assign) NSInteger normalCoverProperty;
@property (nonatomic, assign) NSInteger normalAntiCoverProperty;
@property (nonatomic, assign) NSInteger normalOccupyProperty;
@property (nonatomic, assign) NSInteger normalAntiOccupyProperty;

+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
