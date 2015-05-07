//
//  KYBChartReferenceView.m
//  KYBStockChart
//
//  Created by icode on 15/5/7.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "KYBChartReferenceView.h"

@interface KYBChartReferenceView()



@end

@implementation KYBChartReferenceView




- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (ChartReferencePoint *point in _) {
        <#statements#>
    }
}

@end


@implementation ChartReferencePoint

-(instancetype)init{
    self = [super init];
    if (self) {
        self.pointColor = [UIColor blackColor];
        self.position = CGPointZero;
    }
    return self;
}

@end