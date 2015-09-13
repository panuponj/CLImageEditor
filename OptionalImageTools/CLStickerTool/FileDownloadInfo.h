//
//  FileDownloadInfo.h
//  Pods
//
//  Created by Panupong Jitchopjai on 8/22/2558 BE.
//
//

#import <Foundation/Foundation.h>

@interface FileDownloadInfo : NSObject
@property (nonatomic, strong) NSString *fileTitle;

@property (nonatomic, strong) NSString *downloadSource;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSData *taskResumeData;

@property (nonatomic) double downloadProgress;

@property (nonatomic) BOOL isDownloading;

@property (nonatomic) BOOL downloadComplete;

@property (nonatomic) unsigned long taskIdentifier;

-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source;

@end
