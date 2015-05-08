//
//  PointForSelectEntity.h
//  KYBStockChart
//
//  Created by icode on 15/5/8.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KYBChartLineEntity;

@interface PointForSelectEntity : NSObject

@property (nonatomic,assign) CGPoint point;

@property (nonatomic,weak) KYBChartLineEntity *line;

@property (nonatomic,assign) BOOL available;

@end
