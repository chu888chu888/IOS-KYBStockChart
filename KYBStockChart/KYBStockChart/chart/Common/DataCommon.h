//
//  DataCommon.h
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSMAEntity.h"

@interface DataCommon : NSObject

+(CGFloat)nonce;

+(void)randomTSMAEntity:(NSInteger)count array:(NSMutableArray **)array avArray:(NSMutableArray **)avArray;

@end
