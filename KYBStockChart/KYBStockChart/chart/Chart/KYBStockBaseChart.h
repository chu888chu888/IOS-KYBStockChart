//
//  KYBStockBaseChart.h
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYBStockChartCommon.h"
#import "KYBChartLineEntity.h"
#import "TSMAEntity.h"

#define DEFAULT_Y_COUNT 3 //可见区域y轴竖线总数
#define DEFAULT_X_COUNT 4 //可见区域x轴总数


@interface KYBStockBaseChart : UIView

@property (nonatomic,assign) NSInteger pointCount;//结点个数

@property (nonatomic,assign) UIEdgeInsets edgeInsets;//收缩

@property (nonatomic,assign) BOOL showYAxis;//是否显示可见区域y轴竖线

@property (nonatomic,assign) CGFloat maxY;

@property (nonatomic,assign) CGFloat minY;

@property (nonatomic,strong) NSArray *leftGraduationArray;//左刻度值

@property (nonatomic,strong) NSArray *rightGraduationArray;//右刻度值

@property (nonatomic,strong) NSArray *bottomGraduationArray;//底部刻度值

@property (nonatomic,copy) NSString *bottomLeftGraduation;//左下角刻度值

@property (nonatomic,copy) NSString *bottomRightGraduation;//右下角刻度值

@property (nonatomic,assign) BOOL showLineName;

@property (nonatomic,strong) UIFont *graduationFont;

@property (nonatomic,strong) UIFont *lineNameFont;

@property (nonatomic,strong) NSMutableArray *chartLineArray;


-(instancetype)initWithFrame:(CGRect)frame absRange:(CGFloat)range startYValue:(CGFloat)startYValue;

-(void)refresh;//刷新

@end
