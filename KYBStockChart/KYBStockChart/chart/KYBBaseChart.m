//
//  KYBBaseChart.m
//  KYBStockChart
//
//  Created by icode on 15/5/4.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import "KYBBaseChart.h"

@implementation KYBBaseChart

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
