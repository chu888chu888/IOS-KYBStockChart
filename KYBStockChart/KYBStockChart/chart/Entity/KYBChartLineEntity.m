//
//  KYBChartLineEntity.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "KYBChartLineEntity.h"

@implementation KYBChartLineEntity

-(instancetype)initWithType:(KYBChartLineType)type name:(NSString *)name lineColor:(UIColor *)color thickness:(CGFloat)thickness totalPointCount:(NSInteger)totalPointCount dataArray:(NSArray *)dataArray{
    self = [super init];
    if (self) {
        self.type = type;
        self.name = name;
        self.lineColor = color;
        self.thickness = thickness;
        self.dataArray = dataArray;
        if (type == KYBChartLineType_K) {
            self.totalPointCount = dataArray.count;
        }else{
            self.totalPointCount = totalPointCount;
        }
        if (dataArray) {
            CGFloat min = 0;
            CGFloat max = 0;
            if (type == KYBChartLineType_MA || type == KYBChartLineType_TS) {
                for (TSMAEntity * entity in dataArray) {
                    if (entity == dataArray.firstObject) {
                        min = max = entity.value;
                    }else{
                        if (entity.value > max) {
                            max = entity.value;
                        }else if (entity.value < min){
                            min = entity.value;
                        }
                    }
                }
            }
            self.max = max;
            self.min = min;
        }
    }
    return self;
}

@end
