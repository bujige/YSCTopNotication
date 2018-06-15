//
//  YSCNotificationManager.h
//  YSCNotificationManager
//
//  Created by doc88 on 2017/4/13.
//  Copyright © 2017年 doc888. All rights reserved.
//

#define YSC_TEXT_FONT_KEY @"YSC_TEXT_FONT_KEY"
#define YSC_TEXT_COLOR_KEY @"YSC_TEXT_COLOR_KEY"
#define YSC_DELAY_SECOND_KEY @"YSC_DELAY_SECOND_KEY"
#define YSC_BACKGROUND_COLOR_KEY @"YSC_BACKGROUND_COLOR_KEY"
#define YSC_BACKVIEW_HEIGHT_KEY @"YSC_BACKVIEW_HEIGHT_KEY"

typedef void(^YSCCompleteBlock)(void);

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YSCTopNotication : NSObject

/**
 *  delaySeconds:       延迟几秒消失
 *  textFont:           字体大小
 *  textColor:          字体颜色
 *  backgroundColor:    背景颜色
 *  completeBlock:      完成后的回调
 */
@property (nonatomic) CGFloat delaySeconds;

@property (nonatomic,strong) UIFont *textFont;

@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,strong) UIColor *backgroundColor;

@property (nonatomic,copy) YSCCompleteBlock completeBlock;

+ (instancetype)shareManager;

+ (void)setOptions:(NSDictionary *)options;

+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options;

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options completeBlock:(void(^)(void))completeBlock;

+ (void)showMessage:(NSString *)message ShelterView:(UIView *)shelterView InSuperView:(UIView *)superView;

+ (void)showMessage:(NSString *)message ShelterView:(UIView *)shelterView InSuperView:(UIView *)superView withOptions:(NSDictionary *)options;

+ (void)showMessage:(NSString *)message ShelterView:(UIView *)shelterView InSuperView:(UIView *)superView withOptions:(NSDictionary *)options completeBlock:(void(^)(void))completeBlock;

@end
