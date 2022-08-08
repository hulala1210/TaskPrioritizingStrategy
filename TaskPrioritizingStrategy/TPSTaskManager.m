//
//  TPSTaskManager.m
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/8/7.
//

#import "TPSTaskManager.h"
#import "TPSState+Visitor.h"
#import "TPSTaskPriorityFetcher.h"
#import "TPSTaskJudgementTool.h"

@interface TPSTaskManager ()

@property (nonatomic, strong) TPSState *state;
@property (nonatomic, strong) TPSState *tempLastState;

@end

@implementation TPSTaskManager

static void * TPSTaskManagerKVOContext = "TPSTaskManagerKVOContext";

- (void)addTask:(id <TPSTask>)task {
    if (![self validityOfTask:task]) {
        return;
    }
        
    if (!self.state) {
        self.state = [[TPSState alloc] init];
    }

    [(NSObject *)task addObserver:self forKeyPath:NSStringFromSelector(@selector(tpsTaskIsAvailable)) options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:TPSTaskManagerKVOContext];
    
//    [(NSObject *)popView addObserverBlockForKeyPath:NSStringFromSelector(@selector(tpsTaskIsAvailable)) block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
//        @strongify(self);
//        if ([oldVal boolValue] == YES && [newVal boolValue] == NO) {
//            [self dismissWithPopView:weakPopView];
//        }
//
//    }];
    
    self.tempLastState = [self.state copy];
    self.state = [self.state beginTask:task fromStopAnother:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == TPSTaskManagerKVOContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(tpsTaskIsAvailable))]) {
            BOOL oldValue = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
            BOOL newValue = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (oldValue == YES && newValue == NO) {
                [self removeTask:(id <TPSTask>)object];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)removeTask:(id <TPSTask>)task {
    if (!task) {
        return;
    }
    
    [(NSObject *)task removeObserver:self forKeyPath:NSStringFromSelector(@selector(tpsTaskIsAvailable)) context:TPSTaskManagerKVOContext];
    
//    [(NSObject *)popView removeObserverBlocksForKeyPath:NSStringFromSelector(@selector(tpsTaskIsAvailable))];
    self.tempLastState = [self.state copy];
    self.state = [self.state stopTask:task triggeredByPublic:YES];
}

- (void)removeTaskWithIdentifier:(NSString *)identifier {
    id <TPSTask>task = [self taskWithIdentifier:identifier];
    [self removeTask:task];
}

- (void)removeAllTask {
    // 不能直接干掉整个链表清除，应该逐个PopView调用dismiss，释放KVO
    while (self.state.relativeTask) {
        id <TPSTask>blockedTask = self.state.blockedTasks.lastObject;
        if (blockedTask) {
            [self removeTask:blockedTask];
            continue;
        }
        
        id <TPSTask>relativeTask = self.state.relativeTask;
        if (relativeTask) {
            [self removeTask:relativeTask];
            continue;;
        }
    }
}

- (id <TPSTask>)taskWithIdentifier:(NSString *)identifier {
    
    __block id <TPSTask>task = nil;
    TPSState *currentState = self.state;
            
    while (currentState) {
        [currentState.onWorkingTask enumerateObjectsUsingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(tpsTaskIdentifier)]) {
                NSString *objId = [obj tpsTaskIdentifier];
                if ([objId isEqualToString:identifier]) {
                    task = obj;
                    *stop = YES;
                }
            }
        }];
        
        if (task) {
            break;
        }
        
        [currentState.blockedTasks enumerateObjectsUsingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(tpsTaskIdentifier)]) {
                NSString *objId = [obj tpsTaskIdentifier];
                if ([objId isEqualToString:identifier]) {
                    task = obj;
                    *stop = YES;
                }
            }
        }];
        
        if (task) {
            break;
        }
        
        currentState = currentState.previousState;
    }
        
    return task;
}

#pragma mark - Private
- (void)setState:(TPSState *)state {
    
    __block BOOL needRedisplay = NO;
    if (self.tempLastState.onWorkingTask.count == 0) {
        needRedisplay = YES;
    }
    else if (self.tempLastState.onWorkingTask.count != state.onWorkingTask.count) {
        needRedisplay = YES;
    }
    else {
        [self.tempLastState.onWorkingTask enumerateObjectsUsingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![TPSTaskJudgementTool task:obj equalAnother:[state.onWorkingTask objectAtIndex:idx]]) {
                needRedisplay = YES;
                *stop = YES;
                return;
            }
        }];
    }
    _state = state;
    if (needRedisplay) {
        if ([self.delegate respondsToSelector:@selector(tpsTaskManager:stateChangedWithWorkingTask:lastWorkingTask:)]) {
            [self.delegate tpsTaskManager:self stateChangedWithWorkingTask:self.state.onWorkingTask lastWorkingTask:self.tempLastState.onWorkingTask];
        }
    }
    
    self.tempLastState = nil;
}

- (NSString *)descriptionOfTask:(id <TPSTask>)task {
    NSInteger occupyPriority = [TPSTaskPriorityFetcher fetchCoverPriorityWithTask:task];
    NSInteger antiOccupyPriority = [TPSTaskPriorityFetcher fetchAntiCoverPriorityWithTask:task];
    NSInteger coverPriority = [TPSTaskPriorityFetcher fetchOccupyPriorityWithTask:task];
    NSInteger antiCoverPriority = [TPSTaskPriorityFetcher fetchAntiOccupyPriorityWithTask:task];

    NSString *showStrategy = nil;
    TPSTaskWorkingStrategy strategy = TPSTaskWorkingStrategyDefault;
    if ([task respondsToSelector:@selector(tpsTaskWorkingStategy)]) {
        strategy = [task tpsTaskWorkingStategy];
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
    
    NSString *identifier = nil;
    if ([task respondsToSelector:@selector(tpsTaskIdentifier)]) {
        identifier = [task tpsTaskIdentifier];
    }
    
    return [NSString stringWithFormat:@"C = %@, AC = %@, O = %@, AO = %@, S = %@, ID = %@", @(coverPriority), @(antiCoverPriority), @(occupyPriority), @(antiOccupyPriority), showStrategy, identifier];
}

- (BOOL)validityOfTask:(id <TPSTask>)task {
    BOOL isAvalaible = NO;
    if ([task respondsToSelector:@selector(tpsTaskIsAvailable)]) {
        isAvalaible = [task tpsTaskIsAvailable];
    }
    
    if (!isAvalaible) {
        return NO;
    }
    
    return YES;
}

@end
