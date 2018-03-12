# KeyboardHandle
处理键盘的ViewController基类

使用方法：
设置基类或者子类的isNeedHandleKeyboard成员变量为YES（默认NO），这个变量必须在BaseViewController的ViewDidLoad执行之前设置，因
为在BaseViewController的ViewDidLoad里面会执行检索代码，给所有输入框添加键盘关闭栏。

使用示例：
@interface ViewController : BaseViewController

@end

@implementation ViewController

// --------- 使用纯代码构建ViewController的示例
- (void) loadView
{
    self.isNeedHandleKeyboard = YES; // 设置键盘处理
    
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
}



// --------- 使用storyboard构建ViewController的示例
+ (instancetype) instanceForViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"StoryboardName" bundle:nil];
    ViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [viewController setIsNeedHandleKeyboard:YES]; // 设置键盘处理
    return viewController;
}
