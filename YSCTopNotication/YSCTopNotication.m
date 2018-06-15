//
//  YSCTopNotication.m
//  YSCTopNotication
//
//  Created by doc88 on 2017/4/13.
//  Copyright © 2017年 doc888. All rights reserved.
//

#define UIScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define UIScreenHeigh ([[UIScreen mainScreen] bounds].size.height)

#import "YSCTopNotication.h"

#define kNOTIFICATION_VIEW_HEIGHT 100

@interface YSCTopNotication ()

@property (nonatomic,readonly,getter=isShowing) BOOL showing;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *backgroundView;

/* view */
@property (nonatomic, strong) UIView *shelterView;

/* superView */
@property (nonatomic, strong) UIView *superView;

/* message */
@property (nonatomic, copy) NSString *message;

/* tapLabel */
@property (nonatomic, strong) UILabel *tapLabel;


@end

@implementation YSCTopNotication

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.textColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:14];
        self.delaySeconds = 1.5f;
        [self.backgroundView addSubview:self.titleLabel];
        
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNotification)];
        
        [self.backgroundView addGestureRecognizer:dismissTap];
    }
    
    return self;
}

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    static id shareInstance;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (void)setOptions:(NSDictionary *)options {
    
    if (!options) {
        return;
    }
    
    if (options[YSC_BACKGROUND_COLOR_KEY]) {
        [YSCTopNotication shareManager].backgroundColor = options[YSC_BACKGROUND_COLOR_KEY];
    }
    
    if (options[YSC_TEXT_COLOR_KEY]) {
        [YSCTopNotication shareManager].textColor = options[YSC_TEXT_COLOR_KEY];
    }
    
    if (options[YSC_TEXT_FONT_KEY]) {
        [YSCTopNotication shareManager].textFont = options[YSC_TEXT_FONT_KEY];
    }
    
    if (options[YSC_DELAY_SECOND_KEY]){
        [YSCTopNotication shareManager].delaySeconds = [options[YSC_DELAY_SECOND_KEY] floatValue];
    }
}

+ (void)showMessage:(NSString *)message ShelterView:(UIView *)shelterView InSuperView:(UIView *)superView {
    
    [YSCTopNotication showMessage:message ShelterView:shelterView InSuperView:superView withOptions:nil completeBlock:nil];
}

+ (void)showMessage:(NSString *)message ShelterView:(UIView *)shelterView InSuperView:(UIView *)superView withOptions:(NSDictionary *)options {
    
    [YSCTopNotication showMessage:message ShelterView:shelterView InSuperView:superView withOptions:options completeBlock:nil];
}

+ (void)showMessage:(NSString *)message ShelterView:(UIView *)shelterView InSuperView:(UIView *)superView withOptions:(NSDictionary *)options completeBlock:(void(^)(void))completeBlock {
    
    [YSCTopNotication shareManager].message = message;
    [YSCTopNotication shareManager].shelterView = shelterView;

    if (superView) {
         [YSCTopNotication shareManager].superView = superView;
    }
   
    [YSCTopNotication shareManager].completeBlock = completeBlock;
    
    [YSCTopNotication setOptions:options];
    
    if ([[YSCTopNotication shareManager] isShowing]) {
        
        [[YSCTopNotication shareManager] reDisplayTitleLabel:message];
        
    }else{
        
        [[YSCTopNotication shareManager] showNotification:message];
        
    }
}

+ (void)showMessage:(NSString *)message{
    
    [YSCTopNotication showMessage:message withOptions:nil completeBlock:nil];
    
}

+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options{
    
    [YSCTopNotication showMessage:message withOptions:options completeBlock:nil];
    
}



+ (void)showMessage:(NSString *)message withOptions:(NSDictionary *)options completeBlock:(void(^)(void))completeBlock{
    
    [YSCTopNotication shareManager].completeBlock = completeBlock;
    
    [YSCTopNotication setOptions:options];
    
    if ([[YSCTopNotication shareManager] isShowing]) {
        
        [[YSCTopNotication shareManager] reDisplayTitleLabel:message];
        
    }else{
        
        [[YSCTopNotication shareManager] showNotification:message];
        
    }
    
}

#pragma mark - Public Methods
/**
 *  重新设置titleLabel backgroundView 背景等
 *
 *  @param message 需要显示的message
 */

- (void)setupViewOptionsWithMessage:(NSString *)message{
    
    self.backgroundView.backgroundColor = self.backgroundColor;
    
    self.titleLabel.textColor = self.textColor;
    
    self.titleLabel.font = self.textFont;
    
    self.titleLabel.text = message;
    
}

/**
 *  显示一条消息通知
 *
 *  @param message 需要显示的信息
 */

