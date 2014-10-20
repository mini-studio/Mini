//
//  LSObject.m
//  xcmg
//
//  Created by Mini-Studio on 12-11-22.
//  Copyright (c) 2012年 mini. All rights reserved.
//

#import "MiniObject.h"
#import "MiniLog.h"
#import <objc/runtime.h>

@interface MiniObject()
@property (nonatomic,strong)NSMutableDictionary *clazzmap;
@end

@implementation MiniObject

- (id)init
{
    self = [super init];
    if (self) {
        self.clazzmap = [NSMutableDictionary dictionary];
    }
    return self;
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
        else if ( [@"id" isEqualToString:key]) {
            [self setValue:value forKey:@"mid"];
        }
        else {
            if ( [value isKindOfClass:[NSArray class]] ){
                Class clazz = [self classForAttri:key];
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
                Class clazz = [self classForAttri:key];
                if ( clazz != nil ) {
                    MiniObject *o = (MiniObject *)[[clazz alloc] init];
                    [o convertWithJson:value];
                    value = o;
                }
            }
            [self setValue:value forKey:key];
        }
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    LOG_DEBUG(@"=========[%@] %@ undefinedKey==============",[[self class] description],key);
}

- (Class)classForAttri:(NSString *)attriName
{
    return [self.clazzmap valueForKey:attriName];
}

- (void)setAttri:(NSString*)attri clazz:(Class)clazz
{
    [self.clazzmap setValue:clazz forKey:attri];
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
    return @{};
}

- (NSString*)jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
