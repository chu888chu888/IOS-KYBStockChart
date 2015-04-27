//
//  KYBStockBaseChart.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "KYBStockBaseChart.h"
#import "NSString+UILabel.h"
#import "LineForDrawEntity.h"

@interface KYBStockBaseChart()

@property CGPoint originPoint;//左下点

@property CGPoint leftTopPoint;//左上点

@property CGPoint rightBottomPoint;//右下点

@property CGFloat xLen;//x轴长度

@property CGFloat yLen;//y轴长度

@property CGFloat xStepLen;//x轴单位刻度长度

@property UILongPressGestureRecognizer *longPressGesture;

@property CGPoint touchPint;

@property (nonatomic,strong) NSMutableArray *lineArrayForDraw;

@property (nonatomic,strong) NSMutableArray *pointArrayForSelect;

@property (nonatomic,assign) BOOL shouldShowReferenceLine;

@end

@implementation KYBStockBaseChart

-(instancetype)initWithFrame:(CGRect)frame absRange:(CGFloat)range startYValue:(CGFloat)startYValue{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxY = startYValue + range;
        self.minY = startYValue - range;
        [self initBaseData];
        [self initGesture];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseData];
        [self initGesture];
    }
    return self;
}

-(void)initBaseData{
    _lineArrayForDraw = [NSMutableArray array];
    _pointArrayForSelect = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    _graduationFont = [UIFont systemFontOfSize:8];
    _lineNameFont = [UIFont systemFontOfSize:10];
    [self setEdgeInsets:UIEdgeInsetsMake(30, 40, 20, 20)];
    _leftGraduationArray = [NSMutableArray arrayWithCapacity:DEFAULT_X_COUNT + 1];
    _rightGraduationArray = [NSMutableArray arrayWithCapacity:DEFAULT_X_COUNT + 1];
    _touchPint = self.originPoint;
}

-(void)initGesture{
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPressGesture.minimumPressDuration = 0.5;
    //    _longPressGesture.
    [self addGestureRecognizer:_longPressGesture];
}

-(void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
    _originPoint = CGPointMake(edgeInsets.left, self.frame.size.height - edgeInsets.bottom);
    _leftTopPoint = CGPointMake(edgeInsets.left, edgeInsets.top);
    _rightBottomPoint = CGPointMake(self.frame.size.width - edgeInsets.right, self.frame.size.height - edgeInsets.bottom);
    _xLen = self.frame.size.width - edgeInsets.left - edgeInsets.right;
    _yLen = self.frame.size.height - edgeInsets.top - edgeInsets.bottom;
    if (_pointCount > 0) {
        _xStepLen = _xLen /(_pointCount - 1);
    }
}

-(void)setPointCount:(NSInteger)pointCount{
    _pointCount = pointCount;
    if (pointCount > 0 ) {
        _xStepLen = _xLen /(_pointCount - 1);
    }
}

