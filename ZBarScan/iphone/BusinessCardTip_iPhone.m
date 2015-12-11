//
//  BusinessCardTip_iPhone.m
//  ZBarScan
//
//  Created by Han.zh on 15/9/26.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import "BusinessCardTip_iPhone.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface BusinessCardTip_iPhone ()
{
    __weak IBOutlet UILabel *lbN;
    __weak IBOutlet UILabel *lbTITLE;
    __weak IBOutlet UILabel *lbM;
    __weak IBOutlet UILabel *lbEMAIL;
    __weak IBOutlet UILabel *lbORG;
    __weak IBOutlet UILabel *lbADR;
    __weak IBOutlet UILabel *lbURL;
    __weak IBOutlet UITextView *txtValue;
    __weak IBOutlet UIButton *btnSave;
    
    NSMutableString *sN;
    NSMutableString *sTITLE;
    NSMutableString *sM;
    NSMutableString *sEMAIL;
    NSMutableString *sORG;
    NSMutableString *sADR;
    NSMutableString *sURL;
}
- (IBAction)btnSave_click:(id)sender;

@end

@implementation BusinessCardTip_iPhone

-(void)awakeFromNib
{
    sN=[[NSMutableString alloc] init];
    sTITLE=[[NSMutableString alloc] init];
    sM=[[NSMutableString alloc] init];
    sEMAIL=[[NSMutableString alloc] init];
    sORG=[[NSMutableString alloc] init];
    sADR=[[NSMutableString alloc] init];
    sURL=[[NSMutableString alloc] init];
}

-(void)dealloc
{
    sN=nil;
    sTITLE=nil;
    sM=nil;
    sEMAIL=nil;
    sORG=nil;
    sADR=nil;
    sURL=nil;
}

-(NSString*)getParam:(NSString*)buf :(NSString*)para_name
{
    NSString*ftxt=@"";
    NSString*searh=[para_name lowercaseString];
    NSRange find=[[buf lowercaseString] rangeOfString:searh];
    if (find.length>0) {
        ftxt=[buf substringFromIndex:find.location+find.length];
        find=[ftxt rangeOfString:@";"];
        if (find.length>0) {
            ftxt=[ftxt substringToIndex: find.location];
        }
        NSLog(@"%@",ftxt);
    }
    return ftxt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    txtValue.text=self.scan_content;
    [btnSave setTitle:NSLocalizedString(@"bcardtip_save", nil) forState:0];

    [sN setString:[self getParam:self.scan_content :@"N:"]];
    [sTITLE setString:[self getParam:self.scan_content :@"TITLE:"]];
    [sM setString:[self getParam:self.scan_content :@"M:"]];
    [sEMAIL setString:[self getParam:self.scan_content :@"EMAIL:"]];
    [sORG setString:[self getParam:self.scan_content :@"ORG:"]];
    [sADR setString:[self getParam:self.scan_content :@"ADR:"]];
    [sURL setString:[self getParam:self.scan_content :@"URL:"]];
    
    lbN.text=[NSString stringWithFormat:@"%@%@",
              NSLocalizedString(@"bcardtip_n", nil),
              sN];
    lbTITLE.text=[NSString stringWithFormat:@"%@%@",
                  NSLocalizedString(@"bcardtip_title", nil),
                  sTITLE];
    lbM.text=[NSString stringWithFormat:@"%@%@",
              NSLocalizedString(@"bcardtip_m", nil),
              sM];
    lbEMAIL.text=[NSString stringWithFormat:@"%@%@",
                  NSLocalizedString(@"bcardtip_email", nil),
                  sEMAIL];
    lbORG.text=[NSString stringWithFormat:@"%@%@",
                NSLocalizedString(@"bcardtip_org", nil),
                sORG];
    lbADR.text=[NSString stringWithFormat:@"%@%@",
                NSLocalizedString(@"bcardtip_adr", nil),
                sADR];
    lbURL.text=[NSString stringWithFormat:@"%@%@",
                NSLocalizedString(@"bcardtip_url", nil),
                sURL];
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
    [self addToContact:@""
                      :sN
                      :sORG
                      :sTITLE
                      :@""
                      :sM
                      :sEMAIL
                      :sADR
                      :sURL];
}

-(void)addToContact:(NSString*)fristname :(NSString*)lastname :(NSString*)org :(NSString*)jobTitle :(NSString*)personPhoneMain :(NSString*)personPhoneMobile :(NSString*)email :(NSString*)address :(NSString*)url
{
    //typedef CFTypeRef ABAddressBookRef;
    //typedef const void * CFTypeRef;
    //指向常量的指针
    ABAddressBookRef addressBook = nil;
    //判断当前系统的版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        //如果不小于6.0，使用对应的api获取通讯录，注意，必须先请求用户的同意，如果未获得同意或者用户未操作，此通讯录的内容为空
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);//等待同意后向下执行//为了保证用户同意后在进行操作，此时使用多线程的信号量机制，创建信号量，信号量的资源数0表示没有资源，调用dispatch_semaphore_wait会立即等待。若对此处不理解，请参看GCD信号量同步相关内容。
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            //如果用户同意，才会执行此block里面的方法
            //此方法发送一个信号，增加一个资源数
            dispatch_semaphore_signal(sema);});
        //如果之前的block没有执行，则sema的资源数为零，程序将被阻塞
        //当用户选择同意，block的方法被执行， sema资源数为1；
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }//如果系统是6.0之前的系统，不需要获得同意，直接访问
    else{
        addressBook = ABAddressBookCreate();
    }

    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(fristname), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastname), &error);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty,(__bridge CFTypeRef)(org), &error);
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)(jobTitle), &error);
    
    //联系人数据添加时间
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString*adddatatime=[NSString stringWithFormat:@"%@%@",currentTime,NSLocalizedString(@"addcantact_notetip", nil)];
    ABRecordSetValue(newPerson, kABPersonNoteProperty,(__bridge CFTypeRef)adddatatime,&error);
    
    //phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(personPhoneMain), kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(personPhoneMobile), kABPersonPhoneMobileLabel, NULL);
    //ABMultiValueAddValueAndLabel(multiPhone, @"", kABOtherLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,&error);
    CFRelease(multiPhone);
    
    
    //email
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(email), nil, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    
    //address
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:address forKey:(NSString *) kABPersonAddressStreetKey];
    [addressDictionary setObject:@"" forKey:(NSString *)kABPersonAddressCityKey];
    [addressDictionary setObject:@"" forKey:(NSString *)kABPersonAddressStateKey];
    [addressDictionary setObject:@"" forKey:(NSString *)kABPersonAddressZIPKey];
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), nil, NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
    CFRelease(multiAddress);
    
    //url
    ABMutableMultiValueRef multiUrl = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiUrl, (__bridge CFTypeRef)(url), nil, NULL);
    ABRecordSetValue(newPerson, kABPersonURLProperty, multiUrl, &error);
    CFRelease(multiUrl);
    
    
    
    ABAddressBookAddRecord(addressBook, newPerson, &error);
    ABAddressBookSave(addressBook, &error);
    if (error != NULL)
    {
        NSLog(@"Danger Will Robinson! Danger!");
    }
    else
    {
        NSLog(@"添加联系人成功.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"addcantact_addok", nil)
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
        alert.tag=1999;
        [alert show];
        alert=nil;
    }
}
- (void)willPresentAlertView:(UIAlertView *)alertView
{
}

// 提示框
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1999:
            [self.navigationController popViewControllerAnimated:YES];
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
