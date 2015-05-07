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
#import "KYBPortfolioChart.h"
#import "DataCommon.h"

#define  dataCount 80

@interface ViewController (){
    KYBStockTrendChart *trendChart;
    KYBStockKCandleChat *candleChart;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSMutableArray *tsArray = [NSMutableArray array];
//    NSMutableArray *avArray = [NSMutableArray array];
//    [DataCommon randomTSMAEntity:dataCount array:&tsArray avArray:&avArray];
//    
//    CGFloat max = 0;
//    CGFloat min = 0;
//    for (TSMAEntity *tsma in tsArray) {
//        if (tsma == tsArray.firstObject) {
//            max = tsma.value;
//            min = tsma.value;
//        }else{
//            if (tsma.value > max) {
//                max = tsma.value;
//            }else if (tsma.value < min){
//                min = tsma.value;
//            }
//        }
//    }
//    
//    CGFloat startValue = [DataCommon nonce];
//    CGFloat maxabs = fabs(max - startValue);
//    CGFloat minabs = fabs(min - startValue);
//    CGFloat bigabs = fmaxf(maxabs, minabs);
//    CGFloat maxPercet = bigabs / startValue * 100;
//    NSArray *leftArray = @[[NSString stringWithFormat:@"%.2f",startValue - bigabs],
//                  [NSString stringWithFormat:@"%.2f",startValue - bigabs / 2],
//                  [NSString stringWithFormat:@"%.2f",startValue],
//                  [NSString stringWithFormat:@"%.2f",startValue + bigabs /2],
//                  [NSString stringWithFormat:@"%.2f",startValue + bigabs]];
//    NSArray *rightArray = @[[NSString stringWithFormat:@"%.2f%%",-maxPercet],
//                   [NSString stringWithFormat:@"%.2f%%",-maxPercet / 2],
//                   @"0%",
//                   [NSString stringWithFormat:@"%.2f%%",maxPercet /2],
//                   [NSString stringWithFormat:@"%.2f%%",maxPercet]];
//    
//    
//    KYBChartLineEntity * tsLine = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_TS name:@"分时" lineColor:[UIColor blackColor] thickness:0.5f totalPointCount:dataCount dataArray:tsArray];
//    KYBChartLineEntity * maLine1 = [[KYBChartLineEntity alloc] initWithType:KYBChartLineType_TS name:@"均值" lineColor:[UIColor orangeColor] thickness:0.5f totalPointCount:dataCount dataArray:avArray];
//    trendChart = [[KYBStockTrendChart alloc] initWithFrame:CGRectMake(0, 64, iDeviceWidth, iDeviceWidth / 5 * 3) absRange:bigabs startYValue:startValue];
//    trendChart.pointCount = 100;
//    trendChart.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    trendChart.backgroundColor = UIColorFromRGB(0xf8f8f8);
//    trendChart.contentChart.leftGraduationArray = leftArray;
//    trendChart.contentChart.rightGraduationArray = rightArray;
//    trendChart.chartLineArray = [NSMutableArray arrayWithObjects:tsLine, maLine1,nil];
//    trendChart.showReferenceLine = YES;
//    [self.view addSubview:trendChart];
    NSString *path1=[[NSBundle mainBundle] pathForResource:@"balance.json" ofType:nil];
    NSData *fileData1 = [NSData dataWithContentsOfFile:path1];
    NSArray *dictArray1 = [NSJSONSerialization JSONObjectWithData:fileData1 options:NSJSONReadingMutableContainers error:NULL];
    
    NSString *path2=[[NSBundle mainBundle] pathForResource:@"code300.json" ofType:nil];
    NSData *fileData2 = [NSData dataWithContentsOfFile:path2];
    NSArray *dictArray2 = [NSJSONSerialization JSONObjectWithData:fileData2 options:NSJSONReadingMutableContainers error:NULL];
    
    NSString *path3=[[NSBundle mainBundle] pathForResource:@"detail_count.json" ofType:nil];
    NSData *fileData3 = [NSData dataWithContentsOfFile:path3];
    NSArray *dictArray3 = [NSJSONSerialization JSONObjectWithData:fileData3 options:NSJSONReadingMutableContainers error:NULL];
    
    KYBPortfolioChart *portfolioChart = [[KYBPortfolioChart alloc] initWithframe:CGRectMake(0, 64, iDeviceWidth, iDeviceWidth / 5 * 3) balanceArray:dictArray1 code300Array:dictArray2 detailCountArray:dictArray3];
//    portfolioChart.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self.view addSubview:portfolioChart];
    

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
