//
//  KYBPortfolioChart.m
//  KYBStockChart
//
//  Created by icode on 15/5/4.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "KYBPortfolioChart.h"
#import "KYBStockChart.h"
#import "KYBChartControlBar.h"
#import "LineForDrawEntity.h"
#import "DataCommon.h"
#import "PointForSelectEntity.h"
#import "KYBChartReferenceView.h"

@interface KYBPortfolioChart()<KYBStockChartDelegate,KYBChartControlBarDelegate>

@property (nonatomic,weak) KYBStockChart *portfolioChart;

@property (nonatomic,weak) KYBStockChart *controlBarChart;

@property (nonatomic,weak) KYBChartControlBar *controlBar;

@property (nonatomic,strong) KYBChartLineEntity *balanceLineEntity;

@property (nonatomic,strong) KYBChartLineEntity *code300LineEntity;

@property (nonatomic,strong) KYBChartLineEntity *detailCountLineEntity;

@property (nonatomic,strong) NSMutableArray *dayValueArray;

@property (nonatomic,assign) NSRange selectedRange;

@property (nonatomic,weak) KYBChartReferenceView *referenceView;

@property (nonatomic,strong) ChartReferencePoint *code300Point;

@property (nonatomic,strong) ChartReferencePoint *balancePoint;

@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,assign) NSInteger lastSelectedIndex;

@property (nonatomic,assign) CGPoint currentPouchPoint;

@property (nonatomic,strong) UIView *floatDataView;

@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) UILabel *code300Label;

@property (nonatomic,strong) UILabel *balanceLabel;

@end


@implementation KYBPortfolioChart
@synthesize balanceLineEntity,code300LineEntity,detailCountLineEntity;
@synthesize dayValueArray;

-(instancetype)initWithframe:(CGRect)frame balanceArray:(NSArray *)balanceArray code300Array:(NSArray *)code300Array detailCountArray:(NSArray *)detailCountArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.balanceArray = balanceArray;
        self.code300Array = code300Array;
        self.detailCountArray = detailCountArray;
        [self initSubViews];
        [self initGesture];
        _selectedRange = NSMakeRange(0, code300Array.count);
        [self prepareRangeDataForShow];
        [self prepareForControlBarChart];
        [self prepareForPortfolioChart];
        [self createLineForDraw];
    }
    return self;
}

-(void)initSubViews{
    KYBStockChart *portfolioChart = [[KYBStockChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8)];
    portfolioChart.backgroundColor = [UIColor whiteColor];
    [self addSubview:portfolioChart];
    _portfolioChart = portfolioChart;
    portfolioChart.delegate = self;
    portfolioChart.X_COUNT = 4;
    portfolioChart.Y_COUNT = 5;
    
    KYBChartControlBar *controlBar = [[KYBChartControlBar alloc] initWithFrame:CGRectMake(portfolioChart.edgeInsets.left, CGRectGetMaxY(portfolioChart.frame), self.frame.size.width - portfolioChart.edgeInsets.left - portfolioChart.edgeInsets.right, self.frame.size.height * 0.15)];
    controlBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:controlBar];
    controlBar.pointCount = self.code300Array.count;
    controlBar.minDisPointCount = 5;
    controlBar.delegate = self;
    _controlBar = controlBar;
    
    KYBStockChart *controlBarChart = [[KYBStockChart alloc] initWithFrame:controlBar.bounds];
    controlBarChart.backgroundColor = [UIColor whiteColor];
    controlBarChart.edgeInsets = UIEdgeInsetsZero;
    controlBarChart.X_COUNT = 0;
    controlBarChart.Y_COUNT = 1;
    [controlBar addSubview:controlBarChart];
    [controlBar sendSubviewToBack:controlBarChart];
    _controlBarChart = controlBarChart;
    
    KYBChartReferenceView *referenceView = [[KYBChartReferenceView alloc] initWithFrame:portfolioChart.frame];
    referenceView.edgeInsets = portfolioChart.edgeInsets;
    referenceView.referenceType = KYBChartReferenceViewTypeVertical;
    referenceView.referenceLineColor = [UIColor darkGrayColor];
    referenceView.referenceLineThickness = 0.5f;
    
    _code300Point = [referenceView insertChartReferencePointWithPointType:KYBChartPointTypeCircle pointCenterPosition:CGPointMake(10, 10) radius:2 pointColor:UIColorFromRGB(0x8FB5EC) drawShadow:YES shadowColor:UIColorFromRGBAndAlpha(0x8FB5EC, 0.3f)];//300
    
    _balancePoint = [referenceView insertChartReferencePointWithPointType:KYBChartPointTypeSquare pointCenterPosition:CGPointMake(10, 30) radius:2 pointColor:UIColorFromRGB(0x8FB5EC) drawShadow:YES shadowColor:UIColorFromRGBAndAlpha(0x8FB5EC, 0.3f)];//净值
    [self addSubview:referenceView];
    _referenceView = referenceView;
    
    [self addSubview:[self floatDataView]];
}

