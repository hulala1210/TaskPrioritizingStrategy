//
//  DYWindowPopTestView1.m
//  huhuAudio
//
//  Created by Kevin Chen on 2021/11/29.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import "DYWindowPopTestView1.h"
#import "DYWindowPopMacro.h"

@implementation DYWindowPopTestView1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:10.0];
        self.numberOfLines = 0;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setInfo:(DYWindowPopInfo *)info {
    
    _info = info;
    
    NSInteger occupyPriority = DYWindowPopOccupyPriorityNormal;
    NSInteger antiOccupyPriority = DYWindowPopAntiOccupyPriorityNormal;
    
    NSInteger coverPriority = DYWindowPopCoverPriorityNormal;
    NSInteger antiCoverPriority = DYWindowPopAntiCoverPriorityNormal;

    if ([info respondsToSelector:@selector(tpsTaskOccupyPriority)]) {
        occupyPriority = [info tpsTaskOccupyPriority];
    }
    if ([info respondsToSelector:@selector(tpsTaskAntiOccupyPriority)]) {
        antiOccupyPriority = [info tpsTaskAntiOccupyPriority];
    }
    if ([info respondsToSelector:@selector(tpsTaskCoverPriority)]) {
        coverPriority = [info tpsTaskCoverPriority];
    }
    if ([info respondsToSelector:@selector(tpsTaskAntiCoverPriority)]) {
        antiCoverPriority = [info tpsTaskAntiCoverPriority];
    }
    
    NSString *showStrategy = nil;
    TPSTaskWorkingStrategy strategy = TPSTaskWorkingStrategyDefault;
    if ([info respondsToSelector:@selector(tpsTaskWorkingStategy)]) {
        strategy = [info tpsTaskWorkingStategy];
    }
    
    switch (strategy) {
        case TPSTaskWorkingStrategyStartByTurns:
        {
            showStrategy = @"抢占";
        }
            break;
        case TPSTaskWorkingStrategyStartImmediately:
        default: {
            showStrategy = @"覆盖";
        }
            break;
    }
    
    self.text = [NSString stringWithFormat:@"C = %@, AC = %@, O = %@, AO = %@, S = %@ id = %@", @(coverPriority), @(antiCoverPriority), @(occupyPriority), @(antiOccupyPriority), showStrategy, info.identifier];
}

- (void)tapAction {
    if ([self.delegate respondsToSelector:@selector(dyWindowPopTestView1DismissWithView:)]) {
        [self.delegate dyWindowPopTestView1DismissWithView:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
