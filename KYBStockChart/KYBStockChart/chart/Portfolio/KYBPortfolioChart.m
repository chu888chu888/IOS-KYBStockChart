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

@interface KYBPortfolioChart()<KYBStockChartDelegate,KYBChartControlBarDelegate>

@property (nonatomic,weak) KYBStockChart *portfolioChart;

@property (nonatomic,weak) KYBStockChart *controlBarChart;

@property (nonatomic,weak) KYBChartControlBar *controlBar;

@property (nonatomic,strong) KYBChartLineEntity *balanceLineEntity;

@property (nonatomic,strong) KYBChartLineEntity *code300LineEntity;

@property (nonatomic,strong) KYBChartLineEntity *detailCountLineEntity;

@property (nonatomic,strong) NSMutableArray *dayValueArray;

@property (nonatomic,assign) NSRange selectedRange;

//@property (nonatomic,strong) NSArray *selectedArray;

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
        entity.fillColor = UIColorFromRGB(0xF5F7FA);
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
//            if (line == _chartLineArray.firstObject) {//基准线
//                [pointArrayForSelect addObject:[[NSValue alloc] initWithBytes:&startPoint objCType:@encode(CGPoint)]];
//                if (i == line.dataArray.count - 2) {
//                    [pointArrayForSelect addObject:[[NSValue alloc] initWithBytes:&endPoint objCType:@encode(CGPoint)]];
//                }
//            }
        }
        [lineArrayForDraw addObject:drawEnitiyArray];
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

@end

@implementation DayValueObject


@end

