//
//  ViewController.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/24.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //iphone
        UIStoryboard *frm = [UIStoryboard storyboardWithName:@"iphone" bundle:nil];
        [self presentViewController:[frm instantiateInitialViewController] animated:NO completion:nil];
    } else {
        //ipad
        UIStoryboard *frm = [UIStoryboard storyboardWithName:@"iphone" bundle:nil];
        [self presentViewController:[frm instantiateInitialViewController] animated:NO completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
