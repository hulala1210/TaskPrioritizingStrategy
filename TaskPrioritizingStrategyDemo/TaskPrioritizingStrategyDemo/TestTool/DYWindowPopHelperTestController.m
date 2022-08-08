//
//  DYWindowPopHelperTestController.m
//  huhuAudio
//
//  Created by Kevin Chen on 2022/2/9.
//  Copyright © 2022 XYWL. All rights reserved.
//

#import "DYWindowPopHelperTestController.h"
#import <Masonry.h>
#import "DYWindowPopHelperTestTool.h"
#import "DYWindowPopHelper.h"

@interface DYWindowPopHelperTestController () <UITextFieldDelegate, DYWindowPopViewPerformer>

@property (strong, nonatomic) NSMutableString *log;
@property (strong, nonatomic) DYWindowPopHelper *testHelper;

@property (strong, nonatomic) UIView *baseView;

@property (strong, nonatomic) UISegmentedControl *strategySegmentControl;

@property (strong, nonatomic) UITextField *coverTextField;
@property (strong, nonatomic) UITextField *antiCoverTextField;
@property (strong, nonatomic) UITextField *occupyTextField;
@property (strong, nonatomic) UITextField *antiOccupyTextField;

@property (strong, nonatomic) UITextField *idTextField;

@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *clearButton;

@property (strong, nonatomic) UIButton *dismissButton;
@property (strong, nonatomic) UITextField *dismissIdTextField;

@property (strong, nonatomic) UIButton *viewLogButton;

@property (strong, nonatomic) UITextView *logTextView;

@end

@implementation DYWindowPopHelperTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.log = [[NSMutableString alloc] init];
    
    self.strategySegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Now", @"ByTurn", @"Unique"]];
    UIFont *font = [UIFont boldSystemFontOfSize:10.0];
    NSDictionary *attributes = @{NSFontAttributeName:font};
    [self.strategySegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.strategySegmentControl setSelectedSegmentIndex:0];
    
    [self.view addSubview:self.strategySegmentControl];
    [self.strategySegmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strategySegmentControl.superview).offset(100);
        make.centerX.equalTo(self.strategySegmentControl.superview);
    }];
    
    self.coverTextField = [[UITextField alloc] init];
    self.coverTextField.font = [UIFont systemFontOfSize:12];
    self.coverTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.coverTextField.delegate = self;
    [self.coverTextField setPlaceholder:@"Cover(int)"];
    
    self.antiCoverTextField = [[UITextField alloc] init];
    self.antiCoverTextField.font = [UIFont systemFontOfSize:12];
    self.antiCoverTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.antiCoverTextField.delegate = self;
    [self.antiCoverTextField setPlaceholder:@"A-Cover(int)"];
    
    self.occupyTextField = [[UITextField alloc] init];
    self.occupyTextField.font = [UIFont systemFontOfSize:12];
    self.occupyTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.occupyTextField.delegate = self;
    [self.occupyTextField setPlaceholder:@"Occupy(int)"];
    
    self.antiOccupyTextField = [[UITextField alloc] init];
    self.antiOccupyTextField.font = [UIFont systemFontOfSize:12];
    self.antiOccupyTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.antiOccupyTextField.delegate = self;
    [self.antiOccupyTextField setPlaceholder:@"A-Occupy(int)"];
    
    self.idTextField = [[UITextField alloc] init];
    self.idTextField.font = [UIFont systemFontOfSize:12];
    self.idTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.idTextField.delegate = self;
    [self.idTextField setPlaceholder:@"id(int)"];
    
    self.addButton = [UIButton buttonWithType:(UIButtonTypeContactAdd)];
    [self.addButton addTarget:self action:@selector(addAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.clearButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.clearButton setTitle:@"clear" forState:(UIControlStateNormal)];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.dismissButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.dismissButton setTitle:@"dismiss" forState:(UIControlStateNormal)];
    [self.dismissButton addTarget:self action:@selector(dismissAction) forControlEvents:(UIControlEventTouchUpInside)];

    self.dismissIdTextField = [[UITextField alloc] init];
    self.dismissIdTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.dismissIdTextField.delegate = self;
    [self.dismissIdTextField setPlaceholder:@"dismissId(int)"];
    
    self.viewLogButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.viewLogButton setTitle:@"viewLog" forState:(UIControlStateNormal)];
    [self.viewLogButton addTarget:self action:@selector(viewLogAction:) forControlEvents:(UIControlEventTouchUpInside)];


    UIStackView *createPopViewStackView = [[UIStackView alloc] init];
    [createPopViewStackView setSpacing:5.0];
    createPopViewStackView.alignment = UIStackViewAlignmentLeading;
    createPopViewStackView.distribution = UIStackViewDistributionEqualSpacing;
    [self.view addSubview:createPopViewStackView];
    [createPopViewStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strategySegmentControl.mas_bottom);
        make.left.equalTo(createPopViewStackView.superview).offset(0);
        make.right.equalTo(createPopViewStackView.superview).offset(0);
    }];
    [createPopViewStackView addArrangedSubview:self.coverTextField];
    [createPopViewStackView addArrangedSubview:self.antiCoverTextField];
    [createPopViewStackView addArrangedSubview:self.occupyTextField];
    [createPopViewStackView addArrangedSubview:self.antiOccupyTextField];
    [createPopViewStackView addArrangedSubview:self.idTextField];
    [createPopViewStackView addArrangedSubview:self.addButton];

    UIStackView *controlStackView = [[UIStackView alloc] init];
    [controlStackView setSpacing:5.0];
    controlStackView.alignment = UIStackViewAlignmentLeading;
    controlStackView.distribution = UIStackViewDistributionEqualSpacing;
    [self.view addSubview:controlStackView];
    [controlStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(controlStackView.superview).offset(0);
        make.right.equalTo(controlStackView.superview).offset(0);
        make.top.equalTo(createPopViewStackView.mas_bottom).offset(0);
    }];
    [controlStackView addArrangedSubview:self.clearButton];
    [controlStackView addArrangedSubview:self.dismissIdTextField];
    [controlStackView addArrangedSubview:self.dismissButton];
    [controlStackView addArrangedSubview:self.viewLogButton];
    
    self.baseView = [[UIView alloc] init];
    [self.baseView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.baseView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.baseView.mas_height);
        make.left.right.equalTo(self.baseView.superview);
        make.top.equalTo(controlStackView.mas_bottom);
    }];
    
}

