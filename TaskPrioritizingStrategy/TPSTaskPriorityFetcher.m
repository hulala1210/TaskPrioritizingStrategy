//
//  TPSTaskPriorityFetcher.m
//  TaskPrioritizingStrategy
//
//  Created by Kevin Chen on 2022/3/25.
//

#import "TPSTaskPriorityFetcher.h"
#import "TPSTask.h"

@implementation TPSTaskPriorityFetcher

+ (NSInteger)fetchCoverPriorityWithTask:(id <TPSTask>)task {
    NSInteger coverPriority = 500;
    if ([task respondsToSelector:@selector(tpsTaskCoverPriority)]) {
        coverPriority = [task tpsTaskCoverPriority];
    }
    return coverPriority;
}

+ (NSInteger)fetchAntiCoverPriorityWithTask:(id <TPSTask>)task {
    NSInteger antiCoverPriority = [self fetchCoverPriorityWithTask:task];
    if ([task conformsToProtocol:@protocol(TPSTask)] && [task respondsToSelector:@selector(tpsTaskAntiCoverPriority)]) {
        antiCoverPriority = [(id <TPSTask>)task tpsTaskAntiCoverPriority];
    }
    
    return antiCoverPriority;
}

+ (NSInteger)fetchOccupyPriorityWithTask:(id <TPSTask>)task {
    NSInteger occupyPriority = 500;
    if ([task respondsToSelector:@selector(tpsTaskOccupyPriority)]) {
        occupyPriority = [task tpsTaskOccupyPriority];
    }
    return occupyPriority;
}

+ (NSInteger)fetchAntiOccupyPriorityWithTask:(id <TPSTask>)task {
    NSInteger antiOccupyPriority= [self fetchOccupyPriorityWithTask:task];
    if ([task conformsToProtocol:@protocol(TPSTask)] && [task respondsToSelector:@selector(tpsTaskAntiOccupyPriority)]) {
        antiOccupyPriority = [(id <TPSTask>)task tpsTaskAntiOccupyPriority];
    }
    
    return antiOccupyPriority;
}

@end
