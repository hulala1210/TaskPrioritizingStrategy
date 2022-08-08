//
//  TPSTaskJudgementTool.h
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TPSTask;

@interface TPSTaskJudgementTool : NSObject

+ (BOOL)canTask:(id <TPSTask>)task coverAnother:(id <TPSTask>)another;

+ (BOOL)canTask:(id <TPSTask>)task occupyAnother:(id <TPSTask>)another;

+ (BOOL)task:(id <TPSTask>)task equalAnother:(id <TPSTask>)another;

+ (BOOL)tasks:(NSArray <id<TPSTask>>*)tasks containsTask:(id<TPSTask>)task;


@end

NS_ASSUME_NONNULL_END
