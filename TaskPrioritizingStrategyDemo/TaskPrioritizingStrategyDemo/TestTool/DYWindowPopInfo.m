//
//  DYWindowPopInfo.m
//  huhuAudio
//
//  Created by Kevin Chen on 2021/10/25.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import "DYWindowPopInfo.h"
#import "DYWindowPopMacro.h"

@implementation DYWindowPopInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _strategy = TPSTaskWorkingStrategyDefault;
        _tpsTaskIsAvailable = YES;
    }
    return self;
}

- (NSString *)description {
    NSInteger occupyPriority = DYWindowPopOccupyPriorityNormal;
    NSInteger antiOccupyPriority = DYWindowPopAntiOccupyPriorityNormal;
    NSInteger coverPriority = DYWindowPopCoverPriorityNormal;
    NSInteger antiCoverPriority = DYWindowPopAntiCoverPriorityNormal;

    if ([self respondsToSelector:@selector(tpsTaskOccupyPriority)]) {
        occupyPriority = [self tpsTaskOccupyPriority];
    }
    if ([self respondsToSelector:@selector(tpsTaskAntiOccupyPriority)]) {
        antiOccupyPriority = [self tpsTaskAntiOccupyPriority];
    }
    if ([self respondsToSelector:@selector(tpsTaskCoverPriority)]) {
        coverPriority = [self tpsTaskCoverPriority];
    }
    if ([self respondsToSelector:@selector(tpsTaskAntiCoverPriority)]) {
        antiCoverPriority = [self tpsTaskAntiCoverPriority];
    }
    
    NSString *showStrategy = nil;
    TPSTaskWorkingStrategy strategy = TPSTaskWorkingStrategyDefault;
    if ([self respondsToSelector:@selector(tpsTaskWorkingStategy)]) {
        strategy = [self tpsTaskWorkingStategy];
    }
    
    switch (strategy) {
        case TPSTaskWorkingStrategyStartByTurns:
        {
            showStrategy = @"抢占";
        }
            break;
        case TPSTaskWorkingStrategyStartImmediately:
        default: {
            showStrategy = @"覆盖";
        }
            break;
    }
    
    return [NSString stringWithFormat:@"C = %@, AC = %@, O = %@, AO = %@, S = %@, REO = %@, ID = %@", @(coverPriority), @(antiCoverPriority), @(occupyPriority), @(antiOccupyPriority), showStrategy, @(self.receiveEventInPopViewOnly), self.identifier];
}

#pragma mark - DYWindowPopView
- (TPSTaskWorkingStrategy)tpsTaskWorkingStategy {
    return self.strategy;
}

- (NSString *)tpsTaskIdentifier {
    return self.identifier;
}

/// 覆盖等级。等级越高，越能覆盖在上层，和“抗覆盖等级”联合起作用。。
- (NSInteger)tpsTaskCoverPriority {
    return self.coverPriority;
}

/// 抗覆盖等级。当A弹窗试图覆盖B弹窗的时候，如果A弹窗的“覆盖等级”小于等级B弹窗的“抗覆盖等级”，则不能覆盖，反之则可以覆盖。等级越高，越能抗覆盖。
- (NSInteger)tpsTaskAntiCoverPriority {
    return self.antiCoverPriority;
}

/// 抢占等级。等级越高，越能抢占，和“抗抢占等级”联合起作用。
- (NSInteger)tpsTaskOccupyPriority {
    return self.occupyPriority;
}

/// 抗抢占等级。当A弹窗试图抢占B弹窗的时候，如果A弹窗的“抢占等级”小于或等于等级B弹窗的“抗抢占等级”，则不能抢占，反之则可以抢占。等级越高，越能抗抢占。和“抢占等级”联合起作用。
- (NSInteger)tpsTaskAntiOccupyPriority {
    return self.antiOccupyPriority;
}

@synthesize tpsTaskIsAvailable = _tpsTaskIsAvailable;

@synthesize taskActionPerformChanged = _taskActionPerformChanged;

@end
