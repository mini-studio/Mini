/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <arpa/inet.h>
#import <netdb.h>
#import <ifaddrs.h>
#import <unistd.h>
#import <dlfcn.h>

#import "UIDevice+Ext.h"
#import "NSString+Mini.h"

int mainVersion = 0;
NSString *mainVersionString = nil;


#define IFT_ETHER 0x6
char *getMacAddress(char *macAddress, char *ifName);
char *getMacAddress(char *macAddress, char *ifName) {
    
    int  success;
    struct ifaddrs  *addrs;
    struct ifaddrs  *cursor;
    const struct sockaddr_dl  *dlAddr;
    const unsigned char *base;
    int i;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != 0) {
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp(ifName,  cursor->ifa_name)==0 ) {
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                strcpy(macAddress, ""); 
                for (i = 0; i < dlAddr->sdl_alen; i++) {
                    if (i != 0) {
                        strcat(macAddress, ":");
                    }
                    char partialAddr[3];
                    sprintf(partialAddr, "%02X", base[i]);
                    strcat(macAddress, partialAddr);
                    
                }
            }
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }    
    return macAddress;
}

@implementation UIDevice (Hardware)

/*
 Platforms
 
 iFPGA ->		??

 iPhone1,1 ->	iPhone 1G
 iPhone1,2 ->	iPhone 3G
 iPhone2,1 ->	iPhone 3GS
 iPhone3,1 ->	iPhone 4/AT&T
 iPhone3,2 ->	iPhone 4/Other Carrier?
 iPhone3,3 ->	iPhone 4/Other Carrier?
 iPhone4,1 ->	??iPhone 5

 iPod1,1   -> iPod touch 1G 
 iPod2,1   -> iPod touch 2G 
 iPod2,2   -> ??iPod touch 2.5G
 iPod3,1   -> iPod touch 3G
 iPod4,1   -> iPod touch 4G
 iPod5,1   -> ??iPod touch 5G
 
 iPad1,1   -> iPad 1G, WiFi
 iPad1,?   -> iPad 1G, 3G <- needs 3G owner to test
 iPad2,1   -> iPad 2G (iProd 2,1)
 
 AppleTV2,1 -> AppleTV 2

 i386, x86_64 -> iPhone Simulator
*/


#pragma mark sysctlbyname utils
- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}

- (NSString *)platform
{
	return [self getSysInfoByName:"hw.machine"];
}


#pragma mark sysctl utils
- (NSUInteger)getSysInfo: (uint)typeSpecifier
{
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return (NSUInteger)results;
}



#pragma mark platform type and name utils
- (NSUInteger)platformType
{
	NSString *platform = [self platform];
	// if ([platform isEqualToString:@"XX"])			return UIDeviceUnknown;
	
	if ([platform isEqualToString:@"iFPGA"])		return UIDeviceIFPGA;

	if ([platform isEqualToString:@"iPhone1,1"])	return UIDevice1GiPhone;
	if ([platform isEqualToString:@"iPhone1,2"])	return UIDevice3GiPhone;
	if ([platform hasPrefix:@"iPhone2"])	return UIDevice3GSiPhone;
	if ([platform hasPrefix:@"iPhone3"])			return UIDevice4iPhone;
	if ([platform hasPrefix:@"iPhone4"])			return UIDevice4SiPhone;
	
	if ([platform isEqualToString:@"iPod1,1"])  return UIDevice1GiPod;
	if ([platform isEqualToString:@"iPod2,1"])  return UIDevice2GiPod;
	if ([platform isEqualToString:@"iPod3,1"])  return UIDevice3GiPod;
	if ([platform isEqualToString:@"iPod4,1"])  return UIDevice4GiPod;
		
	if ([platform isEqualToString:@"iPad1,1"])  return UIDevice1GiPad;
	if ([platform isEqualToString:@"iPad2,1"])  return UIDevice2GiPad;
	
	if ([platform isEqualToString:@"AppleTV2,1"])	return UIDeviceAppleTV2;
	
	/*
	 MISSING A SOLUTION HERE TO DATE TO DIFFERENTIATE iPAD and iPAD 3G.... SORRY!
	 */

	if ([platform hasPrefix:@"iPhone"])return UIDeviceUnknowniPhone;
	if ([platform hasPrefix:@"iPod"])return UIDeviceUnknowniPod;
	if ([platform hasPrefix:@"iPad"])return UIDeviceUnknowniPad;
	
	if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])// thanks Jordan Breeding
	{
		if ([[UIScreen mainScreen] bounds].size.width < 768)
			return UIDeviceiPhoneSimulatoriPhone;
		else 
			return UIDeviceiPhoneSimulatoriPad;

		return UIDeviceiPhoneSimulator;
	}
	return UIDeviceUnknown;
}

- (NSString *)platformString
{
    return [self platform];
}

+ (NSInteger)iosMainVersion
{
    if ( mainVersion==0 ) {
        mainVersionString = [[UIDevice currentDevice] systemVersion];
        NSRange range = [mainVersionString rangeOfString:@"."];
        if (range.location != NSNotFound) {
            mainVersion = [[mainVersionString substringToIndex:range.location] intValue];
        }
        else {
            mainVersion = (int)[mainVersionString floatValue];
        }        
    }
	return mainVersion;
}

+ (BOOL)isVersion:(NSString*)version
{
    if ( mainVersionString == nil ) {
        mainVersionString = [[UIDevice currentDevice] systemVersion];
        mainVersion = [[mainVersionString substringToIndex:1] intValue];
    }
    return (![version compare:mainVersionString]);
}


+ (NSString *)localWiFiIPAddress
{
	BOOL success;
	struct ifaddrs  *addrs;
	const struct ifaddrs  *cursor;
	
	success = getifaddrs(&addrs)== 0;
	if (success){
		cursor = addrs;
		while (cursor != NULL){
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK)== 0)
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
				{
					NSString *ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
					freeifaddrs(addrs);
					return ip;
				}
					
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}

+ (NSString*)wifiMac
{
    char *macAddressString= (char*)malloc(18);
    NSString *macAddress= [[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0")
                                                   encoding:NSMacOSRomanStringEncoding];
    free(macAddressString);
    return [macAddress autorelease];
}

+ (NSString*)customUdid
{
    NSString *mac = [UIDevice wifiMac];
    if (mac.length > 0)
    {
        NSString *u = [NSString stringWithFormat:@"%@@mini",mac];
        return [u MD5String];
    }
    else
    {
        return nil;
    }
}

+ (NSComparisonResult)currentVersionCompare:(CGFloat)version
{
    NSString *v = [[UIDevice currentDevice] systemVersion];
    CGFloat currentV = [v floatValue];
    if (currentV == version)
    {
        return NSOrderedSame;
    }
    else if (currentV > version)
    {
        return NSOrderedDescending;
    }
    else
    {
        return NSOrderedAscending;
    }
}

+ (NSString*)udid
{
    return [self customUdid];
}

+ (BOOL)isPad
{
    //return ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad );
    NSString *deviceType = [UIDevice currentDevice].model;
    return [deviceType isEqualToString:@"iPad"];
}

+ (BOOL)isPhone
{
    NSString *deviceType = [UIDevice currentDevice].model;
    return [deviceType isEqualToString:@"iPhone"];
}

+ (BOOL)isPodTouch
{
    NSString *deviceType = [UIDevice currentDevice].model;
    return [deviceType isEqualToString:@"iPod touch"];
}

+ (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
    {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath])
    {
        jailbroken = YES;
    }
    return jailbroken;
}

@end