-(void)initGesture{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPressGesture];
}

-(void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.portfolioChart];
    _currentPouchPoint = touchPoint;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat touchPointX = touchPoint.x;
        CGFloat touchPointY = touchPoint.y;
        if (touchPointX < self.portfolioChart.originPoint.x) {
            touchPointX = self.portfolioChart.originPoint.x;
        }else if (touchPointX > self.portfolioChart.rightBottomPoint.x){
            touchPointX = self.portfolioChart.rightBottomPoint.x;
        }
        
        if (touchPointY < self.portfolioChart.leftTopPoint.y) {
            touchPointY = self.portfolioChart.leftTopPoint.y;
        }else if (touchPoint.y > self.portfolioChart.originPoint.y){
            touchPointY = self.portfolioChart.originPoint.y;
        }
        _referenceView.showContent = YES;
        self.floatDataView.hidden = NO;
        self.lastSelectedIndex = self.selectedIndex;
        self.selectedIndex = [self.portfolioChart closeIndexWithTouchPoint:CGPointMake(touchPointX, touchPointY)];
    }else{
        _referenceView.showContent = NO;
        self.floatDataView.hidden = YES;
    }
    [self refreshReferenView];
}

-(void)refreshReferenView{
    PointForSelectEntity *selectedPoint_balance = self.balanceLineEntity.selectedPointArray[self.selectedIndex];
    PointForSelectEntity *selectedPoint_code300 = self.code300LineEntity.selectedPointArray[self.selectedIndex];
    self.code300Point.centerPoint = selectedPoint_balance.point;
    self.balancePoint.centerPoint = selectedPoint_code300.point;
    _referenceView.referenceLineCrossPoint = selectedPoint_balance.point;
    [_referenceView setNeedsDisplay];
    if (self.lastSelectedIndex != self.selectedIndex){
        DayValueObject *dayValue = dayValueArray[self.selectedIndex];
        _dateLabel.text = [DataCommon dateStringByTimeStamp:dayValue.dateNumber.longValue];
        _code300Label.text = [NSString stringWithFormat:@"沪深300指数:%.2f (%.2f%%)",dayValue.code300Value,dayValue.code300PerValue * 100];
        _balanceLabel.text = [NSString stringWithFormat:@"组合净值:%.2f (%.2f%%)",dayValue.balanceValue,dayValue.balancePerValue * 100];
        
        [UIView animateWithDuration:0.1f animations:^{
            if (!self.floatDataView.hidden) {
                CGFloat floatDataViewOriginX = 0;
                CGFloat floatDataViewOriginY = self.currentPouchPoint.y;
                if (self.currentPouchPoint.y > self.portfolioChart.frame.size.height - self.floatDataView.frame.size.height) {
                    floatDataViewOriginY = self.portfolioChart.frame.size.height - self.floatDataView.frame.size.height;
                }
                if (selectedPoint_balance.point.x > self.floatDataView.frame.size.width + 10) {
                    floatDataViewOriginX = selectedPoint_balance.point.x - 10 - self.floatDataView.frame.size.width;
                }else{
                    floatDataViewOriginX = selectedPoint_balance.point.x + 10;
                }
                CGPoint floatDataViewOrigin_portfolioChart = CGPointMake(floatDataViewOriginX, floatDataViewOriginY);
                CGPoint floatDataViewOrigin = [self.portfolioChart convertPoint:floatDataViewOrigin_portfolioChart toView:self];
                
                self.floatDataView.frame = CGRectMake(floatDataViewOrigin.x, floatDataViewOrigin.y, self.floatDataView.frame.size.width, self.floatDataView.frame.size.height);
            }
        }];
    }
}

