//
//  DYWindowPopHelperConfig.m
//  huhuAudio
//
//  Created by Kevin Chen on 2022/3/25.
//  Copyright © 2022 XYWL. All rights reserved.
//

#import "DYWindowPopHelperConfig.h"

@implementation DYWindowPopHelperConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        UIWindow *window = ((id<UIWindowSceneDelegate>)[UIApplication sharedApplication].connectedScenes.anyObject.delegate).window;
        self.popBackgroundView = window;
        
        self.normalCoverProperty = DYWindowPopHelperConfigDefaultCoverPriority;
        self.normalAntiCoverProperty = DYWindowPopHelperConfigDefaultAntiCoverPriority;
        self.normalOccupyProperty = DYWindowPopHelperConfigDefaultOccupyPriority;
        self.normalAntiOccupyProperty = DYWindowPopHelperConfigDefaultAntiOccupyPriority;
    }
    return self;
}

+ (instancetype)defaultConfig {
    DYWindowPopHelperConfig *config = [[DYWindowPopHelperConfig alloc] init];
    return config;
}

@end
