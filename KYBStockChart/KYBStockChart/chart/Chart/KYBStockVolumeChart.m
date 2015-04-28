//
//  KYBStockVolumeChart.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//  成交量图

#import "KYBStockVolumeChart.h"
#import "KYBStockChartCommon.h"

@implementation KYBStockVolumeChart

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initBaseData];
    }
    return self;
}

-(void)initBaseData{
    [self setEdgeInsets:UIEdgeInsetsMake(5, 40, 5, 20)];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
#pragma mark 画y轴
    CGContextSetLineDash(context,0,normal,0);
    [KYBStockChartCommon drawLine:context
                       startPoint:self.originPoint
                         endPoint:self.leftTopPoint
                        lineColor:Axis0Color width:0.2];
#pragma mark 画x轴
    [KYBStockChartCommon drawLine:context
                       startPoint:CGPointMake(self.originPoint.x, self.originPoint.y)
                         endPoint:CGPointMake(self.rightBottomPoint.x, self.rightBottomPoint.y)
                        lineColor:Axis0Color width:0.2];
}

@end
