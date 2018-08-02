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

+ (NSString *)fileWithDocumentsPath:(NSString *)path delete:(BOOL)del
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *_path = [NSString stringWithFormat:@"%@/%@", doc, path];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:_path]) {
        if (del) {
            [manager removeItemAtPath:_path error:nil];
        }
    }
    if ( ![manager fileExistsAtPath:_path])
    {
        [manager createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _path;
}

+ (NSString *)fileWithDocumentsPath:(NSString *)path
{
    return [self fileWithDocumentsPath:path delete:NO];
}

+ (NSString *)ensureDocumentsPath:(NSString *)path
{
    return [MiniFileUtil fileWithDocumentsPath:path];
}

+ (void)ensurePath:(NSString *)path delete:(BOOL)del error:(NSError**)error
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        if (del) {
            [manager removeItemAtPath:path error:error];
        }
    }
    if ( ![manager fileExistsAtPath:path])
    {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    }
}


+ (void)ensurePath:(NSString *)path error:(NSError**)error
{
    [self ensurePath:path delete:NO error:error];
}

+ (NSString *)ensureLibraryPath:(NSString *)path  delete:(BOOL)del
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_path = [NSString stringWithFormat:@"%@/%@", doc, path];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:_path] && del) {
        [manager removeItemAtPath:_path error:nil];
    }
    if ( ![manager fileExistsAtPath:_path])
    {
        [manager createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _path;
}

+ (NSString *)ensureLibraryPath:(NSString *)path
{
    return [self ensureLibraryPath:path delete:NO];
}


+ (NSString *)fileWithLibraryPath:(NSString *)path name:(NSString *)fname
{
    NSString *_path = [self ensureLibraryPath:path];
    _path = [NSString stringWithFormat:@"%@/%@",_path,fname];
    return _path;
}

+ (NSString *)ensureCachesPath:(NSString *)path
{
    return [self ensureCachesPath:path delete:NO];
}

+ (NSString *)ensureCachesPath:(NSString *)path delete:(BOOL)del
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *_path = [NSString stringWithFormat:@"%@/%@", doc, path];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:_path] && del) {
        [manager removeItemAtPath:_path error:del];
    }
    if ( ![manager fileExistsAtPath:_path])
    {
        [manager createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _path;
}

+ (NSString *)fileWithCachesPath:(NSString *)path name:(NSString *)fname
{
    NSString *_path = [self ensureCachesPath:path];
    _path = [NSString stringWithFormat:@"%@/%@",_path,fname];
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
    NSString *path = [[doc stringByAppendingPathComponent:@"/Download/Files/"] stringByAppendingPathComponent:md5];
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
