//
//  TPSState.h
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/1/13.
//

#import <Foundation/Foundation.h>
#import "TPSTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPSState : NSObject <NSCopying>


/// 当前状态下，正在展示的弹窗
@property (nonatomic, strong) NSMutableArray <id <TPSTask>> *onWorkingTask;


/// 上一个状态
@property (nonatomic, strong) TPSState * __nullable previousState;

/// 下一个状态
@property (nonatomic, weak) TPSState * __nullable nextState;

/// 关联的任务。每一个任务启动后生成的state，都会关联上这个任务。
@property (nonatomic, strong) id <TPSTask> relativeTask;

/// 当前状态下，被阻塞的任务。因为抢占优先级不够relativeTask的抗抢占优先级而被阻塞的任务。
@property (nonatomic, strong) NSMutableArray <id <TPSTask>> *blockedTasks;


#pragma mark - 调试工具方法
- (NSInteger)statesCount;

@end

NS_ASSUME_NONNULL_END
