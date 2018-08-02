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
- (void)setClassKey:(NSString*)key dataKey:(NSString*)dataKey;

- (void)setPropertyName:(NSString*)propertyName clazz:(Class)clazz;
- (void)setPropertyName:(NSString*)propertyName dataName:(NSString*)dataName;

- (NSString*)jsonString;
- (NSDictionary*)dictionary;
@end
