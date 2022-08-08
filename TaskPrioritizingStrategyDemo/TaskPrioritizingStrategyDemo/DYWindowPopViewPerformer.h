//
//  DYWindowPopViewPerformer.h
//  huhuAudio
//
//  Created by Kevin Chen on 2022/3/25.
//  Copyright © 2022 XYWL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TPSTask;
@class DYWindowPopHelper;

@protocol DYWindowPopViewPerformer <NSObject>

- (void)dyWindowPopViewHelper:(DYWindowPopHelper *)helper performingViews:(NSArray <id <TPSTask>>*)performingViews lastPerformingViews:(NSArray <id <TPSTask>>*)lastPerformingViews;

@end

NS_ASSUME_NONNULL_END
