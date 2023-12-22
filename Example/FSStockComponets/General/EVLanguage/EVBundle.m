//
//  EVBundle.m
//  EVCRMApp
//
//  Created by 张忠燕 on 2021/9/10.
//

#import "EVBundle.h"
#import "EVLanguage.h"

@implementation EVBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if ([EVBundle gt_mainBundle]) {
        // 通过修改[NSBundle mainBundle]对象的isa指针，使其指向它的子类GTBundle
        return [[EVBundle gt_mainBundle] localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)gt_mainBundle {
    NSString *curLCode = [EVLanguage getCurLanguageCode];
    if (curLCode.length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:curLCode ofType:@"lproj"];
        if (path.length) {
            return [NSBundle bundleWithPath:path];
        }
    }

    return nil;
}

@end
