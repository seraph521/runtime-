//
//  UserInfo.m
//  RunTime使用
//
//  Created by LT-MacbookPro on 17/4/18.
//  Copyright © 2017年 XFX. All rights reserved.
//

#import "UserInfo.h"
#import <objc/runtime.h>

@implementation UserInfo

//正常归档步骤

//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    
//    [aCoder encodeObject:_name forKey:@"name"];
//    [aCoder encodeObject:_paseword forKey:@"paseword"];
//    [aCoder encodeObject:_iPhoneNum forKey:@"iPhoneNum"];
//    [aCoder encodeInt:_age forKey:@"age"];
//
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//
//    if(self =[super init]){
//    
//        _name = [aDecoder decodeObjectForKey:@"name"];
//        _paseword = [aDecoder decodeObjectForKey:@"paseword"];
//        _iPhoneNum = [aDecoder decodeObjectForKey:@"iPhoneNum"];
//        _age = [aDecoder decodeIntForKey:@"age"];
//    }
//    return self;
//}


// runtime实现归档

- (void)encodeWithCoder:(NSCoder *)aCoder{

    unsigned  int outcount = 0;
    //获取所有成员变量
    Ivar * ivars = class_copyIvarList([self class], &outcount);
    
    for(int i=0;i<outcount;i++){
    
        //取出对应的成员变量
        Ivar ivar = ivars[i];
        //取出成员变量的名称与类型
        const char * ivar_name =  ivar_getName(ivar);
        NSString * name = [NSString stringWithUTF8String:ivar_name];
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
        
    }
    //释放内存
    free(ivars);
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if(self =[super init]){
        
        unsigned int outCount = 0;
        Ivar * ivars = class_copyIvarList([self class], &outCount);
        
        for (int i=0; i<outCount; i++) {
            
            Ivar ivar = ivars[i];
            const char * ivar_name = ivar_getName(ivar);
            NSString * name = [NSString stringWithUTF8String:ivar_name];
            id value  =  [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
            
        }
        
        //释放内存
        free(ivars);
        
    }
    return self;
}





@end
