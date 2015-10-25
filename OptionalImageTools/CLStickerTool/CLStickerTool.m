//
//  CLStickerTool.m
//
//  Created by sho yakushiji on 2013/12/11.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLStickerTool.h"

#import "CLCircleView.h"
#import "CollectionStickerViewCell.h"
#import "PFStickerShopTBViewController.h"
#import  <Parse/Parse.h>
#import  <ParseUI/PFImageView.h>
#import "_CLStickerView.h"
#import "_CLTextView.h"

/*
static NSString* const kCLStickerToolStickerPathKey = @"stickerPath";
static NSString* const kCLStickerToolDeleteIconName = @"deleteIconAssetsName";
*/
/*
@interface _CLStickerView : UIView
@property (nonatomic,strong) UIPanGestureRecognizer *panGR;
@property (nonatomic,strong) UIPanGestureRecognizer *circlePanGR;
@property (nonatomic,strong) UITapGestureRecognizer *tapGR;

+ (void)setActiveStickerView:(_CLStickerView*)view;
+ (void)setActiveStickerViewWhenTap:(_CLStickerView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image tool:(CLStickerTool*)tool;
- (void)setScale:(CGFloat)scale;
@end
*/


@implementation CLStickerTool
{
    UIImage *_originalImage;
  //  UIImageView *_org2;
    
    UIView *_workingView;
   // UIScrollView *_workingView;
    
    UIScrollView *_menuScroll;
    UIButton *_buttontest;
    UIView *_stickerView;
    int *tagButton ;
    NSInteger countSticker;
    
    NSMutableArray *stickerId;
    NSURL *docDirectoryURL;
    NSString *documentsDirectory;
    NSMutableArray *listExisingSticker;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLStickerTool_DefaultTitle" withDefault:@"Sticker"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 7;
}

#pragma mark- optional info

+ (NSString*)defaultStickerPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/stickers", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{
             kCLStickerToolStickerPathKey:[self defaultStickerPath],
             kCLStickerToolDeleteIconName:@"",
             };
}

#pragma mark- implementation

