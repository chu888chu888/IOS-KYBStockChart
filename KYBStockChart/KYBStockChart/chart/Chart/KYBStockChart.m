//
//  KYBStockBaseChart.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "KYBStockChart.h"
#import "NSString+UILabel.h"
#import "LineForDrawEntity.h"
#import "PointForSelectEntity.h"

@interface KYBStockChart()

@property UILongPressGestureRecognizer *longPressGesture;


@end

@implementation KYBStockChart

-(instancetype)initWithFrame:(CGRect)frame absRange:(CGFloat)range startYValue:(CGFloat)startYValue{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxY = startYValue + range;
        self.minY = startYValue - range;
        [self initBaseData];
//        [self initGesture];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseData];
    }
    return self;
}

-(void)initBaseData{
    _lineArrayForDraw = [NSMutableArray array];
    _pointArrayForSelect = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    _graduationFont = [UIFont systemFontOfSize:8];
    _lineNameFont = [UIFont systemFontOfSize:10];
    [self setEdgeInsets:UIEdgeInsetsMake(10, 40, 20, 20)];
    _leftGraduationArray = [NSMutableArray array];
    _rightGraduationArray = [NSMutableArray array];
    _touchPint = self.originPoint;
    _X_COUNT = DEFAULT_X_COUNT;
    _Y_COUNT = DEFAULT_Y_COUNT;
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
    
    if (self.xLen != 0 && self.xStepLen != 0) {
        NSInteger n = floorf(self.xLen/4/self.xStepLen);
        CGFloat bottomGraduationStepLen = n * self.xStepLen;
        
        NSInteger n1 = self.xLen / bottomGraduationStepLen + 1;//总轴条数
        
        for(int i = 0 ; i < n1; i ++){
            CGFloat xPosition = self.originPoint.x + bottomGraduationStepLen * i;
            if (i > 0) {
                [KYBStockChartCommon drawLine:context
                                   startPoint:CGPointMake(xPosition, self.originPoint.y)
                                     endPoint:CGPointMake(xPosition, self.leftTopPoint.y)
                                    lineColor:AxisColor width:0.2];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(KYBStockChart:bottomGraduationAtIndex:)]) {
                NSString *valStr = [_delegate KYBStockChart:self bottomGraduationAtIndex:i * n];
                
                CGSize titleSize = [valStr fixSizeWithFont:_graduationFont];
                CGFloat xStrPosition;
                if (i == 0) {
                    xStrPosition = xPosition;
                }else{
                    xStrPosition = xPosition - titleSize.width / 2;
                }
                
                CGRect titleRect = CGRectMake(xStrPosition,
                                              self.originPoint.y  + 5,
                                              titleSize.width,
                                              titleSize.height);
                [valStr drawInRect:titleRect withFont:_graduationFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
            }
        }
    }
    
    
    
#pragma mark 画x轴
    [KYBStockChartCommon drawLine:context
                       startPoint:CGPointMake(self.originPoint.x, self.originPoint.y)
                         endPoint:CGPointMake(self.rightBottomPoint.x, self.rightBottomPoint.y)
                        lineColor:Axis0Color width:0.2];
    //画纵轴线
    if (_showYAxis) {
        for(int i = 1 ; i <= _Y_COUNT ; i ++){
            CGFloat xPosition = self.originPoint.x + self.xLen / (_Y_COUNT + 1) * i;
            [KYBStockChartCommon drawLine:context
                               startPoint:CGPointMake(xPosition, self.originPoint.y)
                                 endPoint:CGPointMake(xPosition, self.leftTopPoint.y)
                                lineColor:AxisColor width:0.2];
        }
    }
    
    CGFloat dashPattern[]= {4, 4};
    CGContextSetLineDash(context, 0.0, dashPattern, 2); //虚线效果
    for(int i = 1 ; i <= _X_COUNT ; i ++){
        CGFloat yPosition = self.originPoint.y - self.yLen / _X_COUNT * i;
        [KYBStockChartCommon drawLine:context
                           startPoint:CGPointMake(self.originPoint.x, yPosition)
                             endPoint:CGPointMake(self.rightBottomPoint.x, yPosition)
                            lineColor:AxisColor
                                width:i == _X_COUNT ? 0.1 : 0.2];
    }
    
#pragma mark 画左刻度
    for (int i = 0; i < _leftGraduationArray.count; i++) {
        if (_delegate && [_delegate respondsToSelector:@selector(KYBStockChart:textColorForLeftGraduationAtRow:)]) {
            UIColor *color = [_delegate KYBStockChart:self textColorForLeftGraduationAtRow:i];
            [color set];
        }else{
            [XYTextColor set];
        }
        NSString *valStr = _leftGraduationArray[i];
        CGFloat yPosition = self.originPoint.y - self.yLen / _X_COUNT * i;
        CGSize titleSize = [valStr fixSizeWithFont:_graduationFont];
        CGRect titleRect = CGRectMake(self.edgeInsets.left - titleSize.width - 5,
                                      yPosition - (titleSize.height)/2,
                                      titleSize.width,
                                      titleSize.height);
        [valStr drawInRect:titleRect withFont:_graduationFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
    }
    
#pragma mark 画右刻度
    for (int i = 0; i < _rightGraduationArray.count; i++) {
        if (_delegate && [_delegate respondsToSelector:@selector(KYBStockChart:textColorForRightGraduationAtRow:)]) {
            UIColor *color = [_delegate KYBStockChart:self textColorForLeftGraduationAtRow:i];
            [color set];
        }else{
            [XYTextColor set];
        }
        NSString *valStr = _rightGraduationArray[i];
        CGFloat yPosition = self.originPoint.y - self.yLen / _X_COUNT * i;
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
            xPosition = self.originPoint.x + self.xLen / (_Y_COUNT + 1) * i - titleSize.width / 2;
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
            LineForDrawEntity *_obj = (LineForDrawEntity*)obj;
            switch (_obj.lineType) {
                case KYBChartLineType_MA:
                    for (LineForDrawEntity *entity in lineEntities) {
                        [entity drawLine:context];
                    }
                    break;
                case KYBChartLineType_TS:{
                    if (lineEntities.count == 0) {
                        break;
                    }
                    CGContextSetLineWidth(context, 0.0f);
                    LineForDrawEntity *firstLineForDrawEntity = lineEntities.firstObject;
                    CGContextMoveToPoint(context, firstLineForDrawEntity.startPoint.x, firstLineForDrawEntity.startPoint.y);
                    for (LineForDrawEntity *entity in lineEntities) {
                        CGContextAddLineToPoint(context, entity.endPoint.x, entity.endPoint.y);
                    }
                    CGContextAddLineToPoint(context, self.rightBottomPoint.x, self.rightBottomPoint.y);
                    CGContextAddLineToPoint(context, self.originPoint.x,self.originPoint.y);
                    CGContextAddLineToPoint(context, firstLineForDrawEntity.startPoint.x,firstLineForDrawEntity.startPoint.y);
                    CGContextClosePath(context);
                    CGContextSetFillColorWithColor(context, firstLineForDrawEntity.fillColor.CGColor);
                    CGContextDrawPath(context, kCGPathFill);
                    for (LineForDrawEntity *entity in lineEntities) {
                        [entity drawLine:context];
                    }
                }
                    break;
                default:
                    break;
            }
            
        }
    }
    
    //测试画蜡烛线
//    [KYBStockChartCommon drawCandle:context rect:CGRectMake(self.originPoint.x + 5, self.leftTopPoint.y + 5, 5, 20) top:3 bottom:3 color:StockGreen];
    
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
    NSInteger xStep = (NSInteger)((touchPoint.x - self.originPoint.x)/self.xStepLen + 0.5);//第几个x轴单位坐标点
    if (xStep > self.pointCount - 1) {
        xStep = self.pointCount - 1;
    }
    NSValue *value = self.pointArrayForSelect[xStep];
    CGPoint selectedPoint;
    [value getValue:&selectedPoint];
    //    NSLog(@"%f",(touchPoint.x - self.originPoint.x)/_xStepLen);
    return selectedPoint;
}

-(NSInteger)closeIndexWithTouchPoint:(CGPoint)touchPoint{
    NSInteger xStep = (NSInteger)((touchPoint.x - self.originPoint.x)/self.xStepLen + 0.5);//第几个x轴单位坐标点
    if (xStep > self.pointCount - 1) {
        xStep = self.pointCount - 1;
    }
    return xStep;
}

@end