-(void)prepareRangeDataForShow{
    if (!dayValueArray) {
        dayValueArray = [NSMutableArray array];
    }
    [dayValueArray removeAllObjects];
    CGFloat firstCode300Value = 0;
    CGFloat firstBalanceValue = 0;
    
    NSArray *selectedRangeCode300Array = [_code300Array subarrayWithRange:_selectedRange];
    
    for (NSArray *code300 in selectedRangeCode300Array) {
        if (code300.count != 2) {
            continue;
        }
        DayValueObject *dayValue = [[DayValueObject alloc] init];
        NSNumber *code300DateNaumber = code300.firstObject;
        dayValue.dateNumber = code300DateNaumber;
        NSNumber *code300Number = code300[1];
        if (code300 == selectedRangeCode300Array.firstObject) {
            dayValue.code300Value = code300Number.floatValue;
            dayValue.code300PerValue = 0;
            firstCode300Value = code300Number.floatValue;
        }else{
            dayValue.code300PerValue = (code300Number.floatValue - firstCode300Value) / firstCode300Value;
            dayValue.code300Value = code300Number.floatValue;
        }
        
        BOOL exist = NO;
        for (NSArray * balance in _balanceArray) {
            if (balance.count != 2) {
                continue;
            }
            NSNumber *balanceDateNumber = balance.firstObject;
            if (balanceDateNumber.longLongValue > code300DateNaumber.longLongValue) {
                break;
            }else if (balanceDateNumber.longLongValue < code300DateNaumber.longLongValue) {
                continue;
            }else{
                NSNumber *balanceNumber = balance[1];
                if (code300 == selectedRangeCode300Array.firstObject) {
                    dayValue.balanceValue = code300Number.floatValue;
                    dayValue.balancePerValue = 0;
                    firstBalanceValue = balanceNumber.floatValue;
                }else{
                    dayValue.balanceValue = balanceNumber.floatValue;
                    dayValue.balancePerValue = (balanceNumber.floatValue - firstBalanceValue) / firstBalanceValue;
                }
                exist = YES;
                break;
            }
        }
        if (!exist) {
            dayValue.balanceValue = NSIntegerMax;
        }
        [dayValueArray addObject:dayValue];
    }
    
    if (!balanceLineEntity) {
        balanceLineEntity = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_MA name:@"净值" lineColor:UIColorFromRGB(0x8FB5EC) thickness:2.0 totalPointCount:_selectedRange.length dataArray:nil];
    }
    if (!code300LineEntity) {
        code300LineEntity = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_MA name:@"沪深300" lineColor:UIColorFromRGB(0x8FB5EC) thickness:1.0 totalPointCount:_selectedRange.length dataArray:nil];
    }
    
    
    NSMutableArray *balanceDataArray = [NSMutableArray array];
    NSMutableArray *code300DataArray = [NSMutableArray array];
    balanceLineEntity.totalPointCount = dayValueArray.count;
    code300LineEntity.totalPointCount = dayValueArray.count;
    for (DayValueObject *dayValue in dayValueArray) {
        TSMAEntity *code300PointEntity = [[TSMAEntity alloc] init];
        code300PointEntity.value = dayValue.code300PerValue;
        [code300DataArray addObject:code300PointEntity];
        TSMAEntity *balancePointEntity = [[TSMAEntity alloc] init];
        balancePointEntity.value = dayValue.balancePerValue;
        [balanceDataArray addObject:balancePointEntity];
    }
    balanceLineEntity.dataArray = balanceDataArray;
    code300LineEntity.dataArray = code300DataArray;
}

-(void)prepareForControlBarChart{
    _controlBarChart.pointCount = _selectedRange.length;
    CGFloat max = balanceLineEntity.max;
    CGFloat min = balanceLineEntity.min;
    self.controlBarChart.maxY = max + (max - min) * 0.1;
    self.controlBarChart.minY = min - (max - min) * 0.1;
    NSArray *dataArray = balanceLineEntity.dataArray;
    NSMutableArray *drawEnitiyArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count - 1; i ++) {
        TSMAEntity *entity1 = dataArray[i];
        TSMAEntity *entity2 = dataArray[i + 1];
        CGFloat xPosition1 = self.controlBarChart.originPoint.x + self.controlBarChart.xStepLen * i;
        CGFloat xPosition2 = self.controlBarChart.originPoint.x + self.controlBarChart.xStepLen * (i + 1);
        CGFloat yPosition1 = [self.controlBarChart getYpositionWithValue:entity1.value];
        CGFloat yPosition2 = [self.controlBarChart getYpositionWithValue:entity2.value];
        CGPoint startPoint = CGPointMake(xPosition1, yPosition1);
        CGPoint endPoint = CGPointMake(xPosition2, yPosition2);
        LineForDrawEntity *entity = [[LineForDrawEntity alloc] init];
        entity.startPoint = startPoint;
        entity.endPoint = endPoint;
        entity.lineColor = UIColorFromRGB(0x8FB5EC);
        entity.thickness = 0.5f;
        entity.lineType = KYBChartLineType_TS;
        entity.fillColor = UIColorFromRGBAndAlpha(0xF5F7FA,0.8f);
        [drawEnitiyArray addObject:entity];
    }
    self.controlBarChart.lineArrayForDraw = [NSMutableArray arrayWithObject:drawEnitiyArray];
    [self.controlBarChart setNeedsDisplay];
}


