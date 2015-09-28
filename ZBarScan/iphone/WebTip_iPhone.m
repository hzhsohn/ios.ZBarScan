//
//  WebTip_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/26.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "WebTip_iPhone.h"

@interface WebTip_iPhone ()
{
    __weak IBOutlet UITextView *txtLinkContent;

}

- (IBAction)btnOpenLink_click:(id)sender;
@end

@implementation WebTip_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)btnOpenLink_click:(id)sender {
    if (NO==[txtLinkContent.text isEqualToString:@""])
    {
        NSURL* url = [[NSURL alloc] initWithString:@"http://blog.csdn.net/iukey"];
        [[ UIApplication sharedApplication]openURL:url];
    }
}


@end
