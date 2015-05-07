//
//  KYBPortfolioChart.h
//  KYBStockChart
//
//  Created by icode on 15/5/4.
//  Copyright (c) 2015年 zhb1991nm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYBBaseChart.h"

@interface KYBPortfolioChart : UIView

@property (nonatomic,strong) NSArray *balanceArray;//组合净值

@property (nonatomic,strong) NSArray *code300Array;//沪深300

@property (nonatomic,strong) NSArray *detailCountArray;//成分股个数

-(instancetype)initWithframe:(CGRect)frame balanceArray:(NSArray *)balanceArray code300Array:(NSArray *)code300Array detailCountArray:(NSArray *)detailCountArray;

-(void)refresh;

@end

@interface DayValueObject : NSObject

@property (nonatomic,copy) NSNumber *dateNumber;

@property (nonatomic,assign) CGFloat balanceValue;

@property (nonatomic,assign) CGFloat balancePerValue;

@property (nonatomic,assign) CGFloat code300Value;

@property (nonatomic,assign) CGFloat code300PerValue;

@property (nonatomic,assign) CGFloat detailCountValue;

@end