-(void)prepareForPortfolioChart{
    _portfolioChart.pointCount = _selectedRange.length;
    
    NSArray *leftArray;
    CGFloat max = fmax(balanceLineEntity.max, code300LineEntity.max);
    CGFloat min = fmin(balanceLineEntity.min, code300LineEntity.min);
    NSLog(@"max:%f min:%f",max,min);
    CGFloat Ymax,Ymin;
    if (max < 0) {//第一线为0轴
        Ymax = 0;
        Ymin = - [self getFitYValue:fabs(min * 100)];
        leftArray = @[[NSString stringWithFormat:@"%.f%%",Ymin],
                      [NSString stringWithFormat:@"%.f%%",Ymin * 3 /4],
                      [NSString stringWithFormat:@"%.f%%",Ymin/2],
                      [NSString stringWithFormat:@"%.f%%",Ymin/4],
                      [NSString stringWithFormat:@"%.f%%",0.0]];
        _portfolioChart.leftGraduationArray = leftArray;
    }else if(min > 0){//第五线为0轴
        Ymin = 0;
        Ymax = [self getFitYValue:fabs(max * 100)];
        leftArray = @[[NSString stringWithFormat:@"%.f%%",0.0],
                      [NSString stringWithFormat:@"%.f%%",Ymax/4],
                      [NSString stringWithFormat:@"%.f%%",Ymax/2],
                      [NSString stringWithFormat:@"%.f%%",Ymax * 3 /4],
                      [NSString stringWithFormat:@"%.f%%",Ymax]];
    }else if(fabs(min) / fabs(max) >= 3){ //第二线为0轴
        
        Ymin = - [self getFitYValue:fabs(min * 100)/3] * 3;
        Ymax = - Ymin / 3;

        leftArray = @[[NSString stringWithFormat:@"%.f%%",- Ymax * 3],
                      [NSString stringWithFormat:@"%.f%%",- Ymax * 2],
                      [NSString stringWithFormat:@"%.f%%",- Ymax * 1],
                      [NSString stringWithFormat:@"%.f%%",0.0],
                      [NSString stringWithFormat:@"%.f%%",Ymax]];
    }else if(fabs(max) / fabs(min) >= 3){ //第四线为0轴
        Ymax = [self getFitYValue:fabs(max * 100)/3] * 3;
        Ymin = -Ymax / 3;
        
        leftArray = @[[NSString stringWithFormat:@"%.f%%",Ymin],
                      [NSString stringWithFormat:@"%.f%%",0.0],
                      [NSString stringWithFormat:@"%.f%%",- Ymin * 1],
                      [NSString stringWithFormat:@"%.f%%",- Ymin * 2],
                      [NSString stringWithFormat:@"%.f%%",- Ymin * 3]];
        
        
    }else{ //第三线为0轴
        CGFloat maxCeilAbs= [self getFitYValue:fabs(max * 100)];
        CGFloat minCeilAbs = [self getFitYValue:fabs(min * 100)];
        CGFloat n;
        if (fmax(maxCeilAbs, minCeilAbs) == maxCeilAbs){
            Ymax = maxCeilAbs;
            Ymin = -maxCeilAbs;
            n = maxCeilAbs;
            
        }else{
            Ymax = minCeilAbs;
            Ymin = -minCeilAbs;
            n = minCeilAbs;
        }
        leftArray = @[[NSString stringWithFormat:@"%.f%%",-n],
                      [NSString stringWithFormat:@"%.f%%",-n * 0.5],
                      [NSString stringWithFormat:@"%.f%%",0.0],
                      [NSString stringWithFormat:@"%.f%%",n * 0.5],
                      [NSString stringWithFormat:@"%.f%%",n]];
    }
    
    _portfolioChart.leftGraduationArray = leftArray;
    _portfolioChart.maxY = Ymax/100;
    _portfolioChart.minY = Ymin/100;
    
}

-(CGFloat)getFitYValue:(CGFloat)y{
    if (y < 2.5) {
        return  2.5;
    }else{
        int ceilY = ceil(y);
        int n = ceilY / 5;
        return 5 * (n + 1);
    }
}

