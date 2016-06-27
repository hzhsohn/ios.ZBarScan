//
//  OptMyCardEdit_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/27.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "OptMyCardEdit_iPhone.h"

@interface OptMyCardEdit_iPhone ()
{
    __weak IBOutlet UIButton *btnSave;
    
    __weak IBOutlet UITextField *txtN;
    __weak IBOutlet UITextField *txtTITLE;
    __weak IBOutlet UITextField *txtM;
    __weak IBOutlet UITextField *txtEMAIL;
    __weak IBOutlet UITextField *txtORG;
    __weak IBOutlet UITextField *txtADR;
    __weak IBOutlet UITextField *txtURL;
}
- (IBAction)editEnd:(id)sender;

- (IBAction)btnSave_click:(id)sender;

@end

@implementation OptMyCardEdit_iPhone

//文档位置
- (NSString*) documentPath:(NSString*)str
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if (nil!=str) {
        return [NSString stringWithFormat:@"%@/%@",documentsDirectory,str];
    }
    return [NSString stringWithFormat:@"%@",documentsDirectory];
}

-(void)leftText:(UITextField*)target :(NSString*)title
{
    //左边插入LABEL文字
    UILabel *lb1;
    lb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 24)];
    [lb1 setText:title];
    [lb1 setTextAlignment:NSTextAlignmentRight];
    target.leftView = lb1;
    target.leftViewMode = UITextFieldViewModeAlways;
    lb1=nil;
}

- (IBAction)onEndEdit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)editEnd:(id)sender
{
    UITextField*txt=(UITextField*)sender;
    txt.text=[txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=NSLocalizedString(@"mycardedit_nvtitle", nil);
    [btnSave setTitle:NSLocalizedString(@"mycardedit_ok", nil) forState:0];
    
    //
    [self leftText:txtN :NSLocalizedString(@"mycardedit_n", nil)];
    [self leftText:txtTITLE :NSLocalizedString(@"mycardedit_title", nil)];
    [self leftText:txtM :NSLocalizedString(@"mycardedit_m", nil)];
    [self leftText:txtEMAIL :NSLocalizedString(@"mycardedit_email", nil)];
    [self leftText:txtORG :NSLocalizedString(@"mycardedit_org", nil)];
    [self leftText:txtADR :NSLocalizedString(@"mycardedit_adr", nil)];
    [self leftText:txtURL :NSLocalizedString(@"mycardedit_url", nil)];
    
    //
    NSString *configFile = [self documentPath:@"mycard.plist"];
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] initWithContentsOfFile:configFile];
    //
    if (configList) {
        txtN.text=[configList objectForKey:@"N"];
        txtTITLE.text=[configList objectForKey:@"TITLE"];
        txtM.text=[configList objectForKey:@"TEL"];
        txtEMAIL.text=[configList objectForKey:@"EMAIL"];
        txtORG.text=[configList objectForKey:@"ORG"];
        txtADR.text=[configList objectForKey:@"ADR"];
        txtURL.text=[configList objectForKey:@"URL"];
    }
    configFile=nil;
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



- (IBAction)btnSave_click:(id)sender
{
    
    if ([txtN.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"mycardedit_noname", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
        return;
    }
    if ([txtM.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"mycardedit_notel", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
        return;
    }
    
    //判断我的名片配置文件是否存在
    /////////////////////////////////////////////////////////////////////////
    //第一:读取documents路径的方法：
    //得到documents目录下test.plist配置文件的路径
    NSString *configFile = [self documentPath:@"mycard.plist"];
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] initWithContentsOfFile:configFile];
    //
    if (!configList) {
        //第一次，文件没有创建，因此要创建文件，并写入相应的初始值。
        configList = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                      nil];
        [configList writeToFile:configFile atomically:YES];
    }
    
    [configList setValue:txtN.text forKey:@"N"];
    [configList setValue:txtTITLE.text forKey:@"TITLE"];
    [configList setValue:txtM.text forKey:@"TEL"];
    [configList setValue:txtEMAIL.text forKey:@"EMAIL"];
    [configList setValue:txtORG.text forKey:@"ORG"];
    [configList setValue:txtADR.text forKey:@"ADR"];
    [configList setValue:txtURL.text forKey:@"URL"];
    [configList writeToFile:configFile atomically:YES];
    configFile=nil;
    [self.navigationController popViewControllerAnimated:YES];
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
