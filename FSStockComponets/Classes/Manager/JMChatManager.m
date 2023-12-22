//
//  JMChatManager.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "JMChatManager.h"

@implementation JMChatManager

static JMChatManager *__onetimeClass;

+ (instancetype)sharedInstance{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __onetimeClass = [[JMChatManager alloc]init];
        
    });
    return __onetimeClass;
}

#pragma mark--辅助方法

+(NSInteger)getCountPointNumberByType:(NSString*)type isDark:(BOOL)isDark isHalfDay:(BOOL)isHalfday chatType:(NSInteger)chatType{
    
    if (chatType == 3) {
        if ([@"HK" isEqualToString:type]) {
            return 5*83;
        }else if ([@"SZ" isEqualToString:type] || [@"SH" isEqualToString:type] || [@"ZH" isEqualToString:type]){
            return 5*60;
        }else{
            return 5*98;
        }
    }else{
        if (isDark) {
            return 240;
        }else if ([@"HK" isEqualToString:type]){
            return 330;
        }else if([@"US1" isEqualToString:type]){//美股盘前
            return 330;
        }else if([@"US2" isEqualToString:type]){//美股盘中
            return 390;
        }else if ([@"US3" isEqualToString:type]){//美股盘后
            return 240;
        }else if ([@"SZ" isEqualToString:type] || [@"SH" isEqualToString:type] ){
            return 240;
        }else if ([@"ZH" isEqualToString:type]){//中华通
            return 240;
        } else{
            return 330;
        }
    }
}

-(NSArray*)timeLineBottomArr{
    if (self.isDark) {
        if (self.isHalfDay) {
            return @[@"14:15",@"",@"16:30"];
        }else {
            return @[@"16:15",@"",@"18:30"];
        }
    }else{
        if ([self.market isEqualToString:@"HK"]) {
            return  @[@"09:30", @"12:00/13:00", @"16:00"];
        }else if([@"US1" isEqualToString:self.market]){//美股盘前
            return @[@"04:01", @"", @"09:30"];
        }else if([@"US2" isEqualToString:self.market]){//美股盘中
            return @[@"09:31", @"12:00", @"16:00"];
        }else if ([@"US3" isEqualToString:self.market]){//美股盘后
            return @[@"16:01", @"", @"20:00"];
        }else if([@"ZH" isEqualToString:self.market]){
            return @[@"09:30" , @"11:30/13:00", @"15:00"];
        }else{
            return  @[@"09:30", @"12:00/13:00", @"16:00"];
        }
    }

}
-(CGFloat)timeLineBottomOffset{
    if (self.isDark) {
        if (self.isHalfDay) {
            return 1.0f/2.0f;
        }else {
            return 1.0f/2.0f;
        }
    }else{
        if ([self.market isEqualToString:@"HK"]) {
            return 5.0f/11.0f;
        }else if([@"US1" isEqualToString:self.market]){//美股盘前
            return 1.0f/2.0f;
        }else if([@"US2" isEqualToString:self.market]){//美股盘中
            return 1.0f/2.0f;
        }else if ([@"US3" isEqualToString:self.market]){//美股盘后
            return 1.0f/2.0f;
        }else if([@"ZH" isEqualToString:self.market]){
            return 1.0f/2.0f;
        }else{
            return 5.0f/11.0f;
        }
    }
}

@end
