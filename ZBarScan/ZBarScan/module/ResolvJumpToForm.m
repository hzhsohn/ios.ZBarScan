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
                      def:(NSString*)segdef
                      Web:(NSString*)segweb
                      Tel:(NSString*)segtel
             BusinessCard:(NSString*)segbcard
{
    NSLog(@"%@",resolv_data);
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    NSString *https = @"https+:[^\\s]*";
    NSPredicate *httpsPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",https];
    
    NSString *tel = @"^tel:.*?";;
    NSPredicate *telPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tel];
    
    NSString *mecard = @"^mecard:.*?";;
    NSPredicate *mecardPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mecard];
    
    if ([predicate evaluateWithObject:[resolv_data lowercaseString]]) {
        return segweb;
    }
    else if([httpsPre evaluateWithObject:[resolv_data lowercaseString]]){
        return segweb;
    }
    else if([telPre evaluateWithObject:[resolv_data lowercaseString]]){
        return segtel;
    }
    else if([mecardPre evaluateWithObject:[resolv_data lowercaseString]]){
        return segbcard;
    }

    return segdef;
}

@end
