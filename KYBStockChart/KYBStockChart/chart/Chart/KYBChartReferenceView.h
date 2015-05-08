//
//  KYBChartReferenceView.h
//  KYBStockChart
//
//  Created by icode on 15/5/7.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    KYBChartPointTypeSquare = 0,//正方形点
    KYBChartPointTypeCircle = 1,//圆形点
    KYBChartPointTypeDiamond = 2//菱形点
}KYBChartPointType;

typedef enum{
    KYBChartReferenceViewTypeVertical = 0,//只有一根纵向参考线
    KYBChartReferenceViewTypeHorizon,//只有一根横向参考线
    KYBChartReferenceViewTypeHorizonAndVertical//纵横交叉参考线
}KYBChartReferenceViewType;

@class ChartReferencePoint;

@interface KYBChartReferenceView : UIView

@property (nonatomic,assign) KYBChartReferenceViewType referenceType;

@property (nonatomic,assign) UIColor *referenceLineColor;

@property (nonatomic,assign) CGFloat referenceLineThickness;

@property (nonatomic,strong) NSMutableArray *pointArray;

@property (nonatomic,assign) CGPoint referenceLineCrossPoint;// 参考线交叉点的位置＋

@property (nonatomic,assign) BOOL dash;//是否虚线

@property (nonatomic,assign) BOOL showContent;

@property (nonatomic,assign) UIEdgeInsets edgeInsets;

- (ChartReferencePoint *)insertChartReferencePointWithPointType:(KYBChartPointType)pointType pointCenterPosition:(CGPoint)centerPoint radius:(CGFloat)radius pointColor:(UIColor *)pointColor drawShadow:(BOOL)drawShadow shadowColor:(UIColor *)shadowColor;

@end

@interface ChartReferencePoint : NSObject

@property (nonatomic,assign) KYBChartPointType pointType;

@property (nonatomic,strong) UIColor *pointColor;

@property (nonatomic,strong) UIColor *shadowColor;

@property (nonatomic,assign) CGPoint centerPoint;

@property (nonatomic,assign) CGFloat radius;//半径

@property (nonatomic,assign) BOOL drawShadow;//是否显示阴影

@property (nonatomic,assign) BOOL hidden;//是否隐藏

@end