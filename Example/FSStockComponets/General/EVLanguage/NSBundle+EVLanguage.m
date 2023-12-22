//
//  NSBundle+EVLanguage.m
//  EVCRMApp
//
//  Created by 张忠燕 on 2021/9/10.
//

#import "NSBundle+EVLanguage.h"
#import "EVBundle.h"
//Helper
#import <objc/runtime.h>

@implementation NSBundle (EVLanguage)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //动态继承、交换，方法类似KVO，通过修改[NSBundle mainBundle]对象的isa指针，使其指向它的子类RCBundle，这样便可以调用子类的方法；其实这里也可以使用method_swizzling来交换mainBundle的实现，来动态判断，可以同样实现。
        object_setClass([NSBundle mainBundle], [EVBundle class]);
    });
}

@end
