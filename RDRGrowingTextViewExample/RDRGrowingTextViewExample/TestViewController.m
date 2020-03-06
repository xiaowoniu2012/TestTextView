
//  TestViewController.m
//  RDRGrowingTextViewExample
//
//  Created by smart on 2020/3/5.
//  Copyright © 2020 Damiaan Twelker. All rights reserved.
//

#import "TestViewController.h"
#import "RDRGrowingTextView.h"
#import "Masonry.h"
@interface TestViewController () <UITextViewDelegate>
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) RDRGrowingTextView *tView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self addChildViews];
}

- (void)addChildViews {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.lessThanOrEqualTo(self.view).offset(-20);
        make.width.mas_greaterThanOrEqualTo(40);
        make.leading.greaterThanOrEqualTo(self.view).offset(10);
        make.trailing.lessThanOrEqualTo(self.view).offset(-10);
//        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    
    RDRGrowingTextView *textView = [RDRGrowingTextView new];
    textView.font = [UIFont systemFontOfSize:17.0f];
    textView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
    textView.layer.cornerRadius = 4.0f;
    textView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layer.masksToBounds = YES;
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    textView.textContainer.maximumNumberOfLines = 4;
    textView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    _tView = textView;
    [_contentView addSubview:_tView];
    [_tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(_contentView).offset(-20);
        make.edges.equalTo(_contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        make.width.mas_greaterThanOrEqualTo(20);
    }];
    
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [testBtn setTitle:@"test" forState:UIControlStateNormal];
    testBtn.frame = CGRectMake(100, 400, 40, 30);
    [testBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}


- (void)actionBtn:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//    _contentView.transform = ;
    [_contentView.layer setAffineTransform:CGAffineTransformMakeScale(1.2, 1.2)];
//    _contentView.bounds = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
//    _tView.bounds = UIEdgeInsetsInsetRect(_contentView.bounds, UIEdgeInsetsMake(10, 10, 10, 10));
//    [UIView animateWithDuration:3 animations:^{
//        _contentView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100);
//    }];
}
@end
