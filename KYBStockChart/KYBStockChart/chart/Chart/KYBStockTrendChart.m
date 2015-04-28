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

@property (nonatomic,weak) KYBReferenceView *referenceView;

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
    NSArray *bottomArray = @[@"09:30",@"10:30",@"11:30/13:00",@"14:00",@"15:00"];
    KYBStockChart *baseChart = [[KYBStockChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8) absRange:_range startYValue:_startYValue];
    baseChart.showYAxis = YES;
    baseChart.userInteractionEnabled = NO;
    baseChart.bottomGraduationArray = bottomArray;
    [self addSubview:baseChart];
    _contentChart = baseChart;
    
    KYBStockVolumeChart *volumnChart = [[KYBStockVolumeChart alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseChart.frame), self.frame.size.width, self.frame.size.height * 0.2)];
    [self addSubview:volumnChart];
    _volumnChart = volumnChart;
    
    KYBReferenceView *referenceView = [[KYBReferenceView alloc] initWithFrame:self.bounds];
    referenceView.backgroundColor = [UIColor clearColor];
    [self addSubview:referenceView];
    _referenceView = referenceView;
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
    [self refreshReferenView];
}

-(void)setPointCount:(NSInteger)pointCount{
    _pointCount = pointCount;
    self.volumnChart.pointCount = pointCount;
    self.contentChart.pointCount = pointCount;
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

- (void)refreshReferenView{
    if (!_showReferenceLine) {
        return;
    }
    _referenceView.shouldShowReferenceLine = self.shouldShowReferenceLine;
    CGPoint closePoint = [self.contentChart closePointWithTouchPoint:self.contentChart.touchPint];
    CGPoint _closePoint = [self covertPointFromContentChart:closePoint];
    _referenceView.hPoint1 = CGPointMake([self covertPointFromContentChart:self.contentChart.originPoint].x, closePoint.y);
    _referenceView.hPoint2 = CGPointMake([self covertPointFromContentChart:self.contentChart.rightBottomPoint].x, closePoint.y);
    _referenceView.vPoint1 = CGPointMake(_closePoint.x, [self covertPointFromContentChart:self.contentChart.leftTopPoint].y);
    _referenceView.vPoint2 = CGPointMake(_closePoint.x, [self covertPointFromVolumnChart:self.volumnChart.originPoint].y);
    CGRect refSideLabelRect;
    if (closePoint.x < self.contentChart.xLen/2 + self.contentChart.edgeInsets.left) {
        refSideLabelRect = CGRectMake(self.contentChart.rightBottomPoint.x - 60, closePoint.y - 7.5, 60, 15);
    }else{
        refSideLabelRect = CGRectMake(self.contentChart.originPoint.x, closePoint.y - 7.5, 60, 15);
    }
    _referenceView.sideLabelRect = [self covertRectFromContentChart:refSideLabelRect];
    CGFloat refBottomLabelX = _closePoint.x;
    if (refBottomLabelX < [self covertPointFromContentChart:self.contentChart.originPoint].x + 30) {
        refBottomLabelX = [self covertPointFromContentChart:self.contentChart.originPoint].x + 30;
    }else if (refBottomLabelX > [self covertPointFromContentChart:self.contentChart.rightBottomPoint].x - 30){
        refBottomLabelX = [self covertPointFromContentChart:self.contentChart.rightBottomPoint].x - 30;
    }
    _referenceView.bottomLabelRect = CGRectMake(refBottomLabelX - 30, self.volumnChart.frame.origin.y + (self.volumnChart.frame.size.height - 15) * 0.5 , 60, 15);
    [_referenceView setNeedsDisplay];
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

@implementation KYBReferenceView

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    #pragma mark 画辅助线
    if (_shouldShowReferenceLine) {
        [KYBStockChartCommon drawLine:context startPoint:_hPoint1 endPoint:_hPoint2 lineColor:AxisColor width:0.2];
        [KYBStockChartCommon drawLine:context startPoint:_vPoint1 endPoint:_vPoint2 lineColor:AxisColor width:0.2];
        [KYBStockChartCommon drawRect:context rect:_sideLabelRect fillColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
        [KYBStockChartCommon drawRect:context rect:_bottomLabelRect fillColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
    }
}

@end
