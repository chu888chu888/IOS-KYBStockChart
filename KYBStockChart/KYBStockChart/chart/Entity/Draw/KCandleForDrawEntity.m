//
//  KCandleForDrawEntity.m
//  KYBStockChart
//
//  Created by icode on 15/4/24.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "KCandleForDrawEntity.h"

@implementation KCandleForDrawEntity

-(void)drawCandle:(CGContextRef)context{
    [KYBStockChartCommon drawCandle:context rect:CGRectMake(self.originPoint.x, self.originPoint.y, self.size.width, self.size.height) top:self.topLineLen bottom:self.bottomLineLen color:self.candleColor];
}

@end
