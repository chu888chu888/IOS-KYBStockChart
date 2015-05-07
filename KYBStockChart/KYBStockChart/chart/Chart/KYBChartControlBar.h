//
//  KYBChartControlBar.h
//  KYBStockChart
//
//  Created by icode on 15/5/7.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KYBChartControlBarDelegate <NSObject>
@optional

- (void)KYBChartControlBarOnChangeWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end

@interface KYBChartControlBar : UIView

@property (nonatomic,assign) NSInteger pointCount;//点的总数 >=2

@property (nonatomic,assign) NSInteger minDisPointCount;//最小间距下点的个数 >= 2

@property (nonatomic,assign) id <KYBChartControlBarDelegate> delegate;

@end

@interface ControlBtn : UIView

@end

@interface CoverView : UIView

@end