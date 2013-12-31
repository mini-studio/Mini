//
//  MiniImageCache.m
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import "MiniImageCache.h"
#import "NSString+Mini.h"
@implementation MiniImageCache
SYNTHESIZE_MINI_SINGLETON_FOR_CLASS(MiniImageCache)

- (NSString *)getImageFilePathWithUrl:(NSString *)url
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory () stringByAppendingPathComponent:@"Documents/Download/Images/"];
    BOOL isDirectory = YES;
    BOOL fileExistsAtPath = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    if ( !fileExistsAtPath || !isDirectory  )
    {
        if ( !isDirectory )
        {
            [manager removeItemAtPath:path error:nil];
        }
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *md5 = [url MD5String];
    path = [path stringByAppendingPathComponent:md5];
    return path;
}

- (UIImage *)getImageWithUrl:(NSString *)url
{
    NSFileManager *manager = [NSFileManager defaultManager];
    UIImage *image = nil;
    NSString *path = [self getImageFilePathWithUrl:url];
    if ( [manager fileExistsAtPath:path]) 
    {
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

- (void)cacheImageWithUrl:(NSString *)url userInfo:(id)userInfo block:(void (^)(NSError *error,UIImage *image,id userInfo,bool local))block
{
    UIImage *image = [self getImageWithUrl:url];
    if ( image == nil )
    {
        NSString *path = [self getImageFilePathWithUrl:url];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error = nil;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:&error];
            if ( error == nil )
            {
                [data writeToFile:path atomically:YES];
                UIImage *image = [UIImage imageWithData:data];
                if ( image )
                {
                    block (nil,image,userInfo,NO);
                }
            }
        });
    }
    else
    {
        block (nil,image,userInfo,YES);
    }
}
@end
