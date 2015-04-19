//
//  KYBStockChartCommon.h
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import <Foundation/Foundation.h>

#define StockRed [UIColor redColor]
#define StockGreen UIColorFromRGB(0x158D09)
#define StockBlack [UIColor blackColor]//十字星用黑色

#define Axis0Color [UIColor blackColor]
#define AxisColor [UIColor blackColor]

#define XYTextColor [UIColor darkGrayColor]

@interface KYBStockChartCommon : NSObject

+ (void)drawRect:(CGContextRef)context rect:(CGRect)rectangle;

+ (void)drawRect:(CGContextRef)context rect:(CGRect)rectangle fillColor:(UIColor *)fillColor;

+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color;

+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor width:(CGFloat)lineWith;

//画蜡烛线
+(void)drawCandle:(CGContextRef)context rect:(CGRect)rect top:(CGFloat)top bottom:(CGFloat)bottom color:(UIColor *)color;

+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;

+ (void)drawText2:(CGContextRef)context text:(NSString*)text color:(UIColor *)color fontSize:(CGFloat)fontSize;

@end
