//
//  KCandleForDrawEntity.h
//  KYBStockChart
//
//  Created by icode on 15/4/24.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYBStockChartCommon.h"

@interface KCandleForDrawEntity : NSObject

@property (nonatomic,assign) CGPoint originPoint;//起始位置

@property (nonatomic,assign) CGSize size;//大小

@property (nonatomic,assign) CGFloat topLineLen;//上影线长度

@property (nonatomic,assign) CGFloat bottomLineLen;//下影线长度

@property (nonatomic,strong) UIColor *candleColor;//k线颜色

-(void)drawCandle:(CGContextRef)context;

@end
