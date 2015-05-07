//
//  KYBChartReferenceView.h
//  KYBStockChart
//
//  Created by icode on 15/5/7.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    KYBChartPointTypeSquare = 0,
    KYBChartPointTypeCircle = 1,
    KYBChartPointTypeDiamond = 2
}KYBChartPointType;

typedef enum{
    KYBChartReferenceViewType0 = 0,//数据显示在边上
    KYBChartReferenceViewType1 = 1//数据显示在中间位置的矩形框中
}KYBChartReferenceViewType;

@class ChartReferencePoint;

@interface KYBChartReferenceView : UIView

@property (nonatomic,assign) KYBChartReferenceViewType referenceType;

@property (nonatomic,assign) UIColor *referenceLineColor;

@property (nonatomic,strong) NSMutableArray *pointArray;

@end

@interface ChartReferencePoint : NSObject

@property (nonatomic,assign) KYBChartPointType pointType;

@property (nonatomic,strong) UIColor *pointColor;

@property (nonatomic,assign) CGPoint position;


@end