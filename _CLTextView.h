//
//  _CLTextView.h
//  Pods
//
//  Created by Panupong Jitchopjai on 9/17/2558 BE.
//
//
#import "CLTextTool.h"
#import <UIKit/UIKit.h>
#import "CLTextSettingView.h"

@interface _CLTextView : UIView
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) CLTextSettingView *settingView;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;


+ (void)setActiveTextView:(_CLTextView*)view;
+ (void)setActiveSettingView:(_CLTextView*)view;
+ (void)setActiveSettingViewForPan:(_CLTextView*)view;
+ (void)setActiveTextViewWhenTap:(_CLTextView*)view;
- (id)initWithTool:(CLTextTool*)tool;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;
@end
