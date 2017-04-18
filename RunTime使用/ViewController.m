//
//  ViewController.m
//  RunTime使用
//
//  Created by LT-MacbookPro on 17/4/18.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>
#import "UserInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1 方法简单的交换
    [self changeMethod];
    
    //2 归档
    [self archiver];
    
    //3 解档
    [self unArchiver];
}

// 方法简单的交换
- (void)changeMethod{

    NSLog(@"===========================交换前");
    [Person run];
    [Person walk];
    NSLog(@"===========================交换后");
    //获取类方法
    Method m1 = class_getClassMethod([Person class], @selector(run));
    Method m2 = class_getClassMethod([Person class], @selector(walk));
    //交换方法实现
    method_exchangeImplementations(m1, m2);
    
    [Person run];
    [Person walk];
    
}

- (void)archiver{

    UserInfo * info = [[UserInfo alloc] init];
    info.name = @"xiaoming";
    info.age = 18;
    info.paseword = @"哈哈";
    info.iPhoneNum = @"110";
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [path stringByAppendingPathComponent:@"user.data1"];
    
    [NSKeyedArchiver archiveRootObject:info toFile:filePath];
    
}

- (void)unArchiver{

    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * filePath = [path stringByAppendingPathComponent:@"user.data1"];
    
    UserInfo * user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    NSLog(@"username====%@",user.name);
    
}


@end
