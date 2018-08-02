//
//  LSObject.m
//  xcmg
//
//  Created by Mini-Studio on 12-11-22.
//  Copyright (c) 2012年 mini. All rights reserved.
//

#import "MiniObject.h"
#import "MiniLog.h"
#import "NSArray+MiniObject.h"
#import "NSDictionary+MiniObject.h"
#import <objc/runtime.h>

@interface MiniObject()
@property (nonatomic,strong)NSMutableDictionary *propertyClazzDictionary;
@property (nonatomic,strong)NSMutableDictionary *propertiesDataMap;
@end

@implementation MiniObject

- (id)init
{
    self = [super init];
    if (self) {
        self.propertyClazzDictionary = [NSMutableDictionary dictionary];
        self.propertiesDataMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setClassKey:(NSString*)key dataKey:(NSString*)dataKey
{
    [self.propertiesDataMap setValue:key forKey:dataKey];
}

- (Class)classForAttri:(NSString *)attriName
{
    return [self.propertyClazzDictionary valueForKey:attriName];
}

- (void)setAttri:(NSString*)attri clazz:(Class)clazz
{
    [self.propertyClazzDictionary setValue:clazz forKey:attri];
}

- (void)setPropertyName:(NSString*)propertyName clazz:(Class)clazz
{
    [self.propertyClazzDictionary setValue:clazz forKey:propertyName];
}
- (void)setPropertyName:(NSString*)propertyName dataName:(NSString*)dataName
{
    [self.propertiesDataMap setValue:propertyName forKey:dataName];
}

- (void)convertWithJson:(id)json
{
    if ( json == [NSNull null]) {
        return;
    }
    for ( NSString *key in [json allKeys] ) {
        id value = [json valueForKey:key];
        if ( value==[NSNull null] ) {
            continue;
        }
        else {
            NSString *classKey = [self.propertiesDataMap valueForKey:key];
            if ( [@"id" isEqualToString:key]) {
                if (classKey == nil) {
                    [self setValue:value forKey:@"mid"];
                }
                else {
                   [self setValue:value forKey:classKey];
                }
            }
            else {
                if (classKey == nil) {
                    classKey = key;
                }
                if ( [value isKindOfClass:[NSArray class]] ){
                    Class clazz = [self classForAttri:classKey];
                    if ( clazz != nil ) {
                        NSMutableArray *array = [NSMutableArray array];
                        for ( id v in value ) {
                            MiniObject *o = (MiniObject *)[[clazz alloc] init];
                            [o convertWithJson:v];
                            [array addObject:o];
                        }
                        value = array;
                    }
                }
                else if ( [value isKindOfClass:[NSDictionary class]] ) {
                    Class clazz = [self classForAttri:classKey];
                    if ( clazz != nil ) {
                        MiniObject *o = (MiniObject *)[[clazz alloc] init];
                        [o convertWithJson:value];
                        value = o;
                    }
                }
                [self setValue:value forKey:classKey];
            }
        }
        
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    LOG_DEBUG(@"=========[%@] %@ undefinedKey==============",[[self class] description],key);
}



- (void)encodeWithCoder:(NSCoder*)coder
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    for (NSString *name in propertyArray)
    {
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        Class clazz = [self class];
        u_int count;
        
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        for (int i = 0; i < count ; i++) {
            NSString* propertyName = [NSString  stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            
            id value = [decoder decodeObjectForKey:propertyName];
            if ( value == nil ) {
                NSString* propertyType = [NSString  stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
                if ( [propertyType hasPrefix:@"Tc"] ) {
                    value = [NSNumber numberWithChar:0];
                } else if ( [propertyType hasPrefix:@"Td"] ) {
                    value = [NSNumber numberWithDouble:0.0f];
                } else if (  [propertyType hasPrefix:@"Ti"] ) {
                    value = [NSNumber numberWithInt:0];
                } else if ( [propertyType hasPrefix:@"Tf"]  ) {
                    value = [NSNumber numberWithFloat:0.0f];
                } else if (  [propertyType hasPrefix:@"Tl"] ) {
                    value = [NSNumber numberWithLong:0];
                }  else if ( [propertyType hasPrefix:@"Ts"] ) {
                    value = [NSNumber numberWithShort:0];
                } else if (  [propertyType hasPrefix:@"Tq"] ) {
                     value = [NSNumber numberWithLongLong:0];
                }
            }
            [self setValue:value forKey:propertyName];
        }
        free(properties);
    }
    return self;
}

- (NSDictionary*)dictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *properties = [self __properties__];
    if (properties != nil && properties.count > 0) {
        for(NSString *p in properties) {
            id value = [self valueForKey:p];
            if ([value isKindOfClass:[NSArray class]]) {
                [dic setValue:[(NSArray *)value jsonArray] forKey:p];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                [dic setValue:[(NSDictionary *)value jsonDictionary] forKey:p];
            }
            else {
                [dic setValue:value forKey:p];
            }
        }
    }
    return dic;
}

-(NSArray*)__properties__
{
    NSMutableArray *__properties = [NSMutableArray array];
    int count = 0;
    objc_property_t* properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count ; i++) {
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        [__properties addObject:propertyName];
    }
    return __properties;
}

- (NSString*)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
