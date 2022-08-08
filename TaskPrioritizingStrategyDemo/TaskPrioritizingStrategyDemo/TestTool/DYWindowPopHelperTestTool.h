//
//  DYWindowPopHelperTestTool.h
//  huhuAudio
//
//  Created by Kevin Chen on 2021/11/26.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYWindowPopTestView1.h"
#import "DYWindowPopMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYWindowPopHelperTestTool : NSObject

+ (void)initialWindow;

+ (void)testShowImmediately;
+ (void)testOccupy;

+ (void)customTest;

+ (DYWindowPopInfo *)createWithStategy:(TPSTaskWorkingStrategy)strategy occupy:(DYWindowPopOccupyPriority)occupy antiOccupy:(DYWindowPopAntiOccupyPriority)antiOccupy cover:(DYWindowPopCoverPriority)cover antiCover:(DYWindowPopAntiCoverPriority)antiCover identifier:(NSInteger)identifier;

@end

NS_ASSUME_NONNULL_END
