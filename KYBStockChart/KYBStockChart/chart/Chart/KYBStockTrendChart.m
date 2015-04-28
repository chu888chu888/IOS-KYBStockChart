//
//  KYBStockTrendChart.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "KYBStockTrendChart.h"
#import "KYBChartLineEntity.h"
#import "LineForDrawEntity.h"

@interface KYBStockTrendChart ()

@property (nonatomic,assign)CGFloat range;

@property (nonatomic,assign)CGFloat startYValue;

@property UILongPressGestureRecognizer *longPressGesture;

@end

@implementation KYBStockTrendChart

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseData];
        [self initGesture];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame absRange:(CGFloat)range startYValue:(CGFloat)startYValue{
    self = [super initWithFrame:frame];
    if (self) {
        _range = range;
        _startYValue = startYValue;
        [self initBaseData];
        [self initGesture];
    }
    return self;
}

-(void)initBaseData{
    KYBStockChart *baseChart = [[KYBStockChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8) absRange:_range startYValue:_startYValue];
    baseChart.showYAxis = YES;
    baseChart.userInteractionEnabled = NO;
    [self addSubview:baseChart];
    _contentChart = baseChart;
    
    KYBStockVolumeChart *volumnChart = [[KYBStockVolumeChart alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseChart.frame), self.frame.size.width, self.frame.size.height * 0.2)];
    [self addSubview:volumnChart];
    _volumnChart = volumnChart;
}

-(void)initGesture{
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPressGesture.minimumPressDuration = 0.5;
    //    _longPressGesture.
    [self addGestureRecognizer:_longPressGesture];
}

-(void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:_contentChart];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat touchPointX = touchPoint.x;
        CGFloat touchPointY = touchPoint.y;
        if (touchPointX < self.contentChart.originPoint.x) {
            touchPointX = self.contentChart.originPoint.x;
        }else if (touchPointX > self.contentChart.rightBottomPoint.x){
            touchPointX = self.contentChart.rightBottomPoint.x;
        }
        
        if (touchPointY < self.contentChart.leftTopPoint.y) {
            touchPointY = self.contentChart.leftTopPoint.y;
        }else if (touchPoint.y > self.contentChart.originPoint.y){
            touchPointY = self.contentChart.originPoint.y;
        }
        self.shouldShowReferenceLine = YES;
        self.contentChart.touchPint = CGPointMake(touchPointX, touchPointY);
    }else{
        self.shouldShowReferenceLine = NO;
    }
    [self setNeedsDisplay];
}