- (void)setup
{
    tagButton = 0;
    _originalImage = self.editor.imageView.image;
   // _org2 = self.editor.imageView;
   
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    docDirectoryURL = [URLs objectAtIndex:0];
    
    NSLog(@"directory :%@",docDirectoryURL);
    
    
   //[self.editor fixZoomScaleWithAnimated:YES];
    
    
     _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.showsHorizontalScrollIndicator = YES;
    _menuScroll.backgroundColor = [UIColor blueColor];
    
   
  /*
    _menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(self.editor.menuView.frame.origin.x, self.editor.menuView.frame.origin.y,self.editor.menuView.frame.size.width,self.editor.menuView.frame.size.height - 20)];*/
    
    /*_menuContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.editor.view.height-280, self.editor.view.width, 280)];*/
    
    
    
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    
   /* _buttontest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttontest setTitle:@"a1" forState:UIControlStateNormal];
    _buttontest.frame = CGRectMake(self.editor.menuView.frame.origin.x, self.editor.menuView.frame.origin.y + _menuScroll.frame.size.height,40, 20);
    _buttontest.backgroundColor = UIColor.blackColor;
    [self.editor.view addSubview:_buttontest];*/
    
  //  _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
   // _workingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.editor.containerView.frame.size.width, self.editor.imageView.frame.size.height)];
    
  /*
    
    _workingView = [[UIView alloc]initWithFrame:[self.editor.containerView convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    
 */
    
    _workingView  = self.editor.decorateView;
    
    
    //_workingView = [[UIView alloc]initWithFrame:[self.editor.view convertRect:self.editor.containerView.frame fromView:self.editor
                                          //       .containerView.superview]];
    
    _workingView.clipsToBounds = YES;
   // _workingView.backgroundColor = [UIColor redColor];
   // [_workingView addSubview:_org2];
     //self.editor.imageView.hidden = YES;
   // _workingView.delegate = self;
   // _workingView.backgroundColor = [UIColor blackColor];
    [self.editor.containerView addSubview:_workingView];
    //[self.editor.containerView bringSubviewToFront:_workingView];
    //[self.editor.view addSubview:_workingView];
    [self.editor resetZoomScaleWithAnimated:YES];
    
    //_workingView.userInteractionEnabled = YES;
    
   // [self setStickerMenu];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
     layout.sectionInset = UIEdgeInsetsMake(15, 32, 32, 32);
    
   // _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _menuScroll.frame.size.width,_menuScroll.frame.size.height - 30 ) collectionViewLayout:layout];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _menuScroll.frame.size.width,_menuScroll.frame.size.height ) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView setBackgroundColor:[UIColor grayColor]];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
   /* [_collectionView registerClass:[CollectionStickerViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];*/
    
    
    [_menuScroll addSubview:_collectionView];
    
    
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Sticker"];
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager]createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    
    NSLog(@"dir %@",documentsDirectory);
    
    stickerId = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Sticker"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"Seq_number" notContainedIn:[NSArray arrayWithArray:[self listFileAtPath:documentsDirectory]]];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            
            
           
            
            for (PFObject *object in objects) {
                NSLog(@"object id : %@", object.objectId);
                
                countSticker = objects.count;
                
                
              

                
                
                
                PFFile *featureImageFile = [object objectForKey:@"sticker_file"];
                NSString *seq_number = [object objectForKey:@"Seq_number"];
                if (featureImageFile != nil) {
                    [featureImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        
                     //   NSLog(@"file name: %@",featureImageFile.name);
                        
                        
                        UIImage *thumbnailImage = [UIImage imageWithData:imageData];
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSString* path = [documentsDirectory stringByAppendingPathComponent:[seq_number stringByAppendingString:@".png" ]];
                            NSData* data = UIImagePNGRepresentation(thumbnailImage);
                            [data writeToFile:path atomically:YES];
                            
                           
                            
                            [_collectionView reloadData];
                            
                            NSLog(@"path upload: %@",documentsDirectory);
                        });
                        
                    }];
                }
                
                
                
                
                [stickerId addObject:seq_number];
                stickerId =  [NSMutableArray arrayWithArray:[stickerId sortedArrayUsingDescriptors:
                                                             @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                                                             ascending:NO]]]];
               
               
                
            }
            
            [_collectionView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    
    
    
    
    _stickerView = [[UIView alloc]initWithFrame:CGRectMake(0,_menuScroll.frame.size.height - 30, self.editor.view.width, 30)];
    _stickerView.backgroundColor = [UIColor blackColor];
    _stickerView.layer.borderColor = [UIColor redColor].CGColor;
    _stickerView.layer.borderWidth = 3.0f;
    
    
    UIButton *add_btn = [[UIButton alloc]initWithFrame:CGRectMake(self.editor.view.width * 0.9, 0,self.editor.view.width * 0.1, 30)];
    add_btn.backgroundColor = [UIColor grayColor];
    [add_btn setImage:[UIImage imageNamed:@"add186.png"] forState:UIControlStateNormal];
    [add_btn addTarget:self action:@selector(buttonAddStickerClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stickerView addSubview:add_btn];
   
    
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.editor.view.width * 0.8 , 30)];
    
    int x = 0;
    CGRect frame;
    for (int i = 0; i < 10; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i == 0) {
            frame = CGRectMake(0, 0, 40, 30);
        } else {
            frame = CGRectMake((i * 20) + (i*20) + 0, 0, 40, 30);
        }
        
        button.frame = frame;
        [button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];
        [button setTag:i];
        [button setBackgroundColor:[UIColor greenColor]];
        [button addTarget:self action:@selector(buttonCategoryClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *img = [UIImage imageNamed:@"DoodleIcons-2"];
        UIImage *img2 = [UIImage imageNamed:@"DoodleIcons-3"];
        
        [button setImage:img forState:UIControlStateNormal];
       // [button setImage:img2 forState:UIControlStateHighlighted];
        //[button setImage:img2 forState:UIControlStateSelected];
        //button.highlighted = YES;
      // [button setTintColor:[UIColor whiteColor]];
        [button setTag:i];
        [scrollView addSubview:button];
        
        if (i == 9) {
            x = CGRectGetMaxX(button.frame);
        }
        
    }
    
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor redColor];
    [_stickerView addSubview:scrollView];
    //[_menuScroll addSubview:_stickerView];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
    
    
    
    //[self.editor.view bringSubviewToFront:_stickerView];
    
}
/*
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _org2;
}

*/

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *uiImageView ;
    PFImageView *pfImageView;
    
   
    UITapGestureRecognizer *tapGestureRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedStickerPanel:)];
    tapGestureRecogn.numberOfTapsRequired = 1;
    [tapGestureRecogn setDelegate:self];
   // [uiImageView addGestureRecognizer:tapGestureRecogn];
  //  [tapGestureRecogn release];
    
    
    
    
  /*
    
    NSString *stickerPath = self.toolInfo.optionalInfo[kCLStickerToolStickerPathKey];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPath]; }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    
    NSString *path = list[indexPath.row];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, path];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if(image){
         cell.userInfo = @{@"filePath" : filePath};
       uiImageView = [[UIImageView alloc]initWithImage:image];
       uiImageView.frame = CGRectMake(0, 0, 50, 50);
        
        
        [cell addSubview:uiImageView];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:tapGestureRecogn];
    }
   */
    
    
   
    
   
    
    
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                    //     NSUserDomainMask, YES);
   // NSString *documentsDirectory = [paths objectAtIndex:0];
    //documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Sticker"];
    //documentsDirectory = [documentsDirectory stringByAppendingString:@"Sticker"];
    
    NSLog(@"list file at path");
    //[self listFileAtPath:documentsDirectory];
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[stickerId[indexPath.row] stringByAppendingString:@".png"]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    if (image == nil) {
        image =  [UIImage imageNamed:@"camera"];
    }
    
     cell.userInfo = @{@"filePath" : path};
    
    uiImageView = [[UIImageView alloc]init];
    uiImageView.frame = CGRectMake(0, 0, 60, 60);
    uiImageView.image = image;
  
    
    
    [cell addSubview:uiImageView];
    cell.userInteractionEnabled = YES;
    [cell addGestureRecognizer:tapGestureRecogn];
    
    /*static NSString *cellIdentifier = @"cellIdentifier";
    
    CollectionStickerViewCell *cell = (CollectionStickerViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
      [cell.imageView setImage:[UIImage imageNamed:@"DoodleIcons-2"]] ;*/
    
    return cell;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  /*  NSString *stickerPath = self.toolInfo.optionalInfo[kCLStickerToolStickerPathKey];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPath]; }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    return [list count];*/
    
    return countSticker;
}



- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    
   /*[_workingView removeFromSuperview];*/
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_CLStickerView setActiveStickerView:nil];
    [self.editor.scrollView setZoomScale:1.0 animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      // UIImage *image = [self buildImage:_originalImage];
        UIImage *image = [self buildImage:self.editor.imageView.image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

- (void)executeWithCompletionViewBlock:(void (^)(UIView *, NSError *, NSDictionary *))completionBlock
{
    [_CLStickerView setActiveStickerView:nil];
    [_CLTextView setActiveTextView:nil];
    
    [self.editor.scrollView setZoomScale:1.0 animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // UIImage *image = [self buildImage:_originalImage];
        UIView *decorateView = _workingView;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(decorateView, nil, nil);
        });
    });
}



#pragma mark-

- (void)setStickerMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    NSString *stickerPath = self.toolInfo.optionalInfo[kCLStickerToolStickerPathKey];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPath]; }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    
    for(NSString *path in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, path];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image){
            CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedStickerPanel:) toolInfo:nil];
          
            //view.iconImage = [image aspectFill:CGSizeMake(50, 50)];
            view.iconImage = image ;
            
            
            view.userInfo = @{@"filePath" : filePath};
            
            [_menuScroll addSubview:view];
            x += W;
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

-(void) buttonAddStickerClick:(UIButton*)sender
{
   PFStickerShopTBViewController *myNewVC = [[PFStickerShopTBViewController alloc] init];
    
    // do any setup you need for myNewVC
    
    [self.editor presentModalViewController:myNewVC animated:YES];
}


