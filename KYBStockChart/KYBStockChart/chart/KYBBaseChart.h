//
//  KYBBaseChart.h
//  KYBStockChart
//
//  Created by icode on 15/5/4.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYBBaseChart : UIView

@property (nonatomic,assign) NSInteger pointCount;//结点个数

@property (nonatomic,assign) UIEdgeInsets edgeInsets;//收缩

@property CGPoint originPoint;//左下点

@property CGPoint leftTopPoint;//左上点

@property CGPoint rightBottomPoint;//右下点

@property CGFloat xLen;//x轴长度

@property CGFloat yLen;//y轴长度

@property CGFloat xStepLen;//x轴单位刻度长度

@end
