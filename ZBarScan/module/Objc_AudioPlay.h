//
//  Objc_AudioPlay.h
//  ZBarScan
//
//  Created by Han.zh on 15/9/28.
//  Copyright © 2015年 Han.zhihong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Objc_AudioPlay : NSObject

+(void)loadFile:(NSString*)file :(SystemSoundID*)soundId;
+(void)play:(SystemSoundID)soundId;

@end