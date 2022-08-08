//
//  DYWindowPopHelperTestTool.m
//  huhuAudio
//
//  Created by Kevin Chen on 2021/11/26.
//  Copyright © 2021 XYWL. All rights reserved.
//

#import "DYWindowPopHelperTestTool.h"
#import "DYWindowPopHelper+Convenience.h"

@interface DYWindowPopHelperTestTool ()<DYWindowPopTestView1Delegate>

@end

@implementation DYWindowPopHelperTestTool

+ (void)initialWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    UIViewController *vc = [[UIViewController alloc] init];
    window.rootViewController = vc;

    [UIApplication sharedApplication].delegate.window = window;

    [DYWindowPopHelperTestTool performSelector:@selector(customTest) withObject:nil afterDelay:3.0];
}

+ (void)testShowImmediately {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [label setBackgroundColor:[UIColor redColor]];
    [label setText:@"DYWindowPopCoverPriorityNormal"];
    [label setTextColor:[UIColor whiteColor]];

    [DYWindowPopHelper dy_addWindowScreenView:label viewLevel:(DYWindowPopCoverPriorityNormal) viewMode:(TPSTaskWorkingStrategyStartImmediately) identifier:@"0" receiveEventInPopViewOnly:NO addCompleted:nil removeCompleted:nil];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 110, 200, 200)];
    [label1 setBackgroundColor:[UIColor blueColor]];
    [label1 setText:@"DYWindowPopCoverPriorityNormal1"];
    [label1 setTextColor:[UIColor whiteColor]];

    [DYWindowPopHelper dy_addWindowScreenView:label1 viewLevel:(DYWindowPopCoverPriorityHigh) viewMode:(TPSTaskWorkingStrategyStartImmediately) identifier:@"1" receiveEventInPopViewOnly:NO addCompleted:nil removeCompleted:nil];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 200, 200)];
    [label2 setBackgroundColor:[UIColor yellowColor]];
    [label2 setText:@"DYWindowPopCoverPriorityNormal2"];
    [label2 setTextColor:[UIColor whiteColor]];

    [DYWindowPopHelper dy_addWindowScreenView:label2 viewLevel:(DYWindowPopCoverPrioritySemiHigh) viewMode:(TPSTaskWorkingStrategyStartImmediately) identifier:@"2" receiveEventInPopViewOnly:NO addCompleted:nil removeCompleted:nil];
}

+ (void)testOccupy {
    DYWindowPopInfo *info1 = [[DYWindowNormalPopInfo alloc] init];
    DYWindowPopTestView1 *label1 = [[DYWindowPopTestView1 alloc] initWithFrame:CGRectMake(100, 110, 200, 200)];
    label1.delegate = self;
    [label1 setBackgroundColor:[UIColor redColor]];
    [label1 setTextColor:[UIColor whiteColor]];
    info1.view = label1;
    info1.identifier = @"11";
    info1.occupyPriority = DYWindowPopOccupyPriorityNormal + 10;
    info1.antiOccupyPriority = DYWindowPopAntiOccupyPriorityNormal + 11;
    info1.strategy = TPSTaskWorkingStrategyStartByTurns;
    
    label1.info = info1;
    
    [[DYWindowPopHelper sharedInstance] popWithPopView:info1];
    
    [self performSelector:@selector(testOccupy2) withObject:nil afterDelay:1.0];
    
}

+ (void)testOccupy2 {
    DYWindowPopInfo *info1 = [[DYWindowNormalPopInfo alloc] init];
    DYWindowPopTestView1 *label1 = [[DYWindowPopTestView1 alloc] initWithFrame:CGRectMake(100, 120, 200, 200)];
    label1.delegate = self;
    [label1 setBackgroundColor:[UIColor blueColor]];
    [label1 setTextColor:[UIColor whiteColor]];
    info1.view = label1;
    info1.identifier = @"22";
    info1.occupyPriority = DYWindowPopOccupyPriorityNormal + 12;
    info1.antiOccupyPriority = DYWindowPopAntiOccupyPriorityNormal + 10;
    info1.strategy = TPSTaskWorkingStrategyStartByTurns;

    label1.info = info1;

    [[DYWindowPopHelper sharedInstance] popWithPopView:info1];
    [self performSelector:@selector(testOccupy3) withObject:nil afterDelay:1.0];
}

