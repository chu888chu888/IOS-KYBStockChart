//
//  LineForDrawEntity.h
//  KYBStockChart
//
//  Created by icode on 15/4/24.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineForDrawEntity : NSObject

@property (nonatomic,assign) CGPoint startPoint;//起始位置

@property (nonatomic,assign) CGPoint endPoint;//终点位置

@property (nonatomic,strong) UIColor *lineColor;//线颜色

@property (nonatomic,assign) CGFloat thickness;//线粗细

-(void)drawLine:(CGContextRef)context;

@end
