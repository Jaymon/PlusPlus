//  Created by Jay Marcyes on 8/11/15.

#import "NSString+Plus.h"


@implementation NSString (Plus)

- (NSDictionary *)linksFromHTML
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *tag = nil;
    NSString *body = nil;
    
    // http://stackoverflow.com/questions/2606134/
    while ([scanner isAtEnd] == NO) {
        
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&tag];
        ///tag = [NSString stringWithFormat:@"%@>", tag];
        
        if ([tag hasPrefix:@"<a"] || [tag hasPrefix:@"<A"]) {
            ///enml = [enml stringByReplacingOccurrencesOfString:tag withString:@""];
            
            NSString *pattern = @"href=\"([^\"]+)\"";
            NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive;
            NSError *error = nil;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:options error:&error];
            
            NSRange range = NSMakeRange(0, tag.length);
            ///NSRange match = [regex rangeOfFirstMatchInString:self options:0 range:range];
            NSTextCheckingResult *match = [regex firstMatchInString:tag options:0 range:range];
            
            if (match) {
                
                NSRange group = [match rangeAtIndex:1];
                NSString *link = [tag substringWithRange:group];
                
                [scanner scanUpToString:@"</a>" intoString:&body];
                if (!body) {
                    [scanner scanUpToString:@"</A>" intoString:&body];
                }
                
                body = [[body substringFromIndex:1] stripTags];
                dict[body] = link;
                
            }
            
        }
        
    }
    
    return dict;
    
}

- (NSString *)stripTags
{
    NSString *str = [self copy];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSString *tag = nil;
    
    // http://stackoverflow.com/questions/2606134/
    while ([scanner isAtEnd] == NO) {
        
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&tag];
        tag = [NSString stringWithFormat:@"%@>", tag];
        if (tag) {
            str = [str stringByReplacingOccurrencesOfString:tag withString:@""];
        }
        
    }
    
    return str;

}


@end
