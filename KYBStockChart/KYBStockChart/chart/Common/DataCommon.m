//
//  DataCommon.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "DataCommon.h"

@implementation DataCommon

+(CGFloat)nonce{//获得一个8位的随机数
    NSInteger nonce = arc4random()%2000+9000;
    CGFloat random = nonce / 100.00;
    return random;
}

+(void)randomTSMAEntity:(NSInteger)count array:(NSMutableArray **)array avArray:(NSMutableArray **)avArray{
    CGFloat total = 0;
    for (int i = 0; i<count ; i++) {
        TSMAEntity *entity = [[TSMAEntity alloc] init];
        entity.value = [[self class] nonce];
        NSLog(@"%f",entity.value);
        [*array addObject:entity];
        total += entity.value;
        TSMAEntity *entity1 = [[TSMAEntity alloc] init];
        entity1.value = total/(i + 1);
        NSLog(@"av:%f",entity1.value);
        [*avArray addObject:entity1];
    }
}

+(NSString *)dateStringByTimeStamp:(long)longValue{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(longValue / 1000)];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:date];
    long day=[comps day];//获取日期对应的长整形字符串
    long month=[comps month];//获取月对应的长整形字符串
    NSString *monthString;
    switch (month) {
        case 1:
            monthString = @"一月";
            break;
        case 2:
            monthString = @"二月";
            break;
        case 3:
            monthString = @"三月";
            break;
        case 4:
            monthString = @"四月";
            break;
        case 5:
            monthString = @"五月";
            break;
        case 6:
            monthString = @"六月";
            break;
        case 7:
            monthString = @"七月";
            break;
        case 8:
            monthString = @"八月";
            break;
        case 9:
            monthString = @"九月";
            break;
        case 10:
            monthString = @"十月";
            break;
        case 11:
            monthString = @"十一月";
            break;
        case 12:
            monthString = @"十二月";
            break;
            
        default:
            break;
    }
    return [NSString stringWithFormat:@"%ld.%@",day,monthString];
}

@end
