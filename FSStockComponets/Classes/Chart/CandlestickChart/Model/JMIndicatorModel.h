//
//  JMIndicatorModel.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import <Foundation/Foundation.h>
@class JMKlineModel;

NS_ASSUME_NONNULL_BEGIN

@interface JMMACDModel : NSObject
@property (nonatomic, strong) NSNumber *DIFF;
@property (nonatomic, strong) NSNumber *DEA;
@property (nonatomic, strong) NSNumber *MACD;
+ (void)calMACDWithData:(NSArray<JMKlineModel *>*)datas params:(NSArray *)params;
@end

@interface JMKDJModel : NSObject
@property (nonatomic, strong) NSNumber *K;
@property (nonatomic, strong) NSNumber *D;
@property (nonatomic, strong) NSNumber *J;
@property (nonatomic, strong) NSNumber *RSV;
+ (void)calKDJWithData:(NSArray<JMKlineModel *>*)datas params:(NSArray *)params;
@end

@interface JMMAModel : NSObject
@property (nonatomic, strong) NSNumber *MA1;
@property (nonatomic, strong) NSNumber *MA2;
@property (nonatomic, strong) NSNumber *MA3;
@property (nonatomic, strong) NSNumber *MA4;
@property (nonatomic, strong) NSNumber *MA5;
+ (void)calMAWithData:(NSArray<JMKlineModel *>*)datas params:(NSArray *)params;
@end

@interface JMRSIModel : NSObject
@property (nonatomic, strong) NSNumber *RSI1;
@property (nonatomic, strong) NSNumber *RSI2;
@property (nonatomic, strong) NSNumber *RSI3;
+ (void)calRSIWithData:(NSArray<JMKlineModel *>*)datas params:(NSArray *)params;
@end

@interface JMBOLLModel : NSObject
@property (nonatomic, strong) NSNumber *UP;
@property (nonatomic, strong) NSNumber *MID;
@property (nonatomic, strong) NSNumber *LOW;
+ (void)calBOLLWithData:(NSArray<JMKlineModel *>*)datas params:(NSArray *)params;
@end

@interface JMWRModel : NSObject
@property (nonatomic, strong) NSNumber *WR1;
@property (nonatomic, strong) NSNumber *WR2;
+ (void)calWRWithData:(NSArray<JMKlineModel *>*)datas params:(NSArray *)params;
@end

@interface JMEMAModel : NSObject
@property (nonatomic, strong) NSNumber *EMA1;
@property (nonatomic, strong) NSNumber *EMA2;
+ (void)calEmaWithData:(NSArray<JMKlineModel *>*)datas params:(NSArray *)params;
@end

NS_ASSUME_NONNULL_END
