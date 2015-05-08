//
//  KYBChartReferenceView.m
//  KYBStockChart
//
//  Created by icode on 15/5/7.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "KYBChartReferenceView.h"
#import "KYBStockChartCommon.h"

@interface KYBChartReferenceView()



@end

@implementation KYBChartReferenceView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValue];
    }
    return self;
}

-(void)initDefaultValue{
    self.referenceType = KYBChartReferenceViewTypeVertical;
    self.referenceLineColor = [UIColor blackColor];
    self.referenceLineThickness = 0.5f;
    self.referenceLineCrossPoint = CGPointZero;
    self.pointArray = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.edgeInsets = UIEdgeInsetsZero;
}

- (ChartReferencePoint *)insertChartReferencePointWithPointType:(KYBChartPointType)pointType pointCenterPosition:(CGPoint)centerPoint radius:(CGFloat)radius pointColor:(UIColor *)pointColor drawShadow:(BOOL)drawShadow shadowColor:(UIColor *)shadowColor{
    ChartReferencePoint *point = [[ChartReferencePoint alloc] init];
    point.pointType = pointType;
    point.centerPoint = centerPoint;
    point.radius = radius;
    point.pointColor = pointColor;
    point.drawShadow = drawShadow;
    point.shadowColor = shadowColor;
    [self.pointArray addObject:point];
    return point;
}

- (void)drawRect:(CGRect)rect {
    if(!_showContent){
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(self.dash){
        CGFloat dashPattern[]= {4, 4};
        CGContextSetLineDash(context, 0.0, dashPattern, 2);
    }else{
        CGContextSetLineDash(context,0,normal,0);
    }
    switch (self.referenceType) {
        case KYBChartReferenceViewTypeVertical:
            [KYBStockChartCommon drawLine:context startPoint:CGPointMake(self.referenceLineCrossPoint.x, self.edgeInsets.top) endPoint:CGPointMake(self.referenceLineCrossPoint.x, self.frame.size.height - self.edgeInsets.bottom) lineColor:self.referenceLineColor width:self.referenceLineThickness];
            break;
        case KYBChartReferenceViewTypeHorizon:
            [KYBStockChartCommon drawLine:context startPoint:CGPointMake(self.edgeInsets.left, self.referenceLineCrossPoint.y) endPoint:CGPointMake(self.frame.size.width - self.edgeInsets.right, self.referenceLineCrossPoint.y) lineColor:self.referenceLineColor width:self.referenceLineThickness];
            break;
        case KYBChartReferenceViewTypeHorizonAndVertical:
            [KYBStockChartCommon drawLine:context startPoint:CGPointMake(self.referenceLineCrossPoint.x, self.edgeInsets.top) endPoint:CGPointMake(self.referenceLineCrossPoint.x, self.frame.size.height - self.edgeInsets.bottom) lineColor:self.referenceLineColor width:self.referenceLineThickness];
            [KYBStockChartCommon drawLine:context startPoint:CGPointMake(self.edgeInsets.left, self.referenceLineCrossPoint.y) endPoint:CGPointMake(self.frame.size.width - self.edgeInsets.right, self.referenceLineCrossPoint.y) lineColor:self.referenceLineColor width:self.referenceLineThickness];
            break;
        default:
            break;
    }
    CGContextSetLineDash(context,0,normal,0);
    for (ChartReferencePoint *point in _pointArray) {
        if (point.hidden) {
            continue;
        }
        if (point.drawShadow) {
            [KYBStockChartCommon drawCircle:context atCenterPoint:point.centerPoint r:point.radius + 4 fillColor:point.shadowColor strokeColor:[UIColor clearColor]];
        }
        switch (point.pointType) {
            case KYBChartPointTypeSquare:
                [KYBStockChartCommon drawSquare:context atCenterPoint:point.centerPoint r:point.radius fillColor:point.pointColor strokeColor:[UIColor whiteColor]];
                break;
            case KYBChartPointTypeCircle:
                [KYBStockChartCommon drawCircle:context atCenterPoint:point.centerPoint r:point.radius fillColor:point.pointColor strokeColor:[UIColor whiteColor]];
                break;
            case KYBChartPointTypeDiamond:
                [KYBStockChartCommon drawDiamond:context atCenterPoint:point.centerPoint r:point.radius fillColor:point.pointColor strokeColor:[UIColor whiteColor]];
                break;
                
            default:
                break;
        }
    }
}

@end


@implementation ChartReferencePoint

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initDefaultValue];
    }
    return self;
}

-(void)initDefaultValue{
    self.pointColor = [UIColor blackColor];
    self.centerPoint = CGPointZero;
    self.shadowColor = [UIColor colorWithWhite:0 alpha:0.2f];
    self.radius = 3;
}

@end