//
//  MiniFileUtil.h
//  LS
//
//  Created by wu quancheng on 12-7-18.
//  Copyright (c) 2012年 Mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiniFileUtil : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MiniFileUtil)

+ (NSString *)fileWithDocumentsPath:(NSString *)path;

+ (NSString *)fileWithDocumentsPath:(NSString *)path delete:(BOOL)del;

+ (NSString *)ensureDocumentsPath:(NSString *)path;

+ (NSString *)fileWithDocumentsPath:(NSString *)path name:(NSString *)fname;

+ (void)ensurePath:(NSString *)path error:(NSError**)error;

+ (void)ensurePath:(NSString *)path delete:(BOOL)del error:(NSError**)error;

+ (NSString *)ensureLibraryPath:(NSString *)path;

+ (NSString *)ensureLibraryPath:(NSString *)path delete:(BOOL)del;

+ (NSString *)fileWithLibraryPath:(NSString *)path name:(NSString *)fname;

+ (NSString *)ensureCachesPath:(NSString *)path;

+ (NSString *)ensureCachesPath:(NSString *)path delete:(BOOL)del;

+ (NSString *)fileWithCachesPath:(NSString *)path name:(NSString *)fname;

+ (BOOL)fileExist:(NSString*)filePath;

+ (void)deleteDir:(NSString *)dirPath;

+ (void)removeFileAtPath:(NSString*)path;

+ (void)loadFileWithUrl:(NSString *)url ext:(NSString *)ext userInfo:(id)userInfo block:(void (^)(NSError *error,NSString *fileLocalPath, id userInfo,bool local))block;
@end