-(void)setChartLineArray:(NSMutableArray *)chartLineArray{
    _chartLineArray = chartLineArray;
    NSMutableArray *lineArrayForDraw = [NSMutableArray array];
    NSMutableArray *pointArrayForSelect = [NSMutableArray array];
    for(KYBChartLineEntity *line in _chartLineArray){
        NSMutableArray *drawEnitiyArray = [NSMutableArray array];
        for (int i = 0; i < line.dataArray.count - 1; i++) {
            TSMAEntity *entity1 = line.dataArray[i];
            TSMAEntity *entity2 = line.dataArray[i + 1];
            CGFloat xPosition1 = self.contentChart.originPoint.x + self.contentChart.xStepLen * i;
            CGFloat xPosition2 = self.contentChart.originPoint.x + self.contentChart.xStepLen * (i + 1);
            CGFloat yPosition1 = [self.contentChart getYpositionWithValue:entity1.value];
            CGFloat yPosition2 = [self.contentChart getYpositionWithValue:entity2.value];
            switch (line.type) {
                case KYBChartLineType_TS://分时
                case KYBChartLineType_MA://均线
                {
                    CGPoint startPoint = CGPointMake(xPosition1, yPosition1);
                    CGPoint endPoint = CGPointMake(xPosition2, yPosition2);
//                    CGPoint _startPoint = [self convertPoint:startPoint fromView:self.contentChart];
//                    CGPoint _endPoint = [self convertPoint:endPoint fromView:self.contentChart];
                    LineForDrawEntity *entity = [[LineForDrawEntity alloc] init];
                    entity.startPoint = startPoint;
                    entity.endPoint = endPoint;
                    entity.lineColor = line.lineColor;
                    entity.thickness = line.thickness;
                    [drawEnitiyArray addObject:entity];
                    if (line == _chartLineArray.firstObject) {//基准线
                        [pointArrayForSelect addObject:[[NSValue alloc] initWithBytes:&startPoint objCType:@encode(CGPoint)]];
                        if (i == line.dataArray.count - 2) {
                            [pointArrayForSelect addObject:[[NSValue alloc] initWithBytes:&endPoint objCType:@encode(CGPoint)]];
                        }
                    }
                }
                    
                    break;
                case KYBChartLineType_K://k线
                    
                    break;
                    
                default:
                    break;
            }
        }
        [lineArrayForDraw addObject:drawEnitiyArray];
    }
    self.contentChart.lineArrayForDraw = lineArrayForDraw;
    self.contentChart.pointArrayForSelect = pointArrayForSelect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    #pragma mark 画辅助线
    if (_showReferenceLine && _shouldShowReferenceLine) {
        CGPoint closePoint = [self.contentChart closePointWithTouchPoint:self.contentChart.touchPint];
        CGPoint _closePoint = [self covertPointFromContentChart:closePoint];
        [KYBStockChartCommon drawLine:context
                           startPoint:CGPointMake([self covertPointFromContentChart:self.contentChart.originPoint].x, closePoint.y)
                             endPoint:CGPointMake([self covertPointFromContentChart:self.contentChart.rightBottomPoint].x, closePoint.y)
                            lineColor:AxisColor
                                width:0.2];
        [KYBStockChartCommon drawLine:context
                           startPoint:CGPointMake(_closePoint.x, [self covertPointFromContentChart:self.contentChart.leftTopPoint].y)
                             endPoint:CGPointMake(_closePoint.x, [self covertPointFromVolumnChart:self.volumnChart.originPoint].y)
                            lineColor:AxisColor
                                width:0.2];
        CGRect refSideLabelRect;
        if (closePoint.x < self.contentChart.xLen/2 + self.contentChart.edgeInsets.left) {
            refSideLabelRect = CGRectMake(self.contentChart.rightBottomPoint.x - 60, closePoint.y - 7.5, 60, 15);
        }else{
            refSideLabelRect = CGRectMake(self.contentChart.originPoint.x, closePoint.y - 7.5, 60, 15);
        }
        CGRect _refLabelRect = [self covertRectFromContentChart:refSideLabelRect];
        [KYBStockChartCommon drawRect:context rect:_refLabelRect fillColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
        
        CGRect refBottomLabelRect;
        CGFloat refBottomLabelX = _closePoint.x;
        if (refBottomLabelX < [self covertPointFromContentChart:self.contentChart.originPoint].x + 30) {
            refBottomLabelX = [self covertPointFromContentChart:self.contentChart.originPoint].x + 30;
        }else if (refBottomLabelX > [self covertPointFromContentChart:self.contentChart.rightBottomPoint].x - 30){
            refBottomLabelX = [self covertPointFromContentChart:self.contentChart.rightBottomPoint].x - 30;
        }
        refBottomLabelRect = CGRectMake(refBottomLabelX - 30, self.volumnChart.frame.origin.y + (self.volumnChart.frame.size.height - 15) * 0.5 , 60, 15);
        [KYBStockChartCommon drawRect:context rect:refBottomLabelRect fillColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
    }
}

-(CGPoint)covertPointFromContentChart:(CGPoint)pointInContentChart{
    return [self convertPoint:pointInContentChart fromView:self.contentChart];
}

-(CGRect)covertRectFromContentChart:(CGRect)rectInContentChart{
    return [self convertRect:rectInContentChart fromView:self.contentChart];
}

-(CGPoint)covertPointFromVolumnChart:(CGPoint)pointInVolumnChart{
    return [self convertPoint:pointInVolumnChart fromView:self.volumnChart];
}


@end
