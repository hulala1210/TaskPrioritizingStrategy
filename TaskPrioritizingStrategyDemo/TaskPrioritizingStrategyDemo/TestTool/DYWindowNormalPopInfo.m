//
//  DYWindowNormalPopInfo.m
//  huhuAudio
//
//  Created by Kevin Chen on 2021/11/30.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import "DYWindowNormalPopInfo.h"

@implementation DYWindowNormalPopInfo

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged:) name:@"stateChanged" object:nil];
    }
    return self;
}

- (void)stateChanged:(NSNotification *)note {
    [self setTpsTaskIsAvailable:NO];
}

@end