- (void)addAction {
    TPSTaskWorkingStrategy strategy = TPSTaskWorkingStrategyStartImmediately;
    switch (self.strategySegmentControl.selectedSegmentIndex) {
        case 0:
        {
            strategy = TPSTaskWorkingStrategyStartImmediately;
        }
            break;
        case 1:
        {
            strategy = TPSTaskWorkingStrategyStartByTurns;
        }
            break;
        case 2:
        {
            strategy = TPSTaskWorkingStrategyStayUniquely;
        }
            break;
        default:
            break;
    }
    
    DYWindowPopOccupyPriority occupy = DYWindowPopOccupyPriorityNormal;
    if ([self.occupyTextField.text integerValue]) {
        occupy = [self.occupyTextField.text integerValue];
    }
    
    DYWindowPopAntiOccupyPriority antiOccupy = DYWindowPopAntiOccupyPriorityNormal;
    if ([self.antiOccupyTextField.text integerValue]) {
        antiOccupy = [self.antiOccupyTextField.text integerValue];
    }
    
    DYWindowPopCoverPriority cover = DYWindowPopCoverPriorityNormal;
    if ([self.coverTextField.text integerValue]) {
        cover = [self.coverTextField.text integerValue];
    }
    
    DYWindowPopAntiCoverPriority antiCover = DYWindowPopAntiCoverPriorityNormal;
    if ([self.antiCoverTextField.text integerValue]) {
        antiCover = [self.antiCoverTextField.text integerValue];
    }
    
    NSInteger identifier = 0;
    if ([self.idTextField.text integerValue]) {
        identifier = [self.idTextField.text integerValue];
    }
    
    DYWindowPopInfo *info = [DYWindowPopHelperTestTool createWithStategy:strategy occupy:occupy antiOccupy:antiOccupy cover:cover antiCover:antiCover identifier:identifier];
    
    [self.testHelper popWithPopView:info];
    [self.log appendString:[NSString stringWithFormat:@"%@", [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]]]];
    [self.log appendString:[NSString stringWithFormat:@"addAction:%@", info.description]];
    [self.log appendString:@"\n"];
}

- (DYWindowPopHelper *)testHelper {
    if (!_testHelper) {
        DYWindowPopHelperConfig *config = [DYWindowPopHelperConfig defaultConfig];
        config.popBackgroundView = self.baseView;
        _testHelper = [[DYWindowPopHelper alloc] initWithConfig:config viewPerformer:self];
    }
    return _testHelper;
}

- (void)clearAction {
    [self.testHelper dismissAll];
    [self.log appendString:[NSString stringWithFormat:@"%@", [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]]]];
    [self.log appendString:@"ClearAll"];
    [self.log appendString:@"\n"];
}

- (void)dismissAction {
    NSString *identifier = [NSString stringWithFormat:@"%@",@([self.dismissIdTextField.text integerValue])];
    [self.testHelper dismissWithIdentifier:identifier];
    [self.log appendString:[NSString stringWithFormat:@"%@", [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]]]];
    [self.log appendString:[NSString stringWithFormat:@"dismissAction: id是%@", identifier]];
    [self.log appendString:@"\n"];
}

- (void)viewLogAction:(UIButton *)sender {
    if (self.logTextView) {
        [self.logTextView removeFromSuperview];
        self.logTextView = nil;
        return;
    }
    
    self.logTextView = [[UITextView alloc] init];
    [self.view addSubview:self.logTextView];
    [self.logTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.logTextView.superview);
        make.top.equalTo(sender.mas_bottom);
    }];
    
    [self.logTextView setText:self.log];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField performSelector:@selector(selectAll:) withObject:nil afterDelay:0.0];
}

#pragma mark - DYWindowPopViewPerformer

- (void)dyWindowPopViewHelper:(DYWindowPopHelper *)helper performingViews:(NSArray <id <TPSTask>>*)performingViews lastPerformingViews:(NSArray <id <TPSTask>>*)lastPerformingViews {
    [lastPerformingViews enumerateObjectsUsingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[DYWindowPopInfo class]]) {
            [[(DYWindowPopInfo *)obj view] removeFromSuperview];
        }
    }];
    
    [performingViews enumerateObjectsUsingBlock:^(id<TPSTask>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[DYWindowPopInfo class]]) {
            [self.baseView addSubview:[(DYWindowPopInfo *)obj view]];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
