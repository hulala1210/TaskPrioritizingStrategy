//
//  TPSState.m
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/1/13.
//

#import "TPSState.h"

@implementation TPSState

- (instancetype)init {
    self = [super init];
    if (self) {
        _onWorkingTask = [[NSMutableArray alloc] init];
        _blockedTasks = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    TPSState *one = [[self.class alloc] init];
    one.onWorkingTask = [self.onWorkingTask mutableCopy];
    one.blockedTasks = [self.blockedTasks mutableCopy];
    one.relativeTask = self.relativeTask;
    one.previousState = self.previousState;
    one.nextState = self.nextState;
    return one;
}

#pragma mark - 调试工具方法
- (NSInteger)statesCount {
    NSInteger count = 0;
    TPSState *current = self;
    while (current) {
        count ++;
        current = current.previousState;
    }
    
    return count;
}

@end
