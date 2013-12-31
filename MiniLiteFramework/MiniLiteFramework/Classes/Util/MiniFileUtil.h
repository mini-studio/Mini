//
//  MiniFileUtil.h
//  LS
//
//  Created by wu quancheng on 12-7-18.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiniFileUtil : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MiniFileUtil)

+ (NSString *)fileWithDocumentsPath:(NSString *)path;

+ (NSString *)fileWithDocumentsPath:(NSString *)path name:(NSString *)fname;

+ (BOOL)fileExist:(NSString*)filePath;

+ (void)deleteDir:(NSString *)dirpath;

+ (void)removeFileAtPath:(NSString*)path;

+ (void)loadFileWithUrl:(NSString *)url ext:(NSString *)ext userInfo:(id)userInfo block:(void (^)(NSError *error,NSString *fileLocalPath, id userInfo,bool local))block;
@end
