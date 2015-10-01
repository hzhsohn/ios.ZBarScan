//
//  OptCreateQR_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/27.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "OptCreateQR_iPhone.h"

@interface OptCreateQR_iPhone ()
{
    __weak IBOutlet UIBarButtonItem *btnGenQR;
    __weak IBOutlet UITextView *txtContent;
    
    NSString* _defTxt;
}

@end

@implementation OptCreateQR_iPhone

-(void)dealloc
{
    _defTxt=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=NSLocalizedString(@"createqr_title", nil);
    btnGenQR.title=NSLocalizedString(@"createqr_gen", nil);
    txtContent.text=_defTxt;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [txtContent becomeFirstResponder];
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
         if ([segue.identifier isEqualToString:@"seggen"]) {
             OptCreateQR_iPhone* frm=(OptCreateQR_iPhone*)segue.destinationViewController;
             [frm setTxt:txtContent.text];
         }
 }

- (IBAction)onEndEdit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)btnGen_click:(id)sender {
    if ([txtContent.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"createqr_notnull", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
        return;
    }

    [self performSegueWithIdentifier:@"seggen" sender:nil];
}

-(void) setTxt:(NSString*)str
{
    _defTxt=str;
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
