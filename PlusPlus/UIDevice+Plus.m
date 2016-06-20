//  Created by Jay Marcyes on 6/20/16.


#import "UIDevice+Plus.h"

#include <sys/sysctl.h>
#include <sys/utsname.h>
#import "NSString+Plus.h"


@implementation UIDevice (Plus)

- (NSString *)modelGeneration
{
    NSString *type = @"Unknown";
    
    // found this here: http://stackoverflow.com/a/18435539/5006
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // https://www.theiphonewiki.com/wiki/Models
    if ([platform hasPrefix:@"iPhone"]) {
        
        if ([platform hasSuffix:@"1,1"]) {
            type = @"iPhone 1G";
            
        } else if ([platform hasSuffix:@"1,2"]) {
            type = @"iPhone 3G";
            
        } else if ([platform hasSuffix:@"2,1"]) {
            type = @"iPhone 3GS";
            
        } else if ([platform hasPrefix:@"iPhone3"]) {
            type = @"iPhone 4";
            
        } else if ([platform hasPrefix:@"iPhone4"]) {
            type = @"iPhone 4s";
            
        } else if ([platform anySuffix:@[@"5,1", @"5,2"]]) {
            type = @"iPhone 5";
            
        } else if ([platform anySuffix:@[@"5,3", @"5,4"]]) {
            type = @"iPhone 5c";
            
        } else if ([platform hasPrefix:@"iPhone6"]) {
            type = @"iPhone 5s";
            
        } else if ([platform hasSuffix:@"7,2"]) {
            type = @"iPhone 6";
            
        } else if ([platform hasSuffix:@"7,1"]) {
            type = @"iPhone 6 Plus";
            
        } else if ([platform hasSuffix:@"8,1"]) {
            type = @"iPhone 6s";
            
        } else if ([platform hasSuffix:@"8,2"]) {
            type = @"iPhone 6s Plus";
            
        } else if ([platform hasSuffix:@"8,4"]) {
            type = @"iPhone SE";
            
        } else {
            type = @"iPhone Unknown";
        }
    
    } else if ([platform hasPrefix:@"iPad"]) {
    
        if ([platform isEqualToString:@"iPad1,1"]) {
            type = @"iPad";
            
        } else if ([platform anySuffix:@[@"2,1", @"2,2", @"2,3", @"2,4"]]) {
            type = @"iPad 2";
            
        } else if ([platform anySuffix:@[@"3,1", @"3,2", @"3,3"]]) {
            type = @"iPad 3";
            
        } else if ([platform anySuffix:@[@"3,4", @"3,5", @"3,6"]]) {
            type = @"iPad 4";
            
        } else if ([platform anySuffix:@[@"4,1", @"4,2", @"4,3"]]) {
            type = @"iPad Air";
            
        } else if ([platform anySuffix:@[@"5,3", @"5,4"]]) {
            type = @"iPad Air 2";
            
        } else if ([platform anySuffix:@[@"2,5", @"2,6", @"2,7"]]) {
            type = @"iPad Mini";
            
        } else if ([platform anySuffix:@[@"4,4", @"4,5", @"4,6"]]) {
            type = @"iPad Mini 2";
            
        } else if ([platform anySuffix:@[@"4,7", @"4,8", @"4,9"]]) {
            type = @"iPad Mini 3";
            
        } else if ([platform anySuffix:@[@"5,1", @"5,2"]]) {
            type = @"iPad Mini 4";
            
        } else if ([platform anySuffix:@[@"6,7", @"6,8"]]) {
            type = @"iPad Pro (12.9 inch)";
            
        } else if ([platform anySuffix:@[@"6,3", @"6,4"]]) {
            type = @"iPad Pro (9.7 inch)";
            
        } else {
            type = @"iPad Unknown";
        }
    
    } else if ([platform hasPrefix:@"Watch"]) {
    
        if ([platform anySuffix:@[@"1,1", @"1,2"]]) {
            type = @"Apple Watch";
            
        } else {
            type = @"Apple Watch Unknown";
        }
        
    } else if ([platform hasPrefix:@"AppleTV"]) {
        
        if ([platform hasSuffix:@"2,1"]) {
            type = @"Apple TV 2G";
            
        } else if ([platform anySuffix:@[@"3,1", @"3,2"]]) {
            type = @"Apple TV 3G";
            
        } else if ([platform hasSuffix:@"5,3"]) {
            type = @"Apple TV 4G";
            
        } else {
            type = @"Apple TV Unknown";
        }
    
    } else if ([platform hasPrefix:@"iPod"]) {
        
        if ([platform hasSuffix:@"1,1"]) {
            type = @"iPod Touch";
            
        } else if ([platform hasSuffix:@"2,1"]) {
            type = @"iPod Touch 2G";
            
        } else if ([platform hasSuffix:@"3,1"]) {
            type = @"iPod Touch 3G";
            
        } else if ([platform hasSuffix:@"5,1"]) {
            type = @"iPod Touch 5G";
            
        } else if ([platform hasSuffix:@"7,1"]) {
            type = @"iPod Touch 6G";
            
        } else {
            type = @"iPod Touch Unknown";
        }
        
    } else {
        
        if ([platform any:@[@"i386", @"x86_64"]]) {
            type = @"Simulator";
            
        }
        
    }
    
    return type;
}

+ (bool)isSimulator
{
    NSString *generation = [self currentDevice].modelGeneration;
    return [generation isEqualToString:@"Simulator"];
}

+ (bool)isPad
{
    return [[self currentDevice].model hasPrefix:@"iPad"];
}

+ (bool)isPhone
{
    return [[self currentDevice].model hasPrefix:@"iPhone"];
}

@end
