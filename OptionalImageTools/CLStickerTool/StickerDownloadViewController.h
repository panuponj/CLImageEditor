//
//  StickerDownloadViewController.h
//  Pods
//
//  Created by Panupong Jitchopjai on 8/22/2558 BE.
//
//

#import <UIKit/UIKit.h>

@interface StickerDownloadViewController : UIViewController <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *arrFileDownloadData;

@property (nonatomic, strong) NSURL *docDirectoryURL;
//@property (nonatomic,weak) UIProgressView *progressView;

-(void)initializeFileDownloadDataArray;
-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;
@end