-(void) buttonCategoryClick:(UIButton*)sender
{
    if (tagButton != 0) {
        UIButton *bottonWasPressed = (UIButton *) [_menuScroll viewWithTag:tagButton];
        //[bottonWasPressed setImage:[UIImage imageNamed:@"DoodleIcons-2"] forState:UIControlStateNormal];
       // bottonWasPressed.backgroundColor = [UIColor greenColor];
        [bottonWasPressed setBackgroundColor:[UIColor greenColor]];
        
    }
    tagButton = sender.tag;
    
    //[sender setImage:[UIImage imageNamed:@"DoodleIcons-3"] forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor grayColor]];
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CLImageEditor" ofType:@"bundle"]];
    CLImageToolInfo *tool = [self.editor.toolInfo subToolInfoWithToolName:@"CLStickerTool" recursive:NO];
    tool.optionalInfo[@"stickerPath"] = [[bundle bundlePath] stringByAppendingPathComponent:@"TestDir"];
    [_collectionView reloadData];
    /*sender.highlighted = YES;*/
 
    /*   [_menuScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    NSString *stickerPath = self.toolInfo.optionalInfo[kCLStickerToolStickerPathKey];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPath]; }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    NSInteger fixStickerRound = 1;
    for(NSString *path in list){
        if (fixStickerRound < 3) {
            
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, path];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image){
            CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedStickerPanel:) toolInfo:nil];
            
            //view.iconImage = [image aspectFill:CGSizeMake(50, 50)];
            view.iconImage = image ;
            
            
            view.userInfo = @{@"filePath" : filePath};
            
            [_menuScroll addSubview:view];
            x += W;
        }
            fixStickerRound = fixStickerRound + 1;
        }
        
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);*/
}

- (void)tappedStickerPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
   NSString *filePath = view.userInfo[@"filePath"];
    
    
    
    if(filePath)
{
    
                    
    
                        _CLStickerView *view = [[_CLStickerView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath] tool:self];
                        CGFloat ratio = MIN( (0.5 * _workingView.width) / view.width, (0.5 * _workingView.height) / view.height);
                        // CGFloat ratio = MIN( (0.5 * self.editor.imageView.width) / view.width, (0.5 * self.editor.imageView.height) / view.height);
                        [view setScale:ratio];
                        view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
                        //  [self.editor.scrollView.g]
                        for (UIGestureRecognizer *gr in self.editor.scrollView.gestureRecognizers)
                        {
                            if ([gr isKindOfClass:[UIPanGestureRecognizer class]])
                            {
                                [gr requireGestureRecognizerToFail:view.panGR];
                                [gr requireGestureRecognizerToFail:view.circlePanGR];
                                [gr requireGestureRecognizerToFail:view.tapGR];
                                [gr requireGestureRecognizerToFail:view.pinchGR];
                            }
                        }
                        
                        // view.center = CGPointMake(self.editor.imageView.width/2, self.editor.imageView.height/2);
                        
                        [_workingView addSubview:view];
                        /*     [self.editor.view addSubview:view];
                         NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.editor.imageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0 ];
                         NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.editor.imageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
                         
                         [self.editor.view addConstraints:[NSArray arrayWithObjects:xConstraint  , yConstraint, nil]];*/
                        
                        // [_workingView bringSubviewToFront:view];
                        [_CLStickerView setActiveStickerView:view];
                        
    
                    
    
    

    
        
        
    }
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
}


-(NSMutableArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    NSMutableArray *exisitingObjectId = [[NSMutableArray alloc]init];
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
   
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
        
        
        if (![[directoryContent objectAtIndex:count] isEqualToString:@".DS_Store" ])
        {
            [exisitingObjectId addObject:[[directoryContent objectAtIndex:count] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
            [stickerId addObject:[[directoryContent objectAtIndex:count] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
        }
        
    }

    
    
    stickerId =  [NSMutableArray arrayWithArray:[stickerId sortedArrayUsingDescriptors:
                                                 @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                                                 ascending:NO]]]];
    
    countSticker = stickerId.count;
    NSLog(@"count sticker %lu",(unsigned long)stickerId.count);
    [_collectionView reloadData];
    return exisitingObjectId;
}


- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGFloat scaleY = image.size.height / _workingView.height;
    
   // CGFloat scale = 1;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scaleY);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end
/*

@implementation _CLStickerView
{
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
		
        [_deleteButton setImage:[tool imageForKey:kCLStickerToolDeleteIconName defaultImageName:@"btn_delete.png"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _deleteButton.userInteractionEnabled = YES;
        
        [self addSubview:_deleteButton];
        
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        
        */





   /*     _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor blackColor];
        _circleView.borderWidth = 5;*/



/*
        _circleView.backgroundColor = [UIColor clearColor];
        
        resizeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        
        resizeIcon.image = [UIImage imageNamed:@"rsz_resizebtn.png"];
        
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
    
    [_imageView addGestureRecognizer:_tapGR];
    [_imageView addGestureRecognizer:_panGR];
   
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

@end*/
