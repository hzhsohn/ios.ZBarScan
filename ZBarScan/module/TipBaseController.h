//
//  TipBaseController.h
//  ZBarScan
//
//  Created by Han.zh on 15/9/27.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipBaseController : UITableViewController

@property (nonatomic,copy) NSString* scan_content;


-(void) setContent:(NSString*)str;

@end
