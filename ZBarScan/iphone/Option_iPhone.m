//
//  Option_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/26.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "Option_iPhone.h"

@interface Option_iPhone ()
{
    __weak IBOutlet UILabel *lbMyCard;
    __weak IBOutlet UILabel *lbCreateQR;

}

@end

@implementation Option_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lbMyCard.text=NSLocalizedString(@"optfrm_mycard",nil);
    lbCreateQR.text=NSLocalizedString(@"optfrm_createqr",nil);
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



@end
