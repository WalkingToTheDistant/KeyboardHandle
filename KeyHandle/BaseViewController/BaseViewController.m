//
//  BaseViewController.m
//  ConvenientStore
//
//  Created by LHJ on 2017/12/15.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property(nonatomic, assign) int moveValueForKeyboard;

@property(nonatomic, assign) int keyboardHeight;

@end

@implementation BaseViewController

// ****************************************************************************************************
// ****************************************************************************************************
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:RGBColor(246, 246, 246)];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    if(_isNeedHandleKeyboard == YES){
        [self addDoneKeyboardViewToInputView:self.view];
    }
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_isNeedHandleKeyboard == YES){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_isNeedHandleKeyboard == YES){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype) instanceForStoryboardWithName:(NSString*)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    BaseViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return viewController;
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [[self class] _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

// ****************************************************************************************************
// ****************************************************************************************************
#pragma mark - 键盘处理
- (void) handleKeyboardShow:(NSNotification*) notification
{
    if(_moveValueForKeyboard > 0){ // 键盘已经处理过，避免在键盘输入的时候再点击了其他的输入框
        return;
    }
    
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    const float duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    const UIViewAnimationOptions options = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    UIView *viewFirst = [[self class] getFirstResponder:self.view];
    if(viewFirst != nil){
        
        CGPoint pointView = [viewFirst convertPoint:self.view.bounds.origin toView:self.view];
        pointView.y += CGRectGetHeight(viewFirst.frame);
        _keyboardHeight = CGRectGetHeight(keyboardFrame);
        int originYForKeyboard = CGRectGetMaxY(self.view.frame) - _keyboardHeight;
        
        if(pointView.y >= originYForKeyboard){ 
            // 输入框被键盘遮挡
            _moveValueForKeyboard = pointView.y - originYForKeyboard;
            __block CGRect frame = self.view.frame;
            frame.origin.y -= _moveValueForKeyboard;
            
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                self.view.frame = frame;
            } completion:nil];
        } else {
            _moveValueForKeyboard = 0;
        }
    }
}
- (void) handleKeyboardHide:(NSNotification*)notification
{
    if(_moveValueForKeyboard > 0){
        const float duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        const UIViewAnimationOptions options = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        __block CGRect frame = self.view.frame;
        frame.origin.y += _moveValueForKeyboard;
        _moveValueForKeyboard = 0;
        
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.view.frame = frame;
        } completion:nil];
    }
}
- (void) handleKeyboardFrameChange:(NSNotification*)notification
{
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(_moveValueForKeyboard > 0){ // 需要处理中文键盘的尺寸变化问题
        int valueChange = CGRectGetHeight(keyboardFrame) - _keyboardHeight;
        if(valueChange != 0){
            const float duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
            const UIViewAnimationOptions options = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
            __block CGRect frame = self.view.frame;
            frame.origin.y -= valueChange;
            _moveValueForKeyboard += valueChange;
            _keyboardHeight = CGRectGetHeight(keyboardFrame);
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                self.view.frame = frame;
            } completion:nil];
        }
        
    }
}
+ (UIView*) getFirstResponder:(UIView*)superView
{
    if(superView.isFirstResponder == YES){
        return superView;
    }
    
    for(UIView *viewChild in superView.subviews){
        if([viewChild isFirstResponder] == YES){
            return viewChild;
        }
    }
    // 再搜索下一层Subview
    for(UIView *viewChild in superView.subviews){
        UIView *viewResult = [[self class] getFirstResponder:viewChild];
        if(viewResult != nil){
            return viewResult;
        }
    }
    return nil;
}
/** 创建键盘关闭的View */
+ (UIView*) getKeyboardHideViewWithTarget:(id)target withSelector:(SEL)selector
{
    UIView *viewResult = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 40)];
    [viewResult setBackgroundColor:RGBColor(250, 250, 250)];
    
    int height = CGRectGetHeight(viewResult.frame);
    int width = 80;
    int x = CGRectGetMaxX(viewResult.frame) - width;
    int y = 0;
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [btnDone.titleLabel setFont:Font_Bold(16.0f)];
    [btnDone setFrame:CGRectMake(x, y, width, height)];
    [btnDone addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [viewResult addSubview:btnDone];
    
    return viewResult;
}
/** 给所有输入框的键盘都添加关闭 */
- (void) addDoneKeyboardViewToInputView:(UIView*) superView
{
    //这个方法可能是有效率问题，因为需要遍历整个ViewController的view，暂时还找不到更好的方法
    for(UIView *viewChlid in [superView subviews]){
        if([viewChlid isKindOfClass:[UITextField class]] == YES){
            if([viewChlid inputAccessoryView] == nil){
                UIView *viewDone = [[self class] getKeyboardHideViewWithTarget:self withSelector:@selector(closeKeyboard)];
                [((UITextField*)viewChlid) setInputAccessoryView:viewDone];
            }
            
        } else if([viewChlid isKindOfClass:[UITextView class]] == YES){
            if([viewChlid inputAccessoryView] == nil){
                UIView *viewDone = [[self class] getKeyboardHideViewWithTarget:self withSelector:@selector(closeKeyboard)];
                [((UITextView*)viewChlid) setInputAccessoryView:viewDone];
            }
        } else {
            [self addDoneKeyboardViewToInputView:viewChlid];
        }
    }
}
/** 关闭键盘 */
- (void) closeKeyboard
{
    [self.view endEditing:YES];
}

@end
