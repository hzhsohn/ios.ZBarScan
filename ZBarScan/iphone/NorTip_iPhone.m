//
//  NorTip_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/30.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "NorTip_iPhone.h"

@interface NorTip_iPhone ()
{
    __weak IBOutlet UITextView *txtContent;

}

@end

@implementation NorTip_iPhone


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.scan_content);
    
    if ([self.scan_content isEqualToString:@""]) {
        txtContent.text=NSLocalizedString(@"nortip_notxt", nil);
    }
    else{
        txtContent.text=self.scan_content;
    }
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
