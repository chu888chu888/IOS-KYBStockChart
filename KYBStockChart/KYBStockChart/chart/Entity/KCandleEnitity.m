//
//  KCandleEnitity.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "KCandleEnitity.h"

@implementation KCandleEnitity

+(instancetype)parseKCandleEntity:(id)feed{
    KCandleEnitity *entity = [[KCandleEnitity alloc] init];
    
    
    
    
    
    if (entity.startPrice > entity.endPrice) {
        entity.upOrDown = GoDown;
    }else if (entity.startPrice == entity.endPrice){
        entity.upOrDown = GoEqual;
    }else{
        entity.upOrDown = GoUp;
    }
    return entity;
}

+(NSArray *)parseKCandleEntityArray:(id)feed{
    NSMutableArray *array = [NSMutableArray array];
    if (feed) {
        for (NSDictionary *dic in feed) {
            KCandleEnitity *entity = [[self class] parseKCandleEntity:dic];
            [array addObject:entity];
        }
    }
    return array;
}

@end
