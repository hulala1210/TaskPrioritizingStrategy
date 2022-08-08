//
//  TPSTaskManager.h
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/8/7.
//

#import <Foundation/Foundation.h>
#import "TPSTask.h"

NS_ASSUME_NONNULL_BEGIN

@class TPSTaskManager;
@protocol TPSTaskManagerDelegate <NSObject>

- (void)tpsTaskManager:(TPSTaskManager *)manager stateChangedWithWorkingTask:(NSArray <id <TPSTask>>*)workingTask lastWorkingTask:(NSArray <id <TPSTask>>*)lastworkingTask;

@end

@interface TPSTaskManager : NSObject

@property (nonatomic, weak) id <TPSTaskManagerDelegate> delegate;

- (void)addTask:(id <TPSTask>)task;
- (void)removeTask:(id <TPSTask>)task;
- (void)removeTaskWithIdentifier:(NSString *)identifier;
- (void)removeAllTask;
- (id <TPSTask>)taskWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
