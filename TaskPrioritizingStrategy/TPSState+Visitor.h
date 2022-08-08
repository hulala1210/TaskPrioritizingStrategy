//
//  TPSState+Visitor.h
//  TaskPrioritizingStrategy
//
//  Created by 123 on 2022/6/21.
//

#import "TPSState.h"

NS_ASSUME_NONNULL_BEGIN

@interface TPSState (Visitor)

/// 开启一个任务
/// @param task 弹窗
/// @param fromStopAnother 是否是因为停止一个任务而触发
- (TPSState *)beginTask:(id <TPSTask>)task fromStopAnother:(BOOL)fromStopAnother;


/// 停止一个任务
/// @param task 弹窗
/// @param triggeredByPublic 是否为外部调用触发
- (TPSState *)stopTask:(id <TPSTask>)task triggeredByPublic:(BOOL)triggeredByPublic;

@end

NS_ASSUME_NONNULL_END
