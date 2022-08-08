//
//  TPSTask.h
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2021/10/22.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TPSTaskActionPerform) {

    TPSTaskActionPerformStartToBlocked, // 开始即阻塞
    TPSTaskActionPerformWorkingToBlocked, // 工作状态跳到阻塞状态
    
    TPSTaskActionPerformStartToTop, // 开始即工作在顶部
    TPSTaskActionPerformStartToUnder, // 开始即工作在非顶部
    
    TPSTaskActionPerformWorkingTopToUnder, // 顶部到非顶部
    TPSTaskActionPerformWorkingUnderToTop, // 非顶部到顶部
    
    TPSTaskActionPerformBlockToWorkingUnder, // 阻塞到非顶部
    TPSTaskActionPerformBlockToWorkingTop, // 阻塞到顶部
    
    TPSTaskActionPerformStopFromWorking, // StopFromWorking
    TPSTaskActionPerformStopFromBlocked, // StopFromBlocked

};

@protocol TPSTask;
typedef void (^ __nullable TPSTaskActionPerformChanged)(id <TPSTask> task, TPSTaskActionPerform perform);


typedef NS_ENUM(NSInteger, TPSTaskWorkingStrategy) {
    TPSTaskWorkingStrategyStartImmediately = 1, // 在没有TPSTaskWorkingStrategyStayUniquely正在工作的情况下，任务开始时使用覆盖规则。
    TPSTaskWorkingStrategyStartByTurns = 2, // 任务开始时使用抢占规则。
    TPSTaskWorkingStrategyStayUniquely = 3, // 任务开始时使用抢占规则，如果有这种规则的任务在工作的时候，所有企图用覆盖规则开始的任务在开始的时候，都会遵循抢占规则。
    
    TPSTaskWorkingStrategyDefault = TPSTaskWorkingStrategyStartImmediately,
};

@protocol TPSTask <NSObject>

@required

/// 标志着任务是否可用，默认为NO（不可用）。当一个不可用的任务企图开始时，会被忽略并丢弃。如果任务已经在工作，或者正在等待开始的时候，把该属性改成NO，会丢弃对应的任务。
@property (nonatomic, assign) BOOL tpsTaskIsAvailable;

@optional

/// 任务开始的时候所采用的策略（抢占/覆盖）
- (TPSTaskWorkingStrategy)tpsTaskWorkingStategy;

/// identifier，相同的identifier会被认为是同一个任务
- (NSString *)tpsTaskIdentifier;

/// 覆盖等级。等级越高，越能覆盖在上层，和“抗覆盖等级”联合起作用。覆盖和非覆盖只针对正在工作的Task生效。
- (NSInteger)tpsTaskCoverPriority;

/// 抢占等级。等级越高，越能抢占，和“抗抢占等级”联合起作用。抢占和非抢占只针对正在工作的Task生效。
- (NSInteger)tpsTaskOccupyPriority;

/// 抗覆盖等级。当A任务试图覆盖B任务的时候，如果A任务的“覆盖等级”小于等级B任务的“抗覆盖等级”，则不能覆盖，反之则可以覆盖。等级越高，越能抗覆盖。（
- (NSInteger)tpsTaskAntiCoverPriority;

/// 抗抢占等级。当A任务试图抢占B任务的时候，如果A任务的“抢占等级”小于或等于等级B任务的“抗抢占等级”，则不能抢占，反之则可以抢占。等级越高，越能抗抢占。和“抢占等级”联合起作用。
- (NSInteger)tpsTaskAntiOccupyPriority;

/// 任务变化的具体表现回调
@property (nonatomic, copy) TPSTaskActionPerformChanged taskActionPerformChanged;


@end

NS_ASSUME_NONNULL_END
