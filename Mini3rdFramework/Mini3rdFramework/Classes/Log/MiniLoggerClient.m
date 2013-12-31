//
//  HaloLoggerClient.m
//  HaloCoreFramework
//
//  Created by wu quancheng on 12-6-26.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "MiniLoggerClient.h"

void LogMessageF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, NSString *format, ...)
{
    if ( format == nil )
    {
        NSLog( @"[%@ %d] %s-%d %@",domain,level,functionName,lineNumber,@"(nil)");
    }
    else
    {
        va_list args;
        va_start(args, format);
        NSString *msgString = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *logmsgString = [NSString stringWithFormat:@"[%@ %d] %s-%d %@",domain,level,functionName,lineNumber,msgString];
        NSLog( @"%@",logmsgString);
        [msgString release];
        va_end(args);   
    }
}

void LogImageDataF(const char *filename, int lineNumber, const char *functionName, NSString *domain, int level, int width, int height, NSData *data)
{
    
}

