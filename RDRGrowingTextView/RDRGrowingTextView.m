//
//  RDRGrowingTextView.m
//  RDRGrowingTextView
//
//  Created by Damiaan Twelker on 04/10/15.
//  Copyright (c) 2015 Damiaan Twelker. All rights reserved.
//
//  LICENSE
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Damiaan Twelker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RDRGrowingTextView.h"
#import "NSString+YYAdd.h"

@interface RDRGrowingTextView () <UITextViewDelegate>
@property (nonatomic,assign) CGFloat increasedWidth;
@end

@implementation RDRGrowingTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self updateLayout];
}

- (CGSize)intrinsicContentSize
{
    
    
    CGFloat scale = self.superview.transform.a;
    if (scale == 0) {
        scale = 1;
    }
    CGRect textRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
    CGFloat height = textRect.size.height + self.textContainerInset.top + self.textContainerInset.bottom;
    CGFloat width = textRect.size.width + self.textContainerInset.left *scale + self.textContainerInset.right *scale;
    NSLog(@"textRect :%@ size: %@",[NSValue valueWithCGRect:textRect],[NSValue valueWithCGSize:self.textContainer.size]);
    
    CGFloat fixedWidth;
    if (self.preferLayoutMaxWidth != 0) {
        fixedWidth  = self.preferLayoutMaxWidth;
    }else{
        fixedWidth = CGRectGetWidth(self.frame);
    }
    CGSize newsize = [self sizeThatFits:CGSizeMake(fixedWidth, HUGE_VAL)];
    width = MAX(30,newsize.width);
//
    return CGSizeMake(width, height);
}

- (void)setPreferLayoutMaxWidth:(CGFloat)preferLayoutMaxWidth {
    if (_preferLayoutMaxWidth != preferLayoutMaxWidth) {
        _preferLayoutMaxWidth = preferLayoutMaxWidth;
        [self updateLayout];
    }
}

- (void)textDidChange:(NSNotification *)notification
{
    [self updateLayout];
}

- (void)updateLayout
{
    [self invalidateIntrinsicContentSize];
    [self layoutIfNeeded];
}


- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    // Update frame right before scroll occurs
    [self updateLayout];
    [super scrollRectToVisible:rect animated:animated];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    CGFloat width = [text widthForFont:self.font];
//    self.increasedWidth = ceilf(width+2);
//    return YES;
//}

@end
