//
//  _CLStickerView.m
//  Pods
//
//  Created by Panupong Jitchopjai on 9/17/2558 BE.
//
//

#import "_CLStickerView.h"
#import "CLCircleView.h"

@implementation _CLStickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */{
     UIImageView *_imageView;
     UIButton *_deleteButton;
     CLCircleView *_circleView;
     
     CGFloat _scale;
     CGFloat _arg;
     
     CGPoint _initialPoint;
     CGFloat _initialArg;
     CGFloat _initialScale;
     //UIPanGestureRecognizer *panGR;
     UIImageView *resizeIcon;
     
 }
static _CLStickerView *activeView = nil;
+ (void)setActiveStickerView:(_CLStickerView*)view
{
    //static _CLStickerView *activeView = nil;
    //activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
    
}

+ (void)setActiveStickerViewWhenTap:(_CLStickerView *)view
{
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
    else
    {
        [activeView setAvtive:NO];
        activeView = nil;
    }
    
}

- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+32, image.size.height+32)];
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
       // [_deleteButton setImage:[tool imageForKey:kCLStickerToolDeleteIconName defaultImageName:@"close_btn.png"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _deleteButton.userInteractionEnabled = YES;
        
        [self addSubview:_deleteButton];
        
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        /*     _circleView.radius = 0.7;
         _circleView.color = [UIColor whiteColor];
         _circleView.borderColor = [UIColor blackColor];
         _circleView.borderWidth = 5;*/
        _circleView.backgroundColor = [UIColor clearColor];
         _circleView.color = [UIColor clearColor];
        
        resizeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        
        resizeIcon.image = [UIImage imageNamed:@"resize_btn.png"];
        
        [_circleView addSubview:resizeIcon];
        
        
        
        [self addSubview:_circleView];
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
    _circlePanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)];
    _pinchGR = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    
    [_imageView addGestureRecognizer:_tapGR];
    [_imageView addGestureRecognizer:_panGR];
    [_imageView addGestureRecognizer:_pinchGR];
    
    [_circleView addGestureRecognizer:_circlePanGR];
    // [_panGR requireGestureRecognizerToFail:_tapGR];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)pushedDeleteBtn:(id)sender
{
    _CLStickerView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLStickerView class]]){
            nextTarget = (_CLStickerView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLStickerView class]]){
                nextTarget = (_CLStickerView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _circleView.hidden = !active;
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveStickerViewWhenTap:self];
    NSLog(@"tap sticker view");
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
  /*  recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    
    recognizer.scale = 1;*/
    NSLog(@"pinch");
    
    //[self setScale:recognizer.scale];
   // recognizer.scale = 1;
}

@end
