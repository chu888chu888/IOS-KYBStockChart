//
//  VolumeForDrawEntity.h
//  KYBStockChart
//
//  Created by icode on 15/4/28.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VolumeForDrawEntity : NSObject

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,assign) CGRect rect;

-(void)drawVolumnRect:(CGContextRef)context;

@end
