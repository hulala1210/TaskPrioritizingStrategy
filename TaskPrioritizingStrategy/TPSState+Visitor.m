//
//  TPSState+Visitor.m
//  TaskPrioritizingStrategy
//
//  Created by Slim Chen on 2022/6/21.
//

#import "TPSState+Visitor.h"
#import <objc/runtime.h>
#import "TPSTaskPriorityFetcher.h"
#import "TPSTaskJudgementTool.h"

@implementation TPSState (Visitor)

static void * const tpsTaskSerialNumKey = "tpsTaskSerialNumKey";
static NSInteger tpsTaskStateTaskSerialNum = 0;

- (TPSState *)beginTask:(id <TPSTask>)task fromStopAnother:(BOOL)fromStopAnother {
    if (!fromStopAnother) {
        objc_setAssociatedObject(task, &tpsTaskSerialNumKey, @(tpsTaskStateTaskSerialNum++), OBJC_ASSOCIATION_RETAIN);
    }
    
    // 先分策略
    TPSTaskWorkingStrategy strategy = TPSTaskWorkingStrategyDefault;
    if ([task respondsToSelector:@selector(tpsTaskWorkingStategy)]) {
        strategy = [task tpsTaskWorkingStategy];
    }
    
    switch (strategy) {
        case TPSTaskWorkingStrategyStartByTurns:
        {
            return [self occupyHandleWithTask:task fromDismiss:fromStopAnother];
        }
            break;
        case TPSTaskWorkingStrategyStayUniquely: {
            return [self stayUniqueHandleWithTask:task fromDismiss:fromStopAnother];
        }
        case TPSTaskWorkingStrategyStartImmediately:
        default: {
            return [self coverHandleWithTask:task fromDismiss:fromStopAnother];
        }
            break;
    }
}