- (void)showNotification:(NSString *)message{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    
    [self setupViewOptionsWithMessage:message];
    
    CGSize lableSize = [message boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : self.textFont} context:nil].size;
    
    NSLog(@"bounds - %@",NSStringFromCGRect([YSCTopNotication shareManager].shelterView.bounds));
    NSLog(@"frame - %@",NSStringFromCGRect([YSCTopNotication shareManager].shelterView.frame));
    
    self.backgroundView.frame = CGRectMake(0, [YSCTopNotication shareManager].shelterView.bounds.size.height-lableSize.height-10, [[UIScreen mainScreen] bounds].size.width, lableSize.height+10);
    self.backgroundView.alpha = 0.0;
    
    [self resizeTitleLabelFrame];
    
    if ([YSCTopNotication shareManager].superView && [YSCTopNotication shareManager].shelterView) {
         [[YSCTopNotication shareManager].superView insertSubview:self.backgroundView belowSubview:[YSCTopNotication shareManager].shelterView];
    } else {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.backgroundView];
    }
   
    
   
    
    [UIView animateWithDuration:.5 animations:^{

        self.backgroundView.frame = CGRectMake(0, [YSCTopNotication shareManager].shelterView.frame.size.height, self.backgroundView.frame.size.width, lableSize.height+10);
        self.backgroundView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
        
    }];
    
}

#pragma mark - Private Methods

/**
 *  当消息通知已经显示时  重新显示titleLabel
 *
 *  @param message 需要显示的消息
 */

- (void)reDisplayTitleLabel:(NSString *)message{
    
    //取消之前通知隐藏notification
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissNotification) object:nil];
    
    CGSize lableSize = [message boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : self.textFont} context:nil].size;
    
//    CABasicAnimation *firstAnimation = [CABasicAnimation animationWithKeyPath:@"firstAnimation"];
//    [firstAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
//    [firstAnimation setToValue:[NSNumber numberWithFloat:1.0]];
//    // Here's the important part
//    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, lableSize.height + 10 + 10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
//    
//    self.backgroundView.frame = CGRectMake(0, [YSCTopNotication shareManager].shelterView.frame.size.height, self.backgroundView.frame.size.width, lableSize.height+10);
//    self.backgroundView.alpha = 1.0;
//    
//    [firstAnimation setDuration:1.0];
//    [firstAnimation setBeginTime:0.0];
//    
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.2 animations:^{
        
        weakSelf.titleLabel.frame = CGRectMake(weakSelf.titleLabel.frame.origin.x, lableSize.height + 10 + 10, weakSelf.titleLabel.frame.size.width, weakSelf.titleLabel.frame.size.height);
        
        weakSelf.backgroundView.frame = CGRectMake(0, [YSCTopNotication shareManager].shelterView.frame.size.height, self.backgroundView.frame.size.width, lableSize.height+10);
        weakSelf.backgroundView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [self setupViewOptionsWithMessage:message];
        
        [self resizeTitleLabelFrame];
        
        weakSelf.titleLabel.frame = CGRectMake(weakSelf.titleLabel.frame.origin.x, -10, weakSelf.titleLabel.frame.size.width, weakSelf.titleLabel.frame.size.height);
        
        [UIView animateWithDuration:.1 animations:^{
            
            [weakSelf resizeTitleLabelFrame];
            
        } completion:^(BOOL finished) {
            
            //重新定义调用延迟隐藏notification
            [weakSelf performSelector:@selector(dismissNotification) withObject:nil afterDelay:self.delaySeconds];
        }];
    }];
    
    
    
    
}

- (void)resizeTitleLabelFrame{
    
    CGRect titleFrame = self.titleLabel.frame;
    
    CGSize lableSize = [self.message boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : self.textFont} context:nil].size;
    
    titleFrame.size = [self.titleLabel sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, lableSize.height)];
    
    titleFrame.origin = CGPointMake(self.backgroundView.frame.size.width/2 - titleFrame.size.width/2, self.backgroundView.frame.size.height/2 - titleFrame.size.height/2 );
    
    self.titleLabel.frame = titleFrame;
    
}

/**
 
 *  隐藏通知
 
 */

- (void)dismissNotification{
    
    if (!self.showing) {
        
        return;
        
    }
    
    CGSize lableSize = [self.message boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : self.textFont} context:nil].size;
    
    [UIView animateWithDuration:.5 animations:^{
        
        self.backgroundView.frame = CGRectMake(0, [YSCTopNotication shareManager].shelterView.bounds.size.height-lableSize.height-10, self.backgroundView.frame.size.width, lableSize.height+10);
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.backgroundView removeFromSuperview];
        
        if (self.completeBlock) {
            
            self.completeBlock();
            
            self.completeBlock = nil;
            
        }
        
    }];
    
}

#pragma mark - getters & setters

- (UIView *)backgroundView{
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -kNOTIFICATION_VIEW_HEIGHT, [[UIScreen mainScreen] bounds].size.width, kNOTIFICATION_VIEW_HEIGHT)];
        
        _backgroundView.alpha = 0;
        
        _backgroundView.clipsToBounds = YES;
        
    }
    
    return _backgroundView;
    
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _titleLabel.numberOfLines = 2;
        
    }
    
    return _titleLabel;
    
}

- (BOOL)isShowing{
    
    return self.backgroundView && self.backgroundView.superview;
    
}

@end
