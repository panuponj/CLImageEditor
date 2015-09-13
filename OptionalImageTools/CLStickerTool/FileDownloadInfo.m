//
//  FileDownloadInfo.m
//  Pods
//
//  Created by Panupong Jitchopjai on 8/22/2558 BE.
//
//

#import "FileDownloadInfo.h"

@implementation FileDownloadInfo
-(id)initWithFileTitle:(NSString *)title andDownloadSource:(NSString *)source{
    if (self == [super init]) {
        self.fileTitle = title;
        self.downloadSource = source;
        self.downloadProgress = 0.0;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
    }
    
    return self;
}
@end
