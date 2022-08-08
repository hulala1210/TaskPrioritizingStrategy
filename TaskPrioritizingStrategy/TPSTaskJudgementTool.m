//
//  TPSTaskJudgementTool.m
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/3/28.
//

#import "TPSTaskJudgementTool.h"
#import "TPSTask.h"
#import "TPSTaskPriorityFetcher.h"

@implementation TPSTaskJudgementTool

+ (BOOL)canTask:(id <TPSTask>)task coverAnother:(id <TPSTask>)another {
    NSInteger coverPriority = [TPSTaskPriorityFetcher fetchCoverPriorityWithTask:task];
    NSInteger antiCoverPriority = [TPSTaskPriorityFetcher fetchAntiCoverPriorityWithTask:another];
    
    return coverPriority >= antiCoverPriority;
}

+ (BOOL)canTask:(id <TPSTask>)task occupyAnother:(id <TPSTask>)another {
    NSInteger occupyPriority = [TPSTaskPriorityFetcher fetchOccupyPriorityWithTask:task];
    NSInteger antiOccupyPriority = [TPSTaskPriorityFetcher fetchAntiOccupyPriorityWithTask:another];
    
    return occupyPriority > antiOccupyPriority;
}

+ (BOOL)task:(id <TPSTask>)task equalAnother:(id <TPSTask>)another {
    
    NSString *popViewIdentifier = nil;
    if ([task respondsToSelector:@selector(tpsTaskIdentifier)]) {
        popViewIdentifier = [task tpsTaskIdentifier];
    }
    
    NSString *identifier = nil;
    if ([another respondsToSelector:@selector(tpsTaskIdentifier)]) {
        identifier = [another tpsTaskIdentifier];
    }
    
    if ([identifier isEqualToString:popViewIdentifier]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)tasks:(NSArray <id<TPSTask>>*)tasks containsTask:(id<TPSTask>)task {
    BOOL contain = NO;
    for (id<TPSTask> obj in tasks) {
        if ([self task:obj equalAnother:task]) {
            contain = YES;
            break;
        }
    }
    
    return contain;
}


@end
