//
//  VolumeForDrawEntity.m
//  KYBStockChart
//
//  Created by icode on 15/4/28.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "VolumeForDrawEntity.h"
#import "KYBStockChartCommon.h"

@implementation VolumeForDrawEntity

-(void)drawVolumnRect:(CGContextRef)context{
    [KYBStockChartCommon drawRect:context rect:self.rect fillColor:self.color];
}

@end
