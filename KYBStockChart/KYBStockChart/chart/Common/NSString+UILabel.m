//
//  NSString+UILabel.m
//  BrokerMarkerIOS
//
//  Created by icode on 14-6-10.
//  Copyright (c) 2014年 sinitek. All rights reserved.
//

#import "NSString+UILabel.h"

@implementation NSString (UILabel)

-(CGSize)fixSizeWithFont:(UIFont*)font{
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

@end
