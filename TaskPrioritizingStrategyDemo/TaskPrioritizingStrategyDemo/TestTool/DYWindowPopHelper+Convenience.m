//
//  DYWindowPopHelper+Convenience.m
//  huhuAudio
//
//  Created by Kevin Chen on 2021/10/25.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import "DYWindowPopHelper+Convenience.h"
#import "DYWindowPopHelper.h"
#import <objc/runtime.h>

@implementation DYWindowPopHelper (Convenience)

/// 加入弹窗
/// @param view 当前view
/// @param level 弹窗等级
/// @param viewMode 弹窗模式
/// @param identifier 这个view的唯一标识，如果相同则后来者会替换前面的
/// @param addCompleted 添加时显示的动画
/// @param removeCompleted 移除时添加的动画w
+ (void)dy_addWindowScreenView:(UIView *)view viewLevel:(DYWindowPopCoverPriority)level viewMode:(TPSTaskWorkingStrategy)viewMode identifier:(NSString *)identifier receiveEventInPopViewOnly:(BOOL)receiveEventInPopViewOnly addCompleted:(void(^ __nullable)(void))addCompleted removeCompleted:(void(^ __nullable)(void))removeCompleted {
    DYWindowPopInfo *info = [self createInfoWithView:view viewLevel:level viewMode:viewMode identifier:identifier receiveEventInPopViewOnly:receiveEventInPopViewOnly];
    [info setTaskActionPerformChanged:^(id<TPSTask>  _Nonnull info, TPSTaskActionPerform perform) {
        
        switch (perform) {
            case TPSTaskActionPerformStopFromWorking:
            {
                if (removeCompleted) {
                    removeCompleted();
                }
            }
                break;
            case TPSTaskActionPerformStopFromBlocked:
            {
                if (removeCompleted) {
                    removeCompleted();
                }
            }
                break;
            case TPSTaskActionPerformStartToTop:
            case TPSTaskActionPerformStartToUnder:
                
            case TPSTaskActionPerformBlockToWorkingUnder:
            case TPSTaskActionPerformBlockToWorkingTop: {
                if (addCompleted) {
                    addCompleted();
                }
            }
                break;
                
            case TPSTaskActionPerformStartToBlocked:
            case TPSTaskActionPerformWorkingToBlocked:
            case TPSTaskActionPerformWorkingTopToUnder:
            case TPSTaskActionPerformWorkingUnderToTop:
            default: {
                
            }
                break;
        }
        
    }];
    [[DYWindowPopHelper sharedInstance] popWithPopView:info];
}

/// 删除弹窗
+ (void)dy_removeWithIdentifier:(NSString *)identifier {
    DYWindowPopInfo *info = [[DYWindowPopHelper sharedInstance] popViewWithIdentifier:identifier];
    [[DYWindowPopHelper sharedInstance] dismissWithPopView:info];
    objc_setAssociatedObject(info.view, &dyWindowPopHelperInfoViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 删除弹窗
+ (void)dy_removeView:(UIView *)view {
    id <TPSTask>info = [self getDYWindowPopInfoWithView:view];
    [[DYWindowPopHelper sharedInstance] dismissWithPopView:info];
    objc_setAssociatedObject(view, &dyWindowPopHelperInfoViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


static void *dyWindowPopHelperInfoViewKey = "dyWindowPopHelperInfoViewKey";
+ (DYWindowPopInfo *)createInfoWithView:(UIView *)view viewLevel:(DYWindowPopCoverPriority)level viewMode:(TPSTaskWorkingStrategy)viewMode identifier:(NSString *)identifier receiveEventInPopViewOnly:(BOOL)receiveEventInPopViewOnly {
    DYWindowPopInfo *info = [[DYWindowNormalPopInfo alloc] init];
    info.view = view;
    info.strategy = viewMode;
    info.identifier = identifier;
    
    info.coverPriority = level;
    info.antiCoverPriority = level;
    
    info.occupyPriority = level;
    info.antiOccupyPriority = level;
    
    info.receiveEventInPopViewOnly = receiveEventInPopViewOnly;
    
    objc_setAssociatedObject(view, &dyWindowPopHelperInfoViewKey, info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return info;
}

+ (DYWindowPopInfo *)getDYWindowPopInfoWithView:(UIView *)view {
    DYWindowPopInfo *info = objc_getAssociatedObject(view, &dyWindowPopHelperInfoViewKey);
    return info;
}

@end
