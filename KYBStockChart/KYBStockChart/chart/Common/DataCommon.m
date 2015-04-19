//
//  DataCommon.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "DataCommon.h"

@implementation DataCommon

+(CGFloat)nonce{//获得一个8位的随机数
    NSInteger nonce = arc4random()%2000+9000;
    CGFloat random = nonce / 100.00;
    return random;
}

+(void)randomTSMAEntity:(NSInteger)count array:(NSMutableArray **)array avArray:(NSMutableArray **)avArray{
    CGFloat total = 0;
    for (int i = 0; i<count ; i++) {
        TSMAEntity *entity = [[TSMAEntity alloc] init];
        entity.value = [[self class] nonce];
        NSLog(@"%f",entity.value);
        [*array addObject:entity];
        total += entity.value;
        TSMAEntity *entity1 = [[TSMAEntity alloc] init];
        entity1.value = total/(i + 1);
        NSLog(@"av:%f",entity1.value);
        [*avArray addObject:entity1];
    }
}

@end
