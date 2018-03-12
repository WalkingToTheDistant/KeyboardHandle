//
//  ViewController.m
//  KeyHandle
//
//  Created by LHJ on 2018/3/11.
//  Copyright © 2018年 LHJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, retain) UITextView *textView;

@property(nonatomic, retain) UITextView *textView2;

@end

@implementation ViewController

- (void) loadView
{
    self.isNeedHandleKeyboard = YES;
    
    UIView *viewMain = [UIView new];
    [viewMain setFrame:[UIScreen mainScreen].bounds];
    [viewMain setBackgroundColor:RGBColor(255, 255, 255)];
    [viewMain setUserInteractionEnabled:YES];
    [self setView:viewMain];
    
    int width = 200;
    int height = 40;
    int x = (CGRectGetWidth(viewMain.bounds) - width)/2;
    int y = CGRectGetHeight(viewMain.bounds) - height - 10;
    _textView = [UITextView new];
    [_textView setFrame:CGRectMake(x, y, width, height)];
    [_textView setBackgroundColor:RGBColor(244, 30, 30)];
    [viewMain addSubview:_textView];
    
    y -= (height + 10);
    _textView2 = [UITextView new];
    [_textView2 setFrame:CGRectMake(x, y, width, height)];
    [_textView2 setBackgroundColor:RGBColor(244, 30, 30)];
    [viewMain addSubview:_textView2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
