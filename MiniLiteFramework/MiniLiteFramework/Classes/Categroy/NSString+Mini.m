//
//  NSString+Mini.m
//  LS
//
//  Created by wu quancheng on 12-6-10.
//  Copyright (c) 2012年 YouLu. All rights reserved.
//

#import "NSString+Mini.h"
#import "NSData+Base64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString(Mini)
- (NSString*)MD5String 
{
	if (self.length == 0)
	{
		return @"";
	}
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
	
    char md5string[CC_MD5_DIGEST_LENGTH*2];
	
    int i;
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        sprintf(md5string+i*2, "%02x", digest[i]);
    }
	
    return [NSString stringWithCString:md5string encoding:NSASCIIStringEncoding];
}

- (NSString*)trimSpaceAndReturn
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSDate *)dataWithStyle:(DateStyle)style
{
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    switch ( style ) 
    {
        case EDateStyleYMDHM:
        {
            [inputFormatter setDateStyle:NSDateFormatterLongStyle];
            [inputFormatter setTimeStyle:kCFDateFormatterShortStyle];
        }
            break;
        case EDateStyleMDHM:
        {
            NSString *region = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
            if ([region compare:@"cn" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"tw" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"hk" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"mo" options:NSCaseInsensitiveSearch] == NSOrderedSame ||
                [region compare:@"sg" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            {
                [inputFormatter setDateFormat:@"M-d ah:mm"];       
            }
            else
            {
                [inputFormatter setDateFormat:@"M-d h:mm a"];
            }
        }
            break;
        case EDateStyleHM:
        {
            [inputFormatter setDateStyle:NSDateFormatterNoStyle];
            [inputFormatter setTimeStyle:NSDateFormatterShortStyle];  
        }
            break;
        case EDateStyleYMD:
        {
            [inputFormatter setDateStyle:NSDateFormatterLongStyle];
            [inputFormatter setTimeStyle:NSDateFormatterNoStyle];
            
        }
        case EDateStyleY_M_D:
        {
            [inputFormatter setDateFormat:@"yyyy-MM-d"];
            break;
        }
        default:
            break;
    }    
    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    NSDate* inputDate = [inputFormatter dateFromString:self];
    return inputDate;
}

+ (NSString *)uuid
{
    @synchronized ( self )
    {
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        NSInteger integer = [de integerForKey:@"Mini-UUID-STR"];
        if ( integer == 0 )
        {
            integer = 100000;
        }    
        ++integer;
        [de setInteger:integer forKey:@"Mini-UUID-STR"];
        return [NSString stringWithFormat:@"%d",integer];   
    }
}

+ (NSString*)unistring
{
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
	NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return uuidString;
}

- (NSString*)base64Encode
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64Encoding];
}

- (NSString*)base64Decode
{
    NSData *data = [NSData dataWithBase64EncodedString:self];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString*)toHex
{
	NSMutableString *hex = [NSMutableString string];
	for (int i=0; i<[self length]; i++)
	{
		unichar c = [self characterAtIndex:i] & 0xFF;
		[hex appendFormat:@"%02x",c];
	}
	return hex;
}

- (NSData*)toBinData
{
	NSMutableData *data = [NSMutableData data];
	int idx;
	for (idx = 0; idx+2 <= self.length; idx+=2){
		NSRange range = NSMakeRange(idx, 2);
		NSString *hexStr = [self substringWithRange:range];
		NSScanner *scanner = [NSScanner scannerWithString:hexStr];
		unsigned int intValue;
		[scanner scanHexInt:&intValue];
		[data appendBytes:&intValue length:1];
	}
	return data;
}

- (NSString*)EncryptWithKey:(NSString*)key
{
	NSData *data = [[self dataUsingEncoding:NSUTF8StringEncoding] EncryptWithKey:key];
    NSString *result = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    return [result toHex];
}

- (NSString*)DecryptWithKey:(NSString*)key
{
	NSData *data = [[self toBinData] DecryptWithKey:key];
    NSString *result = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    return result;
}

@end
