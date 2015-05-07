//
//  KYBChartControlBar.m
//  KYBStockChart
//
//  Created by icode on 15/5/7.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "KYBChartControlBar.h"
#import "KYBStockChartCommon.h"

@interface KYBChartControlBar()

@property (nonatomic,weak) ControlBtn *leftControlBtn;
@property (nonatomic,weak) ControlBtn *rightControlBtn;
@property (nonatomic,weak) CoverView *leftView;
@property (nonatomic,weak) CoverView *rightView;
@property (nonatomic,weak) UIView *centerCoverView;

@property (nonatomic,assign) NSInteger leftIndex;

@property (nonatomic,assign) NSInteger rightIndex;

@property (nonatomic,assign) CGFloat minDis;

@property (nonatomic,assign) NSInteger startPointX;

@end

@implementation KYBChartControlBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initSubviews];
    }
    return self;
}

-(void)initData{
    self.pointCount = 2;
    self.minDisPointCount = 2;
    self.leftIndex = 0;
    self.rightIndex = 1;
}

-(void)initSubviews{
    CoverView *leftView = [[CoverView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
    leftView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [self addSubview:leftView];
    _leftView = leftView;
    
    CoverView *rightView = [[CoverView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 1, self.frame.size.height)];
    rightView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [self addSubview:rightView];
    _rightView = rightView;
    
    UIPanGestureRecognizer *centerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelCenterCoverViewPan:)];
    UIView *centerCoverView = [[UIView alloc] initWithFrame:self.bounds];
    centerCoverView.backgroundColor = [UIColor clearColor];
    [centerCoverView addGestureRecognizer:centerPanGesture];
    [self addSubview:centerCoverView];
    _centerCoverView = centerCoverView;
    
    UIPanGestureRecognizer *leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    ControlBtn *leftControlBtn = [[ControlBtn alloc] initWithFrame:CGRectMake(- 7.5, 0, 15, self.frame.size.height)];
    [leftControlBtn setBackgroundColor:[UIColor clearColor]];
    [leftControlBtn addGestureRecognizer:leftPanGesture];
    [self addSubview:leftControlBtn];
    _leftControlBtn = leftControlBtn;
    
    UIPanGestureRecognizer *rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    ControlBtn *rightControlBtn = [[ControlBtn alloc] initWithFrame:CGRectMake(self.frame.size.width - 7.5, 0, 15, self.frame.size.height)];
    [rightControlBtn setBackgroundColor:[UIColor clearColor]];
    [rightControlBtn addGestureRecognizer:rightPanGesture];
    [self addSubview:rightControlBtn];
    _rightControlBtn = rightControlBtn;
}

-(void)setPointCount:(NSInteger)pointCount{
    if (pointCount < 2) {
        return;
    }
    _pointCount = pointCount;
    _rightIndex = pointCount - 1;
}

-(void)setMinDisPointCount:(NSInteger)minDisPointCount{
    if (minDisPointCount < 2) {
        return;
    }
    if (minDisPointCount > _pointCount) {
        _minDisPointCount = _pointCount;
    }else{
        _minDisPointCount = minDisPointCount;
    }
    _minDis = self.frame.size.width * (minDisPointCount - 1) / (_pointCount - 1) ;
}

-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint curPoint = [gestureRecognizer locationInView:self];
    CGFloat centerX = curPoint.x;
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (gestureRecognizer.view == _leftControlBtn) {
            if (centerX >= _rightControlBtn.center.x - _minDis) {
                centerX = _rightControlBtn.center.x - _minDis;
            }
            if (centerX <= 0) {
                centerX = 0;
            }
            [gestureRecognizer.view setCenter:CGPointMake(centerX, gestureRecognizer.view.center.y)];
            _leftView.frame = CGRectMake(0, 0, centerX, _leftView.frame.size.height);
            _centerCoverView.frame = CGRectMake(_leftView.frame.size.width, 0, _rightView.frame.origin.x - centerX, _centerCoverView.frame.size.height);
        }else if (gestureRecognizer.view == _rightControlBtn){
            if (centerX <= _leftControlBtn.center.x + _minDis) {
                centerX = _leftControlBtn.center.x + _minDis;
            }
            if (centerX >= self.frame.size.width) {
                centerX = self.frame.size.width;
            }
            [gestureRecognizer.view setCenter:CGPointMake(centerX, gestureRecognizer.view.center.y)];
            _rightView.frame = CGRectMake(centerX, 0, self.frame.size.width - centerX, _rightView.frame.size.height);
            _centerCoverView.frame = CGRectMake(_leftView.frame.size.width, 0, self.frame.size.width - _leftView.frame.size.width - _rightView.frame.size.width, _centerCoverView.frame.size.height);
        }
        
        
        
        
        NSInteger index = floorf(centerX * _pointCount / self.frame.size.width);
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(KYBChartControlBarOnChangeWithStartIndex:endIndex:)]) {
                BOOL needChange = NO;
                if (gestureRecognizer.view == _leftControlBtn) {
                    if (self.leftIndex != index) {
                        self.leftIndex = index;
                        needChange = YES;
                    }
                }
                else if (gestureRecognizer.view == _rightControlBtn) {
                    if (self.rightIndex != index) {
                        self.rightIndex = index;
                        needChange = YES;
                    }
                }
                if (needChange) {
                    [self.delegate KYBChartControlBarOnChangeWithStartIndex:self.leftIndex endIndex:self.rightIndex];
                }
            }
        }
    }
    
}

