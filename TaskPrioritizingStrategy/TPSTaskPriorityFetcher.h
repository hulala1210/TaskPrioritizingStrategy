//
//  TPSTaskPriorityFetcher.h
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TPSTask;
@interface TPSTaskPriorityFetcher : NSObject

+ (NSInteger)fetchCoverPriorityWithTask:(id <TPSTask>)task;
+ (NSInteger)fetchAntiCoverPriorityWithTask:(id <TPSTask>)task;
+ (NSInteger)fetchOccupyPriorityWithTask:(id <TPSTask>)task;
+ (NSInteger)fetchAntiOccupyPriorityWithTask:(id <TPSTask>)task;

@end

NS_ASSUME_NONNULL_END
