//
//  ViewController.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "ViewController.h"
#import "KYBStockTrendChart.h"
#import "KYBStockKCandleChat.h"
#import "DataCommon.h"

#define  dataCount 100

@interface ViewController (){
    KYBStockTrendChart *trendChart;
    KYBStockKCandleChat *candleChart;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *leftArray = @[@"13.86",@"14.63",@"15.40",@"16.17",@"16.94"];
    NSArray *rightArray = @[@"-10.00%",@"-5.00%",@"0%",@"5.00%",@"10.00%"];
    NSArray *bottomArray = @[@"09:30",@"10:30",@"11:30/13:00",@"14:00",@"15:00"];
    
    NSMutableArray *tsArray = [NSMutableArray array];
    NSMutableArray *avArray = [NSMutableArray array];
    [DataCommon randomTSMAEntity:dataCount array:&tsArray avArray:&avArray];
    
    CGFloat max = 0;
    CGFloat min = 0;
    for (TSMAEntity *tsma in tsArray) {
        if (tsma == tsArray.firstObject) {
            max = tsma.value;
            min = tsma.value;
        }else{
            if (tsma.value > max) {
                max = tsma.value;
            }else if (tsma.value < min){
                min = tsma.value;
            }
        }
    }
    
    CGFloat startValue = [DataCommon nonce];
    CGFloat maxabs = fabs(max - startValue);
    CGFloat minabs = fabs(min - startValue);
    CGFloat bigabs = fmaxf(maxabs, minabs);
    CGFloat maxPercet = bigabs / startValue * 100;
    leftArray = @[[NSString stringWithFormat:@"%.2f",startValue - bigabs],
                  [NSString stringWithFormat:@"%.2f",startValue - bigabs / 2],
                  [NSString stringWithFormat:@"%.2f",startValue],
                  [NSString stringWithFormat:@"%.2f",startValue + bigabs /2],
                  [NSString stringWithFormat:@"%.2f",startValue + bigabs]];
    rightArray = @[[NSString stringWithFormat:@"%.2f%%",-maxPercet],
                   [NSString stringWithFormat:@"%.2f%%",-maxPercet / 2],
                   @"0%",
                   [NSString stringWithFormat:@"%.2f%%",maxPercet /2],
                   [NSString stringWithFormat:@"%.2f%%",maxPercet]];
    
    
    KYBChartLineEntity * tsLine = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_TS name:@"分时" lineColor:[UIColor blackColor] thickness:0.3f totalPointCount:dataCount dataArray:tsArray];
    KYBChartLineEntity * maLine1 = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_TS name:@"均值" lineColor:[UIColor orangeColor] thickness:0.3f totalPointCount:dataCount dataArray:avArray];
    trendChart = [[KYBStockTrendChart alloc] initWithFrame:CGRectMake(0, 64, iDeviceWidth, iDeviceWidth / 5 * 3) absRange:bigabs startYValue:startValue];
    trendChart.pointCount = dataCount;
    trendChart.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    trendChart.backgroundColor = UIColorFromRGB(0xf8f8f8);
    trendChart.leftGraduationArray = leftArray;
    trendChart.rightGraduationArray = rightArray;
    trendChart.bottomGraduationArray = bottomArray;
    trendChart.chartLineArray = [NSMutableArray arrayWithObjects:tsLine, maLine1,nil];
    [self.view addSubview:trendChart];
    
    
    
    
    //    NSArray *ma5Array = [NSArray array];
    //    NSArray *ma10Array = [NSArray array];
    //    NSArray *ma20Array = [NSArray array];
    //
    //    KYBChartLineEntity * ma5Line = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_MA name:@"MA5" lineColor:[UIColor colorWithWhite:0.6 alpha:1] thickness:0.3f totalPointCount:100 dataArray:ma5Array];
    //    KYBChartLineEntity * ma10Line = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_MA name:@"MA10" lineColor:[UIColor colorWithWhite:0.4 alpha:1] thickness:0.3f totalPointCount:100 dataArray:ma10Array];
    //    KYBChartLineEntity * ma20Line = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_MA name:@"MA20" lineColor:[UIColor colorWithWhite:0.2 alpha:1] thickness:0.3f totalPointCount:100 dataArray:ma20Array];
    //    KYBChartLineEntity * kLine = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_K name:@"日K线图" lineColor:nil thickness:0 totalPointCount:100 dataArray:maArray];
    //
    //    candleChart = [[KYBStockKCandleChat alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(trendChart.frame), iDeviceWidth, iDeviceWidth / 5 * 3)];
    //    candleChart.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //    candleChart.backgroundColor = UIColorFromRGB(0xf8f8f8);
    //    candleChart.showLineName = YES;
    //    candleChart.leftGraduationArray = leftArray;
    //    candleChart.bottomLeftGraduation = @"2015/01/15";
    //    candleChart.bottomRightGraduation = @"2015/04/16";
    //    candleChart.chartLineArray = [NSMutableArray arrayWithObjects:ma5Line, ma10Line, ma20Line, kLine, nil];
    //    [self.view addSubview:candleChart];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [trendChart setNeedsDisplay];
    [candleChart setNeedsDisplay];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