-(void)createLineForDraw{
    NSMutableArray *lineArrayForDraw = [NSMutableArray array];
    for (int j = 0; j < 2; j++) {
        KYBChartLineEntity *line;
        if (j == 0) {
            line = balanceLineEntity;
        }else{
            line = code300LineEntity;
        }
        NSArray *dataArray = line.dataArray;
        NSMutableArray *drawEnitiyArray = [NSMutableArray array];
        NSMutableArray *selectedPointArray = [NSMutableArray array];
        for (int i = 0; i < dataArray.count - 1; i ++) {
            TSMAEntity *entity1 = dataArray[i];
            TSMAEntity *entity2 = dataArray[i + 1];
            CGFloat xPosition1 = self.portfolioChart.originPoint.x + self.portfolioChart.xStepLen * i;
            CGFloat xPosition2 = self.portfolioChart.originPoint.x + self.portfolioChart.xStepLen * (i + 1);
            CGFloat yPosition1 = [self.portfolioChart getYpositionWithValue:entity1.value];
            CGFloat yPosition2 = [self.portfolioChart getYpositionWithValue:entity2.value];
            CGPoint startPoint = CGPointMake(xPosition1, yPosition1);
            CGPoint endPoint = CGPointMake(xPosition2, yPosition2);
            //                    CGPoint _startPoint = [self convertPoint:startPoint fromView:self.contentChart];
            //                    CGPoint _endPoint = [self convertPoint:endPoint fromView:self.contentChart];
            LineForDrawEntity *entity = [[LineForDrawEntity alloc] init];
            entity.startPoint = startPoint;
            entity.endPoint = endPoint;
            entity.lineColor = line.lineColor;
            entity.thickness = line.thickness;
            entity.lineType = line.type;
            [drawEnitiyArray addObject:entity];
            
            PointForSelectEntity *pointForSelect = [[PointForSelectEntity alloc] init];
            pointForSelect.point = startPoint;
            pointForSelect.available = YES;
            pointForSelect.line = line;
            [selectedPointArray addObject:pointForSelect];
            if (i == dataArray.count - 2) {
                PointForSelectEntity *pointForSelect1 = [[PointForSelectEntity alloc] init];
                pointForSelect1.point = endPoint;
                pointForSelect1.available = YES;
                pointForSelect1.line = line;
                [selectedPointArray addObject:pointForSelect1];
            }

        }
        [lineArrayForDraw addObject:drawEnitiyArray];
        line.selectedPointArray = selectedPointArray;
    }
    self.portfolioChart.lineArrayForDraw = lineArrayForDraw;
    [self.portfolioChart setNeedsDisplay];
}

-(void)refresh{
//    [_portfolioChart setNeedsDisplay];
}

#pragma mark kybstorkchart delegate
-(NSString *)KYBStockChart:(KYBBaseChart *)chart bottomGraduationAtIndex:(NSInteger)Index{
    DayValueObject *dayValue = dayValueArray[Index];
    return [DataCommon dateStringByTimeStamp:dayValue.dateNumber.longValue];
}

#pragma mark KYBChartControlBarDelegate
-(void)KYBChartControlBarOnChangeWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    NSLog(@"%d %d",startIndex,endIndex);
    _selectedRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
    [self prepareRangeDataForShow];
    [self prepareForPortfolioChart];
    [self createLineForDraw];
}

#pragma mark getter and setter
-(UIView *)floatDataView{
    if (!_floatDataView) {
        _floatDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
        _floatDataView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
        _floatDataView.layer.borderWidth = 0.5f;
        _floatDataView.layer.borderColor = UIColorFromRGB(0x8FB5EC).CGColor;
        _floatDataView.layer.cornerRadius = 2.0f;
        _floatDataView.hidden = YES;
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _floatDataView.frame.size.width - 10, _floatDataView.frame.size.height/3)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont systemFontOfSize:8];
        [_floatDataView addSubview:_dateLabel];
        
        _code300Label = [[UILabel alloc] initWithFrame:CGRectMake(5, _floatDataView.frame.size.height/3, _floatDataView.frame.size.width - 10, _floatDataView.frame.size.height/3)];
        _code300Label.backgroundColor = [UIColor clearColor];
        _code300Label.font = [UIFont systemFontOfSize:8];
        [_floatDataView addSubview:_code300Label];
        
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _floatDataView.frame.size.height * 2 / 3, _floatDataView.frame.size.width - 10, _floatDataView.frame.size.height/3)];
        _balanceLabel.backgroundColor = [UIColor clearColor];
        _balanceLabel.font = [UIFont systemFontOfSize:8];
        [_floatDataView addSubview:_balanceLabel];
    }
    return _floatDataView;
}

@end



@implementation DayValueObject


@end

