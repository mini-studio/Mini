//
//  LSObject.h
//  xcmg
//
//  Created by Mini-Studio on 12-11-22.
//  Copyright (c) 2012年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiniObject : NSObject<NSCoding>
- (void)convertWithJson:(id)json;
- (Class)classForAttri:(NSString *)attriName;
- (void)setAttri:(NSString*)attri clazz:(Class)clazz;
- (NSString*)jsonString;
@end
