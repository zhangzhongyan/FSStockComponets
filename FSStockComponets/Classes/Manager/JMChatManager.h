//
//  JMChatManager.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMChatManager : NSObject

+ (instancetype)sharedInstance;

/** 股票市场 */
@property(nonatomic,copy) NSString * market;

/** 是否是暗盘 */
@property(nonatomic,assign) BOOL isDark;

/** 是否是半日市 */
@property(nonatomic,assign) BOOL isHalfDay;

/** 是否收盘 */
@property(nonatomic,assign) BOOL isClose;

/** 是否是指数 */
@property(nonatomic,assign) BOOL isStockIndex;

/** 请求更多 */
@property(nonatomic,assign) BOOL isGetMore;

/** 股票代码 */
@property(nonatomic,copy) NSString * assetID;

/** K线类型 */
@property (nonatomic, assign) NSInteger chartType;

/** 价格小数据点格式化 */
@property(nonatomic,copy) NSString *priceFormate;


+(NSInteger)getCountPointNumberByType:(NSString*)type isDark:(BOOL)isDark isHalfDay:(BOOL)isHalfday chatType:(NSInteger)chatType;

-(NSArray*)timeLineBottomArr;

-(CGFloat)timeLineBottomOffset;

@end

NS_ASSUME_NONNULL_END
