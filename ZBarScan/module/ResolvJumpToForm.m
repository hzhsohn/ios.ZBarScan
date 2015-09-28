//
//  ResolvJumpToForm.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/26.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "ResolvJumpToForm.h"

@implementation ResolvJumpToForm

+(NSString*)resolvJumpSeg:(NSString*)resolv_data
                      Web:(NSString*)segweb
                      Tel:(NSString*)segtel
             BusinessCard:(NSString*)segbcard
{
    if ([[[resolv_data substringToIndex:5] lowercaseString] isEqualToString:@"http:"]) {
        return segweb;
    }
    else if ([[[resolv_data substringToIndex:6] lowercaseString] isEqualToString:@"https:"]) {
        return segweb;
    }
    else if ([[[resolv_data substringToIndex:4] lowercaseString] isEqualToString:@"tel:"]) {
        return segtel;
    }
    else if ([[[resolv_data substringToIndex:7] lowercaseString] isEqualToString:@"mecard:"]) {
        return segbcard;
    }
    
    return nil;
}

@end
