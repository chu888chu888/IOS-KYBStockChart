//
//  KYBStockChartCommon.m
//  KYBStockChart
//
//  Created by icode on 15/4/16.
//  Copyright (c) 2015年 sinitek. All rights reserved.
//

#import "KYBStockChartCommon.h"
#import "NSString+UILabel.h"

@implementation KYBStockChartCommon

+ (void)drawRect:(CGContextRef)context rect:(CGRect)rectangle{
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rectangle);
}

+ (void)drawRect:(CGContextRef)context rect:(CGRect)rectangle fillColor:(UIColor *)fillColor{
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, rectangle);
}

+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Pointcolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Pointcolorspace1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, point.x,point.y);
    CGContextAddArc(context, point.x, point.y, 2, 0, 360, 0);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    CGColorSpaceRelease(Pointcolorspace1);
}
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor width:(CGFloat)lineWith{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, lineWith);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}

+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment
{
    //    UIFont *font = [UIFont systemFontOfSize: fontSize];
    [color set];
    CGSize title1Size = [text fixSizeWithFont:font];
    CGRect titleRect1 = CGRectMake(point.x,
                                   point.y,
                                   title1Size.width,
                                   title1Size.height);
    [text drawInRect:titleRect1 withFont:font lineBreakMode:NSLineBreakByClipping alignment:textAlignment];
    
}

+ (void)drawText2:(CGContextRef)context text:(NSString*)text color:(UIColor *)color fontSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont systemFontOfSize: fontSize];
    //    CGContextSelectFont(context, "Helvetica", 24.0, kCGEncodingMacRoman);
    CGContextSelectFont(context, font.fontName.UTF8String, fontSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    //    CGContextSetRGBFillColor(context, 0, 255, 255, 1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGAffineTransform xform = CGAffineTransformMake(
                                                    1.0,  0.0,
                                                    0.0, -1.0,
                                                    0.0,  0.0);
    CGContextSetTextMatrix(context, xform);
    const char* ctext = text.UTF8String;
    CGContextShowTextAtPoint(context, 10, 100, ctext, strlen(ctext));
}

+(void)drawCandle:(CGContextRef)context rect:(CGRect)rect top:(CGFloat)top bottom:(CGFloat)bottom color:(UIColor *)color{
    [[self class] drawRect:context rect:CGRectMake(rect.origin.x, rect.origin.y + top, rect.size.width, rect.size.height - top - bottom) fillColor:color];
    [[self class] drawLine:context startPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)) endPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)) lineColor:color width:1];
}

+ (void)drawDiamond:(CGContextRef)context atCenterPoint:(CGPoint)center r:(CGFloat)r fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor{//画正菱形
    CGContextMoveToPoint(context, center.x - r, center.y);
    CGContextAddLineToPoint(context, center.x, center.y - r);
    CGContextAddLineToPoint(context, center.x + r, center.y);
    CGContextAddLineToPoint(context, center.x, center.y + r);
    CGContextAddLineToPoint(context, center.x - r, center.y);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillPath(context);
    CGContextMoveToPoint(context, center.x - r, center.y);
    CGContextAddLineToPoint(context, center.x, center.y - r);
    CGContextAddLineToPoint(context, center.x + r, center.y);
    CGContextAddLineToPoint(context, center.x, center.y + r);
    CGContextAddLineToPoint(context, center.x - r, center.y);
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextStrokePath(context);
}

//画正圆
+ (void)drawCircle:(CGContextRef)context atCenterPoint:(CGPoint)point r:(CGFloat)r fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor{
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    CGRect rectangle = CGRectMake(point.x - r, point.y - r,2 * r,2 * r);
    
    CGContextAddEllipseInRect(context, rectangle);
    
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    CGContextFillEllipseInRect(context, rectangle);
}

//画正方
+ (void)drawSquare:(CGContextRef)context atCenterPoint:(CGPoint)point r:(CGFloat)r fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor{
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGRect rectangle = CGRectMake(point.x - r,point.y - r,r * 2,r * 2);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, rectangle);
}

@end
