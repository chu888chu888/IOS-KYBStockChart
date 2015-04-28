//
//  KYBStockBaseChart.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "KYBStockBaseChart.h"
#import "NSString+UILabel.h"
#import "LineForDrawEntity.h"

@interface KYBStockBaseChart()


@end

@implementation KYBStockBaseChart


-(void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
    _originPoint = CGPointMake(edgeInsets.left, self.frame.size.height - edgeInsets.bottom);
    _leftTopPoint = CGPointMake(edgeInsets.left, edgeInsets.top);
    _rightBottomPoint = CGPointMake(self.frame.size.width - edgeInsets.right, self.frame.size.height - edgeInsets.bottom);
    _xLen = self.frame.size.width - edgeInsets.left - edgeInsets.right;
    _yLen = self.frame.size.height - edgeInsets.top - edgeInsets.bottom;
    if (_pointCount > 0) {
        _xStepLen = _xLen /(_pointCount - 1);
    }
}

-(void)setPointCount:(NSInteger)pointCount{
    _pointCount = pointCount;
    if (pointCount > 0 ) {
        _xStepLen = self.xLen /(_pointCount - 1);
    }
}

@end
