//
//  ZBarScan.m
//  home
//
//  Created by Han.zh on 15/9/23.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "Main_iPhone.h"
#import "ZBarSDK/ZBarSDK.h"
#import "ResolvJumpToForm.h"
#import "TipBaseController.h"
#import "Objc_AudioPlay.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

#define SCANVIEW_EdgeTop 100.0
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.5 //浅色透明度
#define MOVE_TIME       2//秒
#define VIEW_WIDTH      self.view.frame.size.width
#define VIEW_HEIGHT     self.view.frame.size.height

//admob广告
GADBannerView *g_bannerView;

@interface Main_iPhone ()<ZBarReaderViewDelegate,ZBarReaderDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,GADBannerViewDelegate>
{
    ZBarReaderView *readerView;
    ZBarCameraSimulator *cameraSim;
    __weak IBOutlet UIButton *btnFlashLight;
    __weak IBOutlet UILabel *resultText;
    
    __weak IBOutlet UIButton *btnLabelHideButton;
    
    NSTimer *_timer;
    UIView *_scanView,*_QrCodeline;
    NSMutableString *_sanValue;
    
    //声音
    SystemSoundID scanokID;
    
}
- (IBAction)btnLabelHideButton_click:(id)sender;

- (IBAction)btnFlashLight_click:(id)sender;
- (IBAction)btnCamera_click:(id)sender;
-( void )createTimer;
-( void )stopTimer;
- (void) cleanup;

@end

@implementation Main_iPhone


//广告回调
- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    NSLog(@"成功加载广告啦..");
}

-(void)awakeFromNib
{
    _sanValue=[[NSMutableString alloc] init];
    
    /////////// 加入广告  //////////////////////
    
    g_bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    g_bannerView.adUnitID = @"ca-app-pub-8018207524434638/1133598102";
    g_bannerView.rootViewController = self;
    g_bannerView.delegate=self;
    [g_bannerView loadRequest:[GADRequest request]];
    
    /////// 加入广告 END ////////////////////////
}

- (void) dealloc
{
    g_bannerView=nil;
    
    _sanValue=nil;
    [self cleanup];
    //[super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createTimer];
    [readerView start];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
    [readerView stop];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Objc_AudioPlay loadFile:@"scanok.wav" :&scanokID];
    
    self.title=NSLocalizedString(@"zbar_title", nil);
    
    //初始化扫描界面
    readerView=[[ZBarReaderView alloc] init];
    readerView.frame=CGRectMake(-2, 0, VIEW_WIDTH+4, VIEW_HEIGHT);
    readerView.readerDelegate = self;
    readerView.torchMode=0;//闪光灯
    [readerView.scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    [self.view addSubview:readerView];
    
    //初始化按钮
    [btnLabelHideButton setTitle:@"" forState:UIControlStateNormal];
    resultText.text=NSLocalizedString(@"zbar_tip", nil);
    
    //将控件放到最前面
    [self setScanView];
    [self.view addSubview:_scanView];
    [self.view addSubview:_QrCodeline];
    [self.view bringSubviewToFront:btnFlashLight];
    [self.view bringSubviewToFront:resultText];
    [self.view bringSubviewToFront:btnLabelHideButton];
    
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }
}

- (void) viewDidUnload
{
    [self cleanup];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cleanup
{
    //[cameraSim release];
    cameraSim = nil;
    readerView.readerDelegate = nil;
    //[readerView release];
    readerView = nil;
    //[resultText release];
    resultText = nil;
}




#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     NSLog(@"segue.identifier=%@",segue.identifier);
     if ([segue.identifier isEqualToString:@"segdef"] ||
         [segue.identifier isEqualToString:@"segweb"] ||
         [segue.identifier isEqualToString:@"segtel"] ||
         [segue.identifier isEqualToString:@"segbcard"]
         )
     {
         
         TipBaseController* frm=(TipBaseController*)segue.destinationViewController;
         [frm setContent:[NSString stringWithString:_sanValue]];
         
         //清空内容
         [_sanValue setString:@""];
         resultText.text = _sanValue;
     }
}

- (IBAction)btnLabelHideButton_click:(id)sender
{
    NSString* frm_name=[ResolvJumpToForm resolvJumpSeg:_sanValue def:@"segdef" Web:@"segweb" Tel:@"segtel" BusinessCard:@"segbcard"];
    
    if (frm_name) {
        
        [self performSegueWithIdentifier:frm_name sender:nil];
    }
    
}

- (IBAction)btnFlashLight_click:(id)sender {
    readerView.torchMode = !readerView . torchMode ;
    btnFlashLight.selected=readerView.torchMode;
}

- (IBAction)btnCamera_click:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        //数据源可以是相册又可以摄像头
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        picker=nil;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"main_pic_err", nil)
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
        alert=nil;
    }
}

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    //扫描到二维码了
    for(ZBarSymbol *sym in syms) {
        NSLog(@"sym.data=%@",sym.data);
        [_sanValue setString:sym.data];
        resultText.text = _sanValue;
        [Objc_AudioPlay play:scanokID];
        break;
    }
}

//从相册获取图片/////////////
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pkimg;
    pkimg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //resultImage.image = pkimg;
    
    if(pkimg)
    {
        BOOL ishasqr=FALSE;//是否扫描成功
        ZBarSymbolSet *syms = nil;
        ZBarImageScanner*imgscanner=[[ZBarImageScanner alloc] init];
        ZBarImage *zimg=[[ZBarImage alloc] initWithCGImage:pkimg.CGImage];
        [imgscanner scanImage:zimg];
        syms = imgscanner.results;
        for(ZBarSymbol *sym in syms) {
            ishasqr=TRUE;
            [_sanValue setString:sym.data];
            resultText.text = _sanValue;
            [Objc_AudioPlay play:scanokID];
            break;
        }
        if (FALSE==ishasqr) {
            resultText.text = NSLocalizedString(@"main_norq", nil);
        }
        zimg=nil;
        imgscanner=nil;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//////////////////////
//二维码的扫描区域
- (void) setScanView
{
    _scanView =[[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , VIEW_HEIGHT - 64 )];
    _scanView.backgroundColor =[ UIColor clearColor ];
    //最上部view
    UIView * upView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :upView];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA ;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView. layer . borderColor =[UIColor greenColor].CGColor;
    scanCropView. layer . borderWidth = 2.0 ;
    scanCropView. backgroundColor =[ UIColor clearColor ];
    [ _scanView addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[ UIView alloc ] initWithFrame : CGRectMake ( VIEW_WIDTH - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA ;
    rightView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :rightView];
    
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , VIEW_WIDTH , VIEW_HEIGHT -( VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop ) )];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[ UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA ];
    [ _scanView addSubview :downView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , VIEW_WIDTH , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text =NSLocalizedString(@"zbar_scan_tip", nil)  ;
    [downView addSubview :labIntroudction];
    
    //画中间的基准线
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , 2 )];
    _QrCodeline.backgroundColor = [UIColor greenColor];
    [ _scanView addSubview : _QrCodeline ];
}

//二维码的横线移动
-(void) moveUpAndDownLine
{
    CGFloat Y= _QrCodeline . frame . origin . y ;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: MOVE_TIME ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: MOVE_TIME ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    }
}

-( void )createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:MOVE_TIME target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
    [self moveUpAndDownLine];//立即执行一次
}

-( void )stopTimer
{
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil ;
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
