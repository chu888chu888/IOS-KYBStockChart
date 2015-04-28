//
//  KYBStockTrendChart.h
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//  分时走势

#import <UIKit/UIKit.h>
#import "KYBStockChart.h"
#import "KYBStockVolumeChart.h"

@interface KYBStockTrendChart : UIView

@property (nonatomic,weak) KYBStockChart *contentChart;

@property (nonatomic,weak) KYBStockVolumeChart *volumnChart;

@property (nonatomic,strong) NSMutableArray *chartLineArray;

@property (nonatomic,assign) BOOL showReferenceLine;//是否需要参考线的判断

@property (nonatomic,assign) BOOL shouldShowReferenceLine;//绘制用

-(instancetype)initWithFrame:(CGRect)frame absRange:(CGFloat)range startYValue:(CGFloat)startYValue;

@end
