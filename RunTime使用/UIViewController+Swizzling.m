//
//  UIViewController+Swizzling.m
//  RunTime使用
//
//  Created by LT-MacbookPro on 17/4/18.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load{

    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method toMethod = class_getInstanceMethod([self class], @selector(swizzling_viewDidLoad));
    
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */
    if (!class_addMethod([self class], @selector(viewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

- (void)swizzling_viewDidLoad{

    NSLog(@"========拦截系统viewDidLoad方法========");
    [self swizzling_viewDidLoad];
    
}

@end
