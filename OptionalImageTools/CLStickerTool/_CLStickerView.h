//
//  _CLStickerView.h
//  Pods
//
//  Created by Panupong Jitchopjai on 9/17/2558 BE.
//
//

#import <UIKit/UIKit.h>
#import "CLStickerTool.h"
static NSString* const kCLStickerToolStickerPathKey = @"stickerPath";
static NSString* const kCLStickerToolDeleteIconName = @"deleteIconAssetsName";

@interface _CLStickerView : UIView
@property (nonatomic,strong) UIPanGestureRecognizer *panGR;
@property (nonatomic,strong) UIPanGestureRecognizer *circlePanGR;
@property (nonatomic,strong) UITapGestureRecognizer *tapGR;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinchGR;

+ (void)setActiveStickerView:(_CLStickerView*)view;
+ (void)setActiveStickerViewWhenTap:(_CLStickerView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool;
- (void)setScale:(CGFloat)scale;
@end
