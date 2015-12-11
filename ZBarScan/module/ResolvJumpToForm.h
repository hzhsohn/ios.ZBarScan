//
//  ResolvJumpToForm.h
//  ZBarScan
//
//  Created by Han.zh on 15/9/26.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResolvJumpToForm : NSObject

+(NSString*)resolvJumpSeg:(NSString*)resolv_data
                      def:(NSString*)segdef
                      Web:(NSString*)segweb
                      Tel:(NSString*)segtel
             BusinessCard:(NSString*)segbcard;

@end