-(void)setChartLineArray:(NSMutableArray *)chartLineArray{
    _chartLineArray = chartLineArray;
    [_lineArrayForDraw removeAllObjects];
    [_pointArrayForSelect removeAllObjects];
    for(KYBChartLineEntity *line in _chartLineArray){
        NSMutableArray *drawEnitiyArray = [NSMutableArray array];
        for (int i = 0; i < line.dataArray.count - 1; i++) {
            TSMAEntity *entity1 = line.dataArray[i];
            TSMAEntity *entity2 = line.dataArray[i + 1];
            CGFloat xPosition1 = self.originPoint.x + self.xStepLen * i;
            CGFloat xPosition2 = self.originPoint.x + self.xStepLen * (i + 1);
            CGFloat yPosition1 = [self getYpositionWithValue:entity1.value];
            CGFloat yPosition2 = [self getYpositionWithValue:entity2.value];
            switch (line.type) {
                case KYBChartLineType_TS://分时
                case KYBChartLineType_MA://均线
                {
                    CGPoint startPoint = CGPointMake(xPosition1, yPosition1);
                    CGPoint endPoint = CGPointMake(xPosition2, yPosition2);
                    LineForDrawEntity *entity = [[LineForDrawEntity alloc] init];
                    entity.startPoint = startPoint;
                    entity.endPoint = endPoint;
                    entity.lineColor = line.lineColor;
                    entity.thickness = line.thickness;
                    [drawEnitiyArray addObject:entity];
                    if (line == _chartLineArray.firstObject) {//基准线
                        [_pointArrayForSelect addObject:[[NSValue alloc] initWithBytes:&startPoint objCType:@encode(CGPoint)]];
                        if (i == line.dataArray.count - 2) {
                            [_pointArrayForSelect addObject:[[NSValue alloc] initWithBytes:&endPoint objCType:@encode(CGPoint)]];
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
        [_lineArrayForDraw addObject:drawEnitiyArray];
    }
    
    
}

-(void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat touchPointX = touchPoint.x;
        CGFloat touchPointY = touchPoint.y;
        if (touchPointX < self.originPoint.x) {
            touchPointX = self.originPoint.x;
        }else if (touchPointX > self.rightBottomPoint.x){
            touchPointX = self.rightBottomPoint.x;
        }
        
        if (touchPointY < self.leftTopPoint.y) {
            touchPointY = self.leftTopPoint.y;
        }else if (touchPoint.y > self.originPoint.y){
            touchPointY = self.originPoint.y;
        }
        _shouldShowReferenceLine = YES;
        _touchPint = CGPointMake(touchPointX, touchPointY);
    }else{
        _shouldShowReferenceLine = NO;
    }
    [self setNeedsDisplay];
}


-(void)refresh{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
#pragma mark 画y轴
    CGContextSetLineDash(context,0,normal,0);
    [KYBStockChartCommon drawLine:context
                       startPoint:self.originPoint
                         endPoint:self.leftTopPoint
                        lineColor:Axis0Color width:0.2];
    //画x轴
    [KYBStockChartCommon drawLine:context
                       startPoint:CGPointMake(self.originPoint.x, self.originPoint.y)
                         endPoint:CGPointMake(self.rightBottomPoint.x, self.rightBottomPoint.y)
                        lineColor:Axis0Color width:0.2];
    //画纵轴线
    if (_showYAxis) {
        for(int i = 1 ; i <= DEFAULT_Y_COUNT ; i ++){
            CGFloat xPosition = self.originPoint.x + _xLen / (DEFAULT_Y_COUNT + 1) * i;
            [KYBStockChartCommon drawLine:context
                               startPoint:CGPointMake(xPosition, self.originPoint.y)
                                 endPoint:CGPointMake(xPosition, self.leftTopPoint.y)
                                lineColor:AxisColor width:0.2];
        }
    }
    
    CGFloat dashPattern[]= {4, 4};
    CGContextSetLineDash(context, 0.0, dashPattern, 2); //虚线效果
    for(int i = 1 ; i <= DEFAULT_X_COUNT ; i ++){
        CGFloat yPosition = self.originPoint.y - _yLen / DEFAULT_X_COUNT * i;
        [KYBStockChartCommon drawLine:context
                           startPoint:CGPointMake(self.originPoint.x, yPosition)
                             endPoint:CGPointMake(self.rightBottomPoint.x, yPosition)
                            lineColor:AxisColor
                                width:i == DEFAULT_X_COUNT ? 0.1 : 0.2];
    }
    
#pragma mark 画左刻度
    for (int i = 0; i < _leftGraduationArray.count; i++) {
        if (i < 2) {
            [StockGreen set];
        }else if (i == 2){
            [XYTextColor set];
        }else{
            [StockRed set];
        }
        NSString *valStr = _leftGraduationArray[i];
        CGFloat yPosition = self.originPoint.y - _yLen / DEFAULT_X_COUNT * i;
        CGSize titleSize = [valStr fixSizeWithFont:_graduationFont];
        CGRect titleRect = CGRectMake(_edgeInsets.left - titleSize.width - 5,
                                      yPosition - (titleSize.height)/2,
                                      titleSize.width,
                                      titleSize.height);
        [valStr drawInRect:titleRect withFont:_graduationFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
    }
    
#pragma mark 画右刻度
    for (int i = 0; i < _rightGraduationArray.count; i++) {
        if (i < 2) {
            [StockGreen set];
        }else if (i == 2){
            [XYTextColor set];
        }else{
            [StockRed set];
        }
        NSString *valStr = _rightGraduationArray[i];
        CGFloat yPosition = self.originPoint.y - _yLen / DEFAULT_X_COUNT * i;
        CGSize titleSize = [valStr fixSizeWithFont:_graduationFont];
        CGRect titleRect = CGRectMake(self.rightBottomPoint.x - titleSize.width,
                                      yPosition - (titleSize.height)/2,
                                      titleSize.width,
                                      titleSize.height);
        [valStr drawInRect:titleRect withFont:_graduationFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
    }
    
    [XYTextColor set];
    
#pragma mark 画下刻度
    for (int i = 0; i < _bottomGraduationArray.count; i++) {
        NSString *valStr = _bottomGraduationArray[i];
        CGSize titleSize = [valStr fixSizeWithFont:_graduationFont];
        CGFloat xPosition;
        if (i == 0) {
            xPosition = self.originPoint.x;
        }else if(i == _bottomGraduationArray.count - 1){
            xPosition = self.rightBottomPoint.x - titleSize.width;
        }else{
            xPosition = self.originPoint.x + _xLen / (DEFAULT_Y_COUNT + 1) * i - titleSize.width / 2;
        }
        
        CGRect titleRect = CGRectMake(xPosition,
                                      self.originPoint.y  + 5,
                                      titleSize.width,
                                      titleSize.height);
        [valStr drawInRect:titleRect withFont:_graduationFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
    }
    
#pragma mark 画左下刻度
    if (_bottomLeftGraduation) {
        CGSize titleSize = [_bottomLeftGraduation fixSizeWithFont:_graduationFont];
        CGRect titleRect = CGRectMake(self.originPoint.x,
                                      self.originPoint.y  + 5,
                                      titleSize.width,
                                      titleSize.height);
        [_bottomLeftGraduation drawInRect:titleRect withFont:_graduationFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
    }
    
#pragma mark 画右下刻度
    if (_bottomRightGraduation) {
        CGSize titleSize = [_bottomRightGraduation fixSizeWithFont:_graduationFont];
        CGRect titleRect = CGRectMake(self.rightBottomPoint.x - titleSize.width,
                                      self.rightBottomPoint.y + 5,
                                      titleSize.width,
                                      titleSize.height);
        [_bottomRightGraduation drawInRect:titleRect withFont:_graduationFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
    }
    
#pragma mark 画线名
    if (_showLineName) {
        CGFloat nameX = self.originPoint.x;
        for(KYBChartLineEntity *line in _chartLineArray){
            if (line.type == KYBChartLineType_MA) {
                if (line.lineColor) {
                    [line.lineColor set];
                }else{
                    [XYTextColor set];
                }
                if (line.name) {
                    CGSize titleSize = [line.name fixSizeWithFont:_lineNameFont];
                    CGRect titleRect = CGRectMake(nameX,
                                                  self.leftTopPoint.y - titleSize.height - 5,
                                                  titleSize.width,
                                                  titleSize.height);
                    [line.name drawInRect:titleRect withFont:_lineNameFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
                    nameX += titleSize.width + 5;
                }
                
            }
            
        }
    }
    
#pragma mark 画线
    CGContextSetLineDash(context,0,normal,0); //画实线
    for (NSMutableArray *lineEntities in _lineArrayForDraw) {
        if (lineEntities.count == 0) return;
        NSObject *obj = lineEntities.firstObject;
        if ([obj isKindOfClass:[LineForDrawEntity class]]) {
            for (LineForDrawEntity *entity in lineEntities) {
                [entity drawLine:context];
            }
        }
    }
    
    //测试画蜡烛线
    [KYBStockChartCommon drawCandle:context rect:CGRectMake(self.originPoint.x + 5, self.leftTopPoint.y + 5, 5, 20) top:3 bottom:3 color:StockGreen];
    
#pragma mark 画辅助线
    if (_showReferenceLine && _shouldShowReferenceLine) {
        CGPoint closePoint = [self closePointWithTouchPoint:_touchPint];
        //        CGContextSetLineDash(context, 0.0, dashPattern, 2); //虚线效果
        [KYBStockChartCommon drawLine:context
                           startPoint:CGPointMake(self.originPoint.x, closePoint.y)
                             endPoint:CGPointMake(self.rightBottomPoint.x, closePoint.y)
                            lineColor:AxisColor
                                width:0.2];
        [KYBStockChartCommon drawLine:context
                           startPoint:CGPointMake(closePoint.x, self.leftTopPoint.y)
                             endPoint:CGPointMake(closePoint.x, self.originPoint.y)
                            lineColor:AxisColor
                                width:0.2];
        CGRect refLabelRect;
        if (closePoint.x < _xLen/2 + self.edgeInsets.left) {
            refLabelRect = CGRectMake(self.rightBottomPoint.x - 60, closePoint.y - 7.5, 60, 15);
        }else{
            refLabelRect = CGRectMake(self.originPoint.x, closePoint.y - 7.5, 60, 15);
        }
        [KYBStockChartCommon drawRect:context rect:refLabelRect fillColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
    }
    
}

//根据值获得y坐标
-(CGFloat)getYpositionWithValue:(CGFloat)value{
    return self.originPoint.y - (value - self.minY) * self.yLen / (self.maxY - self.minY);
}

//计算值在坐标系中的长度
-(CGFloat)getValueLen:(CGFloat)value{
    return value * self.yLen / (self.maxY - self.minY);
}

//获得距离触点最近的坐标位置
-(CGPoint)closePointWithTouchPoint:(CGPoint)touchPoint{
    NSInteger xStep = (NSInteger)((touchPoint.x - self.originPoint.x)/_xStepLen + 0.5);//第几个x轴单位坐标点
    NSValue *value = self.pointArrayForSelect[xStep];
    CGPoint selectedPoint;
    [value getValue:&selectedPoint];
    //    NSLog(@"%f",(touchPoint.x - self.originPoint.x)/_xStepLen);
    return selectedPoint;
}

@end