- (TPSState *)stopTask:(id <TPSTask>)task triggeredByPublic:(BOOL)triggeredByPublic {
    NSArray <id <TPSTask>> *lastOnWorkingTasks = [self.onWorkingTask copy];
    NSArray <id <TPSTask>> *lastBlockedTasks = [self.blockedTasks copy];

    TPSState *current = self;
    TPSState *finalState = nil;
    
    NSMutableArray <id<TPSTask>> *waitingToReleaseTasks = [[NSMutableArray alloc] init];
    
    while (current) {
        if ([TPSTaskJudgementTool tasks:current.onWorkingTask containsTask:task]) {
            [current.onWorkingTask removeObject:task];
        }
        
        if ([TPSTaskJudgementTool tasks:current.blockedTasks containsTask:task]) {
            [current.blockedTasks removeObject:task];
        }

        // 如果state中没有展示的页面，或者state关联popView就是要dismiss的popView，则把state中所有的block拿出来，再尝试pop一次。
        if (current.onWorkingTask.count == 0 || [TPSTaskJudgementTool task:current.relativeTask equalAnother:task]) {
            
            TPSState *relativeState = current;
            [waitingToReleaseTasks addObjectsFromArray:relativeState.blockedTasks];
            
            TPSState *relativeNextState = relativeState.nextState;
            TPSState *relativeProviousState = relativeState.previousState;
            
            relativeProviousState.nextState = relativeNextState;
            relativeNextState.previousState = relativeProviousState;
            
            if (!finalState) {
                finalState = relativeProviousState;
            }
            
        }
        
        if (!finalState) {
            finalState = current;
        }
        
        current = current.previousState;
    }
    
    NSAssert(finalState, @"%@ %s finalState 不应该为空", NSStringFromClass([self class]), __func__);
    
    // 按照弹出的顺序，给将要放出来的popView排好序
    [waitingToReleaseTasks sortUsingComparator:^NSComparisonResult(id<TPSTask>  _Nonnull obj1, id<TPSTask>  _Nonnull obj2) {
        NSInteger obj1Serial = [objc_getAssociatedObject(obj1, &tpsTaskSerialNumKey) integerValue];
        NSInteger obj2Serial = [objc_getAssociatedObject(obj2, &tpsTaskSerialNumKey) integerValue];
        
        if (obj1Serial > obj2Serial) {
            return NSOrderedDescending;
        }
        else if (obj1Serial < obj2Serial) {
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    while ([waitingToReleaseTasks firstObject]) {
        id <TPSTask> waitingToReleasePopView = [waitingToReleaseTasks firstObject];
        finalState = [finalState beginTask:waitingToReleasePopView fromStopAnother:YES];
        [waitingToReleaseTasks removeObjectAtIndex:0];
    }
    
    if ([task respondsToSelector:@selector(taskActionPerformChanged)]) {
        if ([TPSTaskJudgementTool tasks:lastOnWorkingTasks containsTask:task]) {
            if (task.taskActionPerformChanged) {
                task.taskActionPerformChanged(task, TPSTaskActionPerformStopFromWorking);
            }
            
//            [self.delegate dyWindowPopState:self popView:task willChangedWithPerform:(TPSTaskActionPerformStopFromWorking)];
        }
        else if ([TPSTaskJudgementTool tasks:lastBlockedTasks containsTask:task]) {
            if ([task respondsToSelector:@selector(taskActionPerformChanged)] && task.taskActionPerformChanged) {
                task.taskActionPerformChanged(task, TPSTaskActionPerformStopFromBlocked);
            }
            
//            [self.delegate dyWindowPopState:self popView:task willChangedWithPerform:(TPSTaskActionPerformStopFromBlocked)];
        }
    }
    
    return finalState;
}

// 处理覆盖逻辑
- (TPSState *)coverHandleWithTask:(id <TPSTask>)task fromDismiss:(BOOL)fromDismiss {
    NSArray <id <TPSTask>> *lastDisplayPopViews = [self.onWorkingTask copy];
    
    if (lastDisplayPopViews.count && [[lastDisplayPopViews firstObject] tpsTaskWorkingStategy] == TPSTaskWorkingStrategyStayUniquely) {
        return [self occupyHandleWithTask:task fromDismiss:YES];
    }
    
    TPSState *state = [self stopTask:task triggeredByPublic:NO];
    TPSState *newState = [state copy];
    newState.relativeTask = task;
    newState.previousState = state;
    state.nextState = newState;
    
   __block BOOL isAdded = NO;
   
   [newState.onWorkingTask enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([TPSTaskJudgementTool canTask:task coverAnother:obj]) {
           [newState.onWorkingTask insertObject:task atIndex:idx + 1];
           isAdded = YES;
           *stop = YES;
       }
   }];
   
    // 按序添加没有添加上，就有两种可能
    if (!isAdded) {
        
        // 第一种可能，是第一个进来的task，这个时候self.onWorkingTask.count 为 0
        if (newState.onWorkingTask.count == 0) {
            [newState.onWorkingTask addObject:task];
        }
        // 第二种可能，当前已经有若干正在工作的task，而新进来的task需要在这些task的最底下。
        else {
            [newState.onWorkingTask insertObject:task atIndex:0];
        }
        
        isAdded = YES;
    }
    
    if (!fromDismiss) {
        if ([TPSTaskJudgementTool tasks:newState.onWorkingTask containsTask:task]) {
            if ([TPSTaskJudgementTool task:newState.onWorkingTask.lastObject equalAnother:task]) {
                if ([task respondsToSelector:@selector(taskActionPerformChanged)] && task.taskActionPerformChanged) {
                    task.taskActionPerformChanged(task, TPSTaskActionPerformStartToTop);
                }
//                    [self.delegate dyWindowPopState:self popView:task willChangedWithPerform:(TPSTaskActionPerformStartToTop)];
            }
            else {
                if ([task respondsToSelector:@selector(taskActionPerformChanged)] && task.taskActionPerformChanged) {
                    task.taskActionPerformChanged(task, TPSTaskActionPerformStartToUnder);
                }
//                    [self.delegate dyWindowPopState:self popView:task willChangedWithPerform:(TPSTaskActionPerformStartToUnder)];
            }
        }
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id<TPSTask>  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return !([TPSTaskJudgementTool tasks:lastDisplayPopViews containsTask:evaluatedObject]) && ![TPSTaskJudgementTool task:evaluatedObject equalAnother:task];
        }];
        
        NSArray <id <TPSTask>>*newWindowsFromBlock = [newState.onWorkingTask filteredArrayUsingPredicate:predicate];
        
        [newWindowsFromBlock enumerateObjectsUsingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([TPSTaskJudgementTool task:obj equalAnother:newState.onWorkingTask.lastObject]) {
                
                if ([obj respondsToSelector:@selector(taskActionPerformChanged)] && obj.taskActionPerformChanged) {
                    obj.taskActionPerformChanged(obj, TPSTaskActionPerformBlockToWorkingTop);
                }
                
//                [self.delegate dyWindowPopState:self popView:obj willChangedWithPerform:(TPSTaskActionPerformBlockToWorkingTop)];
            }
            else {
                if ([obj respondsToSelector:@selector(taskActionPerformChanged)] && obj.taskActionPerformChanged) {
                    obj.taskActionPerformChanged(obj, TPSTaskActionPerformBlockToWorkingUnder);
                }
                
//                [self.delegate dyWindowPopState:self popView:obj willChangedWithPerform:(TPSTaskActionPerformBlockToWorkingUnder)];
            }
        }];
        
        id <TPSTask>lastTopPopView = [lastDisplayPopViews lastObject];
        id <TPSTask>currentTopPopView = [newState.onWorkingTask lastObject];
        
        if (![TPSTaskJudgementTool task:lastTopPopView equalAnother:currentTopPopView]) {
            if ([TPSTaskJudgementTool tasks:lastDisplayPopViews containsTask:currentTopPopView]) {
                
                if ([currentTopPopView respondsToSelector:@selector(taskActionPerformChanged)] && currentTopPopView.taskActionPerformChanged) {
                    currentTopPopView.taskActionPerformChanged(currentTopPopView, TPSTaskActionPerformWorkingUnderToTop);
                }
                
//                [self.delegate dyWindowPopState:self popView:currentTopPopView willChangedWithPerform:(TPSTaskActionPerformWorkingUnderToTop)];
            }
            if ([TPSTaskJudgementTool tasks:newState.onWorkingTask containsTask:lastTopPopView]) {
                
                if ([lastTopPopView respondsToSelector:@selector(taskActionPerformChanged)] && lastTopPopView.taskActionPerformChanged) {
                    lastTopPopView.taskActionPerformChanged(lastTopPopView, TPSTaskActionPerformWorkingTopToUnder);
                }
                
//                [self.delegate dyWindowPopState:self popView:lastTopPopView willChangedWithPerform:(TPSTaskActionPerformWorkingTopToUnder)];
            }
        }
    }
    
    return newState;
}

