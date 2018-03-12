//
//  BaseViewController.h
//  ConvenientStore
//
//  Created by LHJ on 2017/12/15.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Color_Transparent           [UIColor clearColor]
#define GetImg(str)                 [UIImage imageNamed:str]
#define Font(s)                     [UIFont systemFontOfSize:s]
#define Font_Bold(s)                [UIFont boldSystemFontOfSize:s]

// ---- LHJ ----
#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))

/** 所有ViewController的基类 */
@interface BaseViewController : UIViewController

/** 是否需要处理键盘弹出/收起的事件，默认NO */
@property(nonatomic, assign) BOOL isNeedHandleKeyboard;

+ (UIViewController *)topViewController;

+ (instancetype) instanceForStoryboardWithName:(NSString*)storyboardName;

/** 返回键盘上方的完成一栏 */
+ (UIView*) getKeyboardHideViewWithTarget:(id)target withSelector:(SEL)selector;

// *********************************************


@end
