//
//  OptCreateQRGen_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/28.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "OptCreateQRGen_iPhone.h"
#import "QRCodeGenerator.h"

@interface OptCreateQRGen_iPhone ()
{
    __weak IBOutlet UIImageView *imgGen;
    __weak IBOutlet UIButton *btnsave;
    __weak IBOutlet UILabel *lbContent;
    
    NSString* _defTxt;

}
- (IBAction)btnsave_click:(id)sender;

@end

@implementation OptCreateQRGen_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    imgGen.image=[QRCodeGenerator qrImageForString:_defTxt imageSize:512];
    [btnsave setTitle:NSLocalizedString(@"qrgen_save", nil) forState:0];
    lbContent.text=_defTxt;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setTxt:(NSString*)str
{
    _defTxt=str;
}
- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    if (error != NULL){
        //失败
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"qrgen_sfail", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"qrgen_sok", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        alert.tag = 1999;
        [alert show];
        alert=nil;
    }
    
}
- (IBAction)btnsave_click:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(imgGen.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//重载的函数
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1999:
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            break;
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
