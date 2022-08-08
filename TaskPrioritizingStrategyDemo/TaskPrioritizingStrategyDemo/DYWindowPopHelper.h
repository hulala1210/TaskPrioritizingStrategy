//
//  DYWindowPopHelper.h
//  huhuAudio
//
//  Created by Kevin Chen on 2021/10/22.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYWindowPopInfo.h"
#import "DYWindowPopHelperConfig.h"
#import "DYWindowPopViewPerformer.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYWindowPopHelper : NSObject

@property (nonatomic, strong, readonly) DYWindowPopHelperConfig *config;

+ (instancetype)sharedInstance;
- (instancetype)initWithConfig:(DYWindowPopHelperConfig * __nullable)config viewPerformer:(id <DYWindowPopViewPerformer> __nullable)viewPerformer;

- (void)popWithPopView:(DYWindowPopInfo *)popView;

- (void)dismissWithPopView:(DYWindowPopInfo *)popView;
- (void)dismissWithIdentifier:(NSString *)identifier;
- (void)dismissAll;

- (DYWindowPopInfo *)popViewWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
