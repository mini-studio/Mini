//
//  MiniImageCache.h
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface MiniImageCache : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(MiniImageCache)

- (void)cacheImageWithUrl:(NSString *)url userInfo:(id)userInfo block:(void (^)(NSError *error,UIImage *image, id userInfo,bool local))block;

- (UIImage *)getImageWithUrl:(NSString *)url;

- (NSString *)getImageFilePathWithUrl:(NSString *)url;
@end
