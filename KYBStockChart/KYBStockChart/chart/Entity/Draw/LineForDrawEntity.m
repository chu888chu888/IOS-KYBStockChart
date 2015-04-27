//
//  LineForDrawEntity.m
//  KYBStockChart
//
//  Created by icode on 15/4/24.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "LineForDrawEntity.h"
#import "KYBStockChartCommon.h"

@implementation LineForDrawEntity

-(void)drawLine:(CGContextRef)context{
    [KYBStockChartCommon drawLine:context startPoint:self.startPoint endPoint:self.endPoint lineColor:self.lineColor width:self.thickness];
}

@end
