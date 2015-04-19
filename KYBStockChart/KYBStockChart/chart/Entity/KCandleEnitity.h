//
//  KCandleEnitity.h
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    GoDown = -1,
    GoEqual = 0,
    GoUp = 1
}UpOrDown;

@interface KCandleEnitity : NSObject

@property (nonatomic,assign) CGFloat maxPrice;//最高

@property (nonatomic,assign) CGFloat minPrice;//最低

@property (nonatomic,assign) CGFloat startPrice;//开盘

@property (nonatomic,assign) CGFloat endPrice;//收盘

@property (nonatomic,assign) UpOrDown upOrDown;//涨

+(instancetype)parseKCandleEntity:(id)feed;

+(NSArray *)parseKCandleEntityArray:(id)feed;

@end
