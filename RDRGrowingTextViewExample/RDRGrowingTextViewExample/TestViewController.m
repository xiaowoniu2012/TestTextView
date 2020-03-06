
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
@property (nonatomic,assign) CGFloat textViewMaxWidth;
@property (nonatomic,assign) CGFloat tempMaxWidth;
@property (nonatomic,assign) UIEdgeInsets paddingInsets;
@property (nonatomic,assign) CGFloat maxScale;
@end




@implementation TestViewController


-(CGAffineTransform)transformFromRect:(CGRect)fromRect toRect:(CGRect)toRect{
    CGAffineTransform moveTrans = CGAffineTransformMakeTranslation(CGRectGetMidX(toRect) - CGRectGetMidX(fromRect), CGRectGetMidY(toRect) - CGRectGetMidY(fromRect));
    CGAffineTransform scaleTrans = CGAffineTransformMakeScale(toRect.size.width / fromRect.size.width, toRect.size.height / fromRect.size.height);
    
    return CGAffineTransformConcat(scaleTrans, moveTrans);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.paddingInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.textViewMaxWidth = UIScreen.mainScreen.bounds.size.width - 40;
    // Do any additional setup after loading the view.
    [self addChildViews];
}

- (void)addChildViews {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
//        make.width.lessThanOrEqualTo(self.view).offset(-20);
//        make.width.mas_greaterThanOrEqualTo(40);
//        make.leading.greaterThanOrEqualTo(self.view).offset(10);
//        make.trailing.lessThanOrEqualTo(self.view).offset(-10);
//        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    

    
    RDRGrowingTextView *textView = [RDRGrowingTextView new];
    textView.font = [UIFont systemFontOfSize:17.0f];
    textView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.layer.cornerRadius = 4.0f;
    textView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layer.masksToBounds = YES;
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    textView.textContainer.maximumNumberOfLines = 4;
//    textView.selectable = NO;
    textView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    textView.delegate = self;
    textView.preferLayoutMaxWidth = self.textViewMaxWidth;
    self.tempMaxWidth = self.textViewMaxWidth;
    _tView = textView;
    [_contentView addSubview:_tView];
    [_tView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.lessThanOrEqualTo(_contentView).offset(-20);
        make.edges.equalTo(_contentView).insets(self.paddingInsets);
        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [testBtn setTitle:@"test" forState:UIControlStateNormal];
    testBtn.frame = CGRectMake(100, 400, 40, 30);
    [testBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [_contentView addGestureRecognizer:pin];
}


- (void)actionBtn:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//    _contentView.transform = ;
    CGFloat scale = 3.0f;
    [_contentView.layer setAffineTransform:CGAffineTransformMakeScale(scale, scale)];
//    _tView.textContainerInset = UIEdgeInsetsScale(_tView.textContainerInset, scale);
//    UIEdgeInsets paddingInsets = UIEdgeInsetsScale(UIEdgeInsetsMake(10, 10, 10, 10), scale);
//    CGFloat textViewWidth = self.textViewMaxWidth - UIEdgeInsetsGetHorizontalValue(paddingInsets);
    _tView.preferLayoutMaxWidth = self.textViewMaxWidth / scale - UIEdgeInsetsGetHorizontalValue(self.paddingInsets);
//    _contentView.bounds = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
//    _tView.bounds = UIEdgeInsetsInsetRect(_contentView.bounds, UIEdgeInsetsMake(10, 10, 10, 10));
//    [UIView animateWithDuration:3 animations:^{
//        _contentView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100);
//    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _tView.preferLayoutMaxWidth = self.tempMaxWidth;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view != _contentView) {
        [self.view endEditing:YES];
    }
    
}





- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture {

    if (self.maxScale == 0) {
        CGFloat width = CGRectGetWidth(self.view.bounds)-20;
        CGFloat ratio = (_contentView.bounds.size.width * 1.0)/ _contentView.bounds.size.height;
        CGAffineTransform transfrom = [self transformFromRect:_contentView.frame toRect:CGRectMake(10, 10, width, width/ratio)];
        self.maxScale = transfrom.a;
        NSLog(@"max scale is :%.2f ",self.maxScale);
    }
    
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = pinchGesture.scale ;
        CGFloat velocity = pinchGesture.velocity;
        UIView *view = pinchGesture.view;
        NSLog(@"scale is :%.2f  velocity : %.2f",scale , pinchGesture.velocity);
        if (view.transform.a >= self.maxScale && velocity > 0) {
            pinchGesture.scale = 1;
            return;
            
        }else if(view.transform.a <= 0.5 && velocity < 0) {
            pinchGesture.scale = 1;
            return;
        }
        
        CGAffineTransform curTransform = view.transform;
        curTransform = CGAffineTransformScale(curTransform, scale, scale);
        if (curTransform.a >= 0.5 && curTransform.a <= self.maxScale) {
            view.transform = curTransform;
            
        }
        pinchGesture.scale = 1;
    }else if (pinchGesture.state == UIGestureRecognizerStateEnded) {
        self.tempMaxWidth = self.textViewMaxWidth /  _contentView.transform.a - UIEdgeInsetsGetHorizontalValue(self.paddingInsets);
    }
    

    
        
    
    
    
    

}

@end
