//
//  VolumnEntity.h
//  KYBStockChart
//
//  Created by icode on 15/4/28.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCandleEnitity.h"

@interface VolumnEntity : NSObject

@property (nonatomic,assign) NSInteger volumnValue;

@property (nonatomic,assign) UpOrDown upOrDown;

@end