// 处理抢占逻辑
- (TPSState *)occupyHandleWithTask:(id <TPSTask>)task fromDismiss:(BOOL)fromDismiss {
    NSArray <id <TPSTask>> *lastDisplayPopViews = [self.onWorkingTask copy];
    TPSState *state = [self stopTask:task triggeredByPublic:NO];
    
    __block BOOL canOccupy = YES;
    __block id <TPSTask> blockingPopView = nil;
    
    [self.onWorkingTask enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![TPSTaskJudgementTool canTask:task occupyAnother:obj]) {
            canOccupy = NO;
            blockingPopView = obj;
            *stop = YES;
        }
    }];
    
    if (canOccupy) {
        TPSState *newState = [state copy];
        
        newState.relativeTask = task;
        newState.previousState = state;
        state.nextState = newState;
        newState.blockedTasks = [newState.onWorkingTask mutableCopy];
        
        [newState.onWorkingTask removeAllObjects];
        [newState.onWorkingTask addObject:task];
        
        if (fromDismiss) {
            
            if ([task respondsToSelector:@selector(taskActionPerformChanged)] && task.taskActionPerformChanged) {
                task.taskActionPerformChanged(task, TPSTaskActionPerformBlockToWorkingTop);
            }
            
//            [self.delegate dyWindowPopState:self popView:task willChangedWithPerform:(TPSTaskActionPerformBlockToWorkingTop)];
        }
        else {
            if ([task respondsToSelector:@selector(taskActionPerformChanged)] && task.taskActionPerformChanged) {
                task.taskActionPerformChanged(task, TPSTaskActionPerformStartToTop);
            }
//            [self.delegate dyWindowPopState:self popView:task willChangedWithPerform:(TPSTaskActionPerformStartToTop)];
        }
        
        [lastDisplayPopViews enumerateObjectsUsingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj respondsToSelector:@selector(taskActionPerformChanged)] && obj.taskActionPerformChanged) {
                obj.taskActionPerformChanged(obj, TPSTaskActionPerformWorkingToBlocked);
            }
            
//            [self.delegate dyWindowPopState:self popView:obj willChangedWithPerform:(TPSTaskActionPerformWorkingToBlocked)];
        }];
        
        return newState;
    }
    else {
        TPSState *current = self;
        while (current) {
            if ([TPSTaskJudgementTool task:current.relativeTask equalAnother:blockingPopView]) {
                [current.blockedTasks addObject:task];
                break;
            }
            current = current.previousState;
        }
        
        if ([task respondsToSelector:@selector(taskActionPerformChanged)] && task.taskActionPerformChanged) {
            task.taskActionPerformChanged(task, TPSTaskActionPerformStartToBlocked);
        }
        
//        if ([self.delegate respondsToSelector:@selector(dyWindowPopState:popView:willChangedWithPerform:)]) {
//            if (!fromDismiss) {
//                [self.delegate dyWindowPopState:self popView:task willChangedWithPerform:(TPSTaskActionPerformStartToBlocked)];
//            }
//        }
        
        return self;
    }

}

// 处理唯一任务抢占逻辑
- (TPSState *)stayUniqueHandleWithTask:(id <TPSTask>)task fromDismiss:(BOOL)fromDismiss {
    return [self occupyHandleWithTask:task fromDismiss:fromDismiss];
}

@end
