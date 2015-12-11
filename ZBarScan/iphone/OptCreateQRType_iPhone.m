//
//  OptCreateQRType_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/28.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "OptCreateQRType_iPhone.h"
#import "OptCreateQR_iPhone.h"

@interface OptCreateQRType_iPhone ()
{
    __weak IBOutlet UILabel *lbTxt;
    __weak IBOutlet UILabel *lbWeb;

}

@end

@implementation OptCreateQRType_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title=NSLocalizedString(@"createqrtype_title", nil);
    
    lbTxt.text=NSLocalizedString(@"createqrtype_txt", nil);
    lbWeb.text=NSLocalizedString(@"createqrtype_web", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"segue.identifier=%@",segue.identifier);
    if ([segue.identifier isEqualToString:@"segtxt"]) {
        OptCreateQR_iPhone* frm=(OptCreateQR_iPhone*)segue.destinationViewController;
        [frm setTxt:@""];
    }
    else if ([segue.identifier isEqualToString:@"segweb"]) {
        OptCreateQR_iPhone* frm=(OptCreateQR_iPhone*)segue.destinationViewController;
        [frm setTxt:@"http://"];
    }
}



/////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
#if 1
    return  (interfaceOrientation == UIInterfaceOrientationPortrait);
#else
    return  (interfaceOrientation == UIInterfaceOrientationPortrait )||
    (interfaceOrientation == UIDeviceOrientationLandscapeLeft )||
    (interfaceOrientation == UIDeviceOrientationLandscapeRight );
#endif
    
}

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSInteger)supportedInterfaceOrientations{
    NSInteger orientationMask = 0;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeLeft])
        orientationMask |= UIInterfaceOrientationMaskLandscapeLeft;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationLandscapeRight])
        orientationMask |= UIInterfaceOrientationMaskLandscapeRight;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortrait])
        orientationMask |= UIInterfaceOrientationMaskPortrait;
    if ([self shouldAutorotateToInterfaceOrientation: UIInterfaceOrientationPortraitUpsideDown])
        orientationMask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    return orientationMask;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"From Rotate=%ld",fromInterfaceOrientation);
    switch (fromInterfaceOrientation) {
        case UIInterfaceOrientationUnknown:break;
        case UIInterfaceOrientationPortrait:
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            break;
    }
}
@end