+ (void)testOccupy3 {
    DYWindowPopInfo *info1 = [[DYWindowNormalPopInfo alloc] init];
    DYWindowPopTestView1 *label1 = [[DYWindowPopTestView1 alloc] initWithFrame:CGRectMake(100, 130, 200, 200)];
    label1.delegate = self;
    [label1 setBackgroundColor:[UIColor yellowColor]];
    [label1 setTextColor:[UIColor whiteColor]];
    info1.view = label1;
    info1.identifier = @"33";
    info1.occupyPriority = DYWindowPopOccupyPriorityNormal + 13;
    info1.antiOccupyPriority = DYWindowPopAntiOccupyPriorityNormal;
    info1.strategy = TPSTaskWorkingStrategyStartByTurns;

    label1.info = info1;

    [[DYWindowPopHelper sharedInstance] popWithPopView:info1];
}

+ (DYWindowPopInfo *)createWithStategy:(TPSTaskWorkingStrategy)strategy occupy:(DYWindowPopOccupyPriority)occupy antiOccupy:(DYWindowPopAntiOccupyPriority)antiOccupy cover:(DYWindowPopCoverPriority)cover antiCover:(DYWindowPopAntiCoverPriority)antiCover identifier:(NSInteger)identifier  {
    
    NSArray <UIColor *>*colors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
    
    DYWindowPopInfo *info1 = [[DYWindowNormalPopInfo alloc] init];
    DYWindowPopTestView1 *label1 = [[DYWindowPopTestView1 alloc] initWithFrame:CGRectMake(identifier * 10, identifier * 10, 60, 60)];
    label1.delegate = self;
    [label1 setBackgroundColor:[colors objectAtIndex:identifier % [colors count]]];
    [label1 setTextColor:[UIColor whiteColor]];
    info1.view = label1;
    info1.identifier = [NSString stringWithFormat:@"%@",@(identifier)];
    info1.occupyPriority = occupy;
    info1.antiOccupyPriority = antiOccupy;
    
    info1.coverPriority = cover;
    info1.antiCoverPriority = antiCover;
    
    info1.strategy = strategy;
    label1.info = info1;
    
    
    return info1;
}

+ (DYWindowPopInfo *)popViewWithStategy:(TPSTaskWorkingStrategy)strategy occupy:(DYWindowPopOccupyPriority)occupy antiOccupy:(DYWindowPopAntiOccupyPriority)antiOccupy cover:(DYWindowPopCoverPriority)cover antiCover:(DYWindowPopAntiCoverPriority)antiCover {
    
    static NSInteger count = 0;
    DYWindowPopInfo *info = [self createWithStategy:strategy occupy:occupy antiOccupy:antiOccupy cover:cover antiCover:antiCover identifier:count];
    [[DYWindowPopHelper sharedInstance] popWithPopView:info];
    count ++;

    return info;
}

+ (void)customTest {
    
    DYWindowPopInfo *info1 = [self popViewWithStategy:(TPSTaskWorkingStrategyStartImmediately)
                      occupy:0 antiOccupy:0 cover:0 antiCover:0]; // red
    DYWindowPopInfo *info2 = [self popViewWithStategy:(TPSTaskWorkingStrategyStartImmediately)
                      occupy:0 antiOccupy:0 cover:0 antiCover:0]; // orange
    
    DYWindowPopInfo *info3 = [self popViewWithStategy:(TPSTaskWorkingStrategyStartImmediately)
                      occupy:0 antiOccupy:0 cover:0 antiCover:0]; // yellow
    
    DYWindowPopInfo *info4 = [self popViewWithStategy:(TPSTaskWorkingStrategyStartImmediately)
                      occupy:0 antiOccupy:0 cover:0 antiCover:0]; // green
    DYWindowPopInfo *info5 = [self popViewWithStategy:(TPSTaskWorkingStrategyStartImmediately)
                      occupy:0 antiOccupy:0 cover:0 antiCover:0]; // cyan
    
    DYWindowPopInfo *info6 = [self popViewWithStategy:(TPSTaskWorkingStrategyStartImmediately)
                      occupy:0 antiOccupy:0 cover:0 antiCover:0]; // blue

    DYWindowPopInfo *info7 = [self popViewWithStategy:(TPSTaskWorkingStrategyStartImmediately)
                      occupy:0 antiOccupy:0 cover:0 antiCover:0]; // purple
    
}

#pragma mark - DYWindowPopTestView1Delegate
+ (void)dyWindowPopTestView1DismissWithView:(DYWindowPopTestView1 *)view {
    [[DYWindowPopHelper sharedInstance] dismissWithPopView:view.info];
}

@end
