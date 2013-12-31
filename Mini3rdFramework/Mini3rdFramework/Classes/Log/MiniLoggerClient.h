//
//  HaloLoggerClient.h
//  HaloCoreFramework
//
//  Created by wu quancheng on 12-6-26.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
extern void LogMessageF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, NSString *format, ...);
extern void LogImageDataF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, int width, int height, NSData *data);
#ifdef __cplusplus
};
#endif