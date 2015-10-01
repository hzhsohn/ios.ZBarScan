//
//  TipBaseController.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/27.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "TipBaseController.h"

@interface TipBaseController ()

@end

@implementation TipBaseController
@synthesize scan_content;

-(void)awakeFromNib
{

}

-(id)init
{
    if ((self=[super init])) {

    }
    return self;
}

-(void)dealloc
{
    self.scan_content=nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setContent:(NSString*)str
{
    scan_content=str;
}


@end
