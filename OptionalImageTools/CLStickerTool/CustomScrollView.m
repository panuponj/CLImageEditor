//
//  CustomScrollView.m
//  Pods
//
//  Created by Panupong Jitchopjai on 8/2/2558 BE.
//
//

#import "CustomScrollView.h"

@implementation CustomScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
    }
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    /*if ([view isKindOfClass:UIButton.class]) {
        return YES;
    }*/
    return FALSE ;
    
   // return [super touchesShouldCancelInContentView:view];
}

@end
