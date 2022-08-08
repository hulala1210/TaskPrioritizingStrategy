//
//  ViewController.m
//  TaskPrioritizingStrategyDemo
//
//  Created by Kevin Chen on 2022/7/19.
//

#import "ViewController.h"
#import "DYWindowPopHelperTestController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DYWindowPopHelperTestController *vc = [[DYWindowPopHelperTestController alloc] init];
    [self addChildViewController:vc];
    UIView *view = vc.view;
    vc.view = nil;
    self.view = view;
    view.backgroundColor = [UIColor whiteColor];
}


@end
