
//
//  OptMyCard_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/27.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "OptMyCard_iPhone.h"
#import "ZBarSDK/ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface OptMyCard_iPhone ()
{
    __weak IBOutlet UILabel *lbMsgTip;
    __weak IBOutlet UIImageView *imgQRShow;
    __weak IBOutlet UIBarButtonItem *itmRight;
    __weak IBOutlet UIButton *btnCreateCard;
}

- (NSString*) documentPath:(NSString*)str;
- (void) createMyQRMsgN:(NSString*)n
                       TITLE:(NSString*)tit
                           M:(NSString*)m
                       EMAIL:(NSString*)em
                         ORG:(NSString*)org
                         ADR:(NSString*)adr
                         URL:(NSString*)url;
- (IBAction)btnCreateCard_click:(id)sender;

@end

@implementation OptMyCard_iPhone


////////////////////////////////////////////////////////
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

- (void) createMyQRMsgN:(NSString*)n
                       TITLE:(NSString*)tit
                           M:(NSString*)m
                       EMAIL:(NSString*)em
                         ORG:(NSString*)org
                         ADR:(NSString*)adr
                         URL:(NSString*)url
{
    NSString*msg=[NSString stringWithFormat:@"MECARD:N:%@;TITLE:%@;M:%@;EMAIL:%@;ORG:%@;ADR:%@;URL:%@",
                  n,tit,m,em,org,adr,url];
    
    lbMsgTip.text=msg;
    imgQRShow.image=[QRCodeGenerator qrImageForString:msg imageSize:imgQRShow.bounds.size.width];
}

- (IBAction)btnCreateCard_click:(id)sender
{
    [self performSegueWithIdentifier:@"segEdit" sender:nil];
}

////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=NSLocalizedString(@"mycard_title", nil);
    btnCreateCard.hidden=YES;
    lbMsgTip.text=NSLocalizedString(@"mycard_nocard", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //判断我的名片配置文件是否存在
    /////////////////////////////////////////////////////////////////////////
    //第一:读取documents路径的方法：
    //得到documents目录下test.plist配置文件的路径
    NSString *configFile = [self documentPath:@"mycard.plist"];
    NSMutableDictionary *configList =[[NSMutableDictionary alloc] initWithContentsOfFile:configFile];  //初始化字典，读取配置文件的信息
    
    //存在配置文件
    if (configList) {
        //读取键值
        NSString *myname  = [configList objectForKey:@"N"];
        NSString *title = [configList objectForKey:@"TITLE"];
        NSString *mobile = [configList objectForKey:@"M"];
        NSString *email = [configList objectForKey:@"EMAIL"];
        NSString *org = [configList objectForKey:@"ORG"];
        NSString *address = [configList objectForKey:@"ADR"];
        NSString *url = [configList objectForKey:@"URL"];
        [self createMyQRMsgN:myname TITLE:title M:mobile EMAIL:email ORG:org ADR:address URL:url];
        self.navigationItem.rightBarButtonItem=itmRight;
        btnCreateCard.hidden=YES;
    }else{
        self.navigationItem.rightBarButtonItem=nil;
        btnCreateCard.hidden=NO;
        [btnCreateCard setTitle:NSLocalizedString(@"mycard_createbtn", nil)
                       forState:UIControlStateNormal];
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
