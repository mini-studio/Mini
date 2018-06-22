//
//  MiniFileUtil.m
//  LS
//
//  Created by wu quancheng on 12-7-18.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniFileUtil.h"
#import "NSString+Mini.h"

@implementation MiniFileUtil
SYNTHESIZE_MINI_SINGLETON_FOR_CLASS(MiniFileUtil)
+ (NSString *)fileWithDocumentsPath:(NSString *)path
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *_path = [NSString stringWithFormat:@"%@/user/%@", doc, path];
    NSFileManager *manager = [NSFileManager defaultManager];    
    if ( ![manager fileExistsAtPath:_path]) 
    {
        [manager createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil]; 
    }
    return _path;
}

+ (NSString *)fileWithDocumentsPath:(NSString *)path name:(NSString *)fname
{
    NSString *_path = [self fileWithDocumentsPath:path];
    _path = [NSString stringWithFormat:@"%@/%@",_path,fname];
    return _path;
}

+ (void)deleteDir:(NSString *)dirpath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ( [manager fileExistsAtPath:dirpath]) 
    {
        [manager removeItemAtPath:dirpath error:nil];
    }
}

+ (BOOL)fileExist:(NSString*)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}


+ (NSString *)getFilePathWithUrl:(NSString *)url ext:(NSString *)ext
{
    NSString *md5 = [url MD5String];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [[doc stringByAppendingPathComponent:@"/user/Download/Files/"] stringByAppendingPathComponent:md5];
    path = [NSString stringWithFormat:@"%@.%@",path,ext];
    return path;
}

+ (NSString *)fileExistWithUrl:(NSString *)url ext:(NSString *)ext
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self getFilePathWithUrl:url ext:ext];
    if ( [manager fileExistsAtPath:path]) 
    {
        return path;
    }
    return nil;
}

+ (void)removeFileAtPath:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:path] )
    {
        [fileManager removeItemAtPath:path error:nil];
    }
}

+ (void)loadFileWithUrl:(NSString *)url ext:(NSString *)ext userInfo:(id)userInfo block:(void (^)(NSError *error,NSString *fileLocalPath, id userInfo,bool local))block
{
    NSString  *path = [self fileExistWithUrl:url ext:ext];
    if ( path == nil )
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *path = [self getFilePathWithUrl:url ext:ext];
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = nil;
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:&error];
            [data writeToFile:path atomically:YES];
            if ( error == nil )
                block (nil,path,userInfo,NO);
            else
                block (error,path,userInfo,NO);
        });
    }
    else
    {
        block (nil,path,userInfo,YES);
    }
}


@end