-(void)handelCenterCoverViewPan:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint curPoint = [gestureRecognizer locationInView:self];
    CGFloat centerX = curPoint.x;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (gestureRecognizer.view == _centerCoverView) {
            self.startPointX = centerX;
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat deltaX = centerX - self.startPointX;
        self.startPointX = centerX;
//        NSLog(@"%f", deltaX);
        CGFloat centerCoverCenterX = _centerCoverView.center.x + deltaX;
        if (centerCoverCenterX < _centerCoverView.frame.size.width / 2) {
            centerCoverCenterX = _centerCoverView.frame.size.width / 2;
        }
        if (centerCoverCenterX > self.frame.size.width -  _centerCoverView.frame.size.width / 2) {
            centerCoverCenterX = self.frame.size.width -  _centerCoverView.frame.size.width / 2;
        }
        _centerCoverView.center = CGPointMake(centerCoverCenterX, _centerCoverView.center.y);
        
        _leftView.frame = CGRectMake(0, 0, _centerCoverView.frame.origin.x, _leftView.frame.size.height);
        [_leftControlBtn setCenter:CGPointMake(gestureRecognizer.view.frame.origin.x, _leftControlBtn.center.y)];
        _rightView.frame = CGRectMake(_centerCoverView.frame.origin.x + _centerCoverView.frame.size.width, 0, self.frame.size.width - _centerCoverView.frame.origin.x - _centerCoverView.frame.size.width, _rightView.frame.size.height);
        [_rightControlBtn setCenter:CGPointMake(_rightView.frame.origin.x, _rightControlBtn.center.y)];
        
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(KYBChartControlBarOnChangeWithStartIndex:endIndex:)]) {
                BOOL needChange = NO;
                NSInteger leftIndex = floorf(_leftControlBtn.center.x * _pointCount / self.frame.size.width);
                NSInteger rightIndex = floorf(_rightControlBtn.center.x * _pointCount / self.frame.size.width);
                if (self.leftIndex != leftIndex) {
                    self.leftIndex = leftIndex;
                    needChange = YES;
                }
                if (self.rightIndex != rightIndex) {
                    self.rightIndex = rightIndex;
                    needChange = YES;
                }
                if (needChange) {
                     [self.delegate KYBChartControlBarOnChangeWithStartIndex:self.leftIndex endIndex:self.rightIndex];
                }
            }
        }
        
    }
    
}

-(void)setRightIndex:(NSInteger)rightIndex{
    if (rightIndex > _pointCount - 1) {
        rightIndex = _pointCount - 1;
    }else{
        _rightIndex = rightIndex;
    }
}

-(void)setLeftIndex:(NSInteger)leftIndex{
    if (leftIndex < 0) {
        leftIndex = 0;
    }else{
        _leftIndex = leftIndex;
    }
}

@end

@implementation ControlBtn

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineDash(context,0,normal,0);
    [KYBStockChartCommon drawLine:context startPoint:CGPointMake(self.frame.size.width * 0.5, 0) endPoint:CGPointMake(self.frame.size.width *0.5, self.frame.size.height) lineColor:[UIColor blackColor] width:0.5f];
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat marginTop = 8.0f;
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    CGFloat radius = (width + height) * 0.05;
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.8f);
    // 移动到初始点
    CGContextMoveToPoint(context, radius, marginTop);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius, marginTop);
    CGContextAddArc(context, width - radius, radius + marginTop, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width, height - radius - marginTop);
    CGContextAddArc(context, width - radius, height - radius - marginTop, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius, height - marginTop);
    CGContextAddArc(context, radius, height - radius - marginTop, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, 0, radius + marginTop);
    CGContextAddArc(context, radius , radius + marginTop, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明黑色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGFloat marginTop2 = marginTop + 3;
    [KYBStockChartCommon drawLine:context startPoint:CGPointMake(self.frame.size.width /3, marginTop2) endPoint:CGPointMake(self.frame.size.width /3, self.frame.size.height - marginTop2) lineColor:[UIColor blackColor] width:0.5f];
    [KYBStockChartCommon drawLine:context startPoint:CGPointMake(self.frame.size.width * 2 / 3, marginTop2) endPoint:CGPointMake(self.frame.size.width * 2 / 3, self.frame.size.height - marginTop2) lineColor:[UIColor blackColor] width:0.5f];
    
    
    //    CGContextSetLineWidth(context, 0.5f);
    //    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //    CGRect rectangle = CGRectMake(0 , 5 ,self.frame.size.width , self.frame.size.height - 10);
    //    CGContextAddRect(context, rectangle);
    //    CGContextStrokePath(context);
    //    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //    CGContextFillRect(context, rectangle);
}

@end

@implementation CoverView

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineDash(context,0,normal,0);
    [KYBStockChartCommon drawLine:context startPoint:CGPointMake(0, 0) endPoint:CGPointMake(self.frame.size.width, 0) lineColor:[UIColor blackColor] width:1.0f];
}

@end