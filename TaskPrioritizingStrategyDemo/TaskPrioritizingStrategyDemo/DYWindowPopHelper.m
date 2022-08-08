//
//  DYWindowPopHelper.m
//  huhuAudio
//
//  Created by Kevin Chen on 2021/10/22.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import "DYWindowPopHelper.h"
#import <YYKit/YYKit.h>
#import "TPSTaskPriorityFetcher.h"
#import "TPSTask.h"
#import "TPSState+Visitor.h"
#import "DYWindowPopViewPerformer.h"
#import "TPSTaskManager.h"

@interface DYWindowPopHelper () <TPSTaskManagerDelegate>

@property (nonatomic, strong) TPSTaskManager *taskManager;

@property (nonatomic, strong) DYWindowPopHelperConfig *config;
@property (nonatomic, strong) id <DYWindowPopViewPerformer> viewPerformer;

//@property (nonatomic, strong) TPSState *state;
//@property (nonatomic, strong) TPSState *tempLastState;

@end

@implementation DYWindowPopHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        _taskManager = [[TPSTaskManager alloc] init];
        [_taskManager setDelegate:self];
        _config = [DYWindowPopHelperConfig defaultConfig];
    }
    return self;
}

- (instancetype)initWithConfig:(DYWindowPopHelperConfig * __nullable)config viewPerformer:( id<DYWindowPopViewPerformer> __nullable)viewPerformer {
    self = [super init];
    if (self) {
        _taskManager = [[TPSTaskManager alloc] init];
        [_taskManager setDelegate:self];
        if (config == nil) {
            config = [DYWindowPopHelperConfig defaultConfig];
        }
        
        _config = config;
        _viewPerformer = viewPerformer;
    }
    return self;
}

+ (instancetype)sharedInstance {
    static DYWindowPopHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DYWindowPopHelper alloc] init];
    });
    
    return helper;
}

- (void)popWithPopView:(DYWindowPopInfo *)popView {
    [self.taskManager addTask:popView];
}

- (void)dismissWithPopView:(DYWindowPopInfo *)popView {
    [self.taskManager removeTask:popView];
}

- (void)dismissWithIdentifier:(NSString *)identifier {
    [self.taskManager removeTaskWithIdentifier:identifier];
}

- (void)dismissAll {
    [self.taskManager removeAllTask];
}

- (DYWindowPopInfo *)popViewWithIdentifier:(NSString *)identifier {
    return [self.taskManager taskWithIdentifier:identifier];
}

#pragma mark - TPSTaskManagerDelegate
- (void)tpsTaskManager:(TPSTaskManager *)manager stateChangedWithWorkingTask:(NSArray<id<TPSTask>> *)workingTask lastWorkingTask:(NSArray<id<TPSTask>> *)lastworkingTask {
    if ([self.viewPerformer respondsToSelector:@selector(dyWindowPopViewHelper:performingViews:lastPerformingViews:)]) {
        [self.viewPerformer dyWindowPopViewHelper:self performingViews:workingTask lastPerformingViews:lastworkingTask];
    }
}

@end
