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
#import "KYBStockBaseChart.h"

#define DEFAULT_Y_COUNT 3 //可见区域y轴竖线总数
#define DEFAULT_X_COUNT 4 //可见区域x轴总数


@interface KYBStockChart : KYBStockBaseChart

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

@property CGPoint touchPint;

@property (nonatomic,strong) NSMutableArray *lineArrayForDraw;

@property (nonatomic,strong) NSMutableArray *pointArrayForSelect;

-(instancetype)initWithFrame:(CGRect)frame absRange:(CGFloat)range startYValue:(CGFloat)startYValue;

//根据值获得y坐标
-(CGFloat)getYpositionWithValue:(CGFloat)value;

//获得距离触点最近的坐标位置
-(CGPoint)closePointWithTouchPoint:(CGPoint)touchPoint;

-(void)refresh;//刷新

@end
