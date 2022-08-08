//
//  DYWindowPopHelper+Convenience.h
//  huhuAudio
//
//  Created by Kevin Chen on 2021/10/25.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import "DYWindowPopHelper.h"
#import "DYWindowNormalPopInfo.h"
#import "DYWindowPopMacro.h"
#import "TPSTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYWindowPopHelper (Convenience)

/// 加入弹窗
/// @param view 当前view
/// @param level 弹窗等级
/// @param viewMode 弹窗模式
/// @param identifier 这个view的唯一标识，如果相同则后来者会替换前面的
/// @param addCompleted 添加时显示的动画
/// @param removeCompleted 移除时添加的动画
+ (void)dy_addWindowScreenView:(UIView *)view
                     viewLevel:(DYWindowPopCoverPriority)level
                      viewMode:(TPSTaskWorkingStrategy)viewMode
                    identifier:(NSString *)identifier
     receiveEventInPopViewOnly:(BOOL)receiveEventInPopViewOnly
                  addCompleted:(void(^ __nullable)(void))addCompleted
               removeCompleted:(void(^ __nullable)(void))removeCompleted;

/// 删除弹窗
+ (void)dy_removeWithIdentifier:(NSString *)identifier;

/// 删除弹窗
+ (void)dy_removeView:(UIView *)view;



@end

NS_ASSUME_NONNULL_END
