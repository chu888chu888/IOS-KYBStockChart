//
//  KYBChartLineEntity.h
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCandleEnitity.h"
#import "TSMAEntity.h"
#import "PointForSelectEntity.h"

typedef enum{
    KYBChartLineType_MA = 0,//均线
    KYBChartLineType_TS = 1,//分时
    KYBChartLineType_K = 2//k线
}KYBChartLineType;

@interface KYBChartLineEntity : NSObject

@property (nonatomic,copy)NSString *name;//名字

@property (nonatomic,copy)UIColor *lineColor;//颜色

@property (nonatomic,assign)CGFloat thickness;//粗细

@property (nonatomic,strong)NSArray *dataArray;//数据源

@property (nonatomic,strong)NSArray *selectedPointArray;//PointForSelectEntity

@property (nonatomic,assign)NSInteger totalPointCount;//图表上点总个数 （不一定与dataArray个数相等）

@property (nonatomic,assign)KYBChartLineType type;//类型

@property (nonatomic,assign)CGFloat max;//最大值

@property (nonatomic,assign)CGFloat min;//最小值

-(instancetype)initWithType:(KYBChartLineType)type name:(NSString *)name lineColor:(UIColor *)color thickness:(CGFloat)thickness totalPointCount:(NSInteger)totalPointCount dataArray:(NSArray *)dataArray;

@end
