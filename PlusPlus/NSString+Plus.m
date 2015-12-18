//  Created by Jay Marcyes on 8/11/15.

#import "NSString+Plus.h"
#import "UIColor+Plus.h"


@implementation NSString (Plus)

- (BOOL)isHTTPLink
{
    return [self.lowercaseString hasPrefix:@"http"];
}

- (NSArray <NSTextCheckingResult *> *)linksFromHTMLWithPlainTextRanges
{
    NSMutableArray <NSTextCheckingResult *> *links = [NSMutableArray new];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *tag = nil;
    NSString *body = nil;
    NSInteger plainOffset = 0;
    
    // http://stackoverflow.com/questions/2606134/
    while ([scanner isAtEnd] == NO) {
        
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&tag];
        ///tag = [NSString stringWithFormat:@"%@>", tag];
        
        if (tag) {
            
            scanner.scanLocation += [scanner isAtEnd] ? 0 : 1;
            plainOffset += tag.length + 1;
            NSInteger htmlOffset = scanner.scanLocation;
            
            NSTextCheckingResult *match = [tag firstRegularExpressionMatch:@"/^<a\\s+/i"];
            if (match) {
                
                NSArray *regexes = @[
                                     @"/href=\"([^\"]+)/i",
                                     @"/href='([^']+)/i",
                                     @"/href=([^\\s>]+)/i"];
                
                for (NSString *regex in regexes) {
                    
                    match = [tag firstRegularExpressionMatch:regex];
                    if (match) {
                        
                        NSRange group = [match rangeAtIndex:1];
                        NSString *link = [tag substringWithRange:group];
                        
                        [scanner scanUpToString:@"</a>" intoString:&body];
                        if (!body) {
                            [scanner scanUpToString:@"</A>" intoString:&body];
                        }
                        
                        if (body) {
                            
                            NSInteger htmlBodyLength = body.length;
                            body = [body stripHTMLTags];
                            
                            NSRange bodyRange = NSMakeRange(htmlOffset - plainOffset, body.length);
                            NSTextCheckingResult *linkMatch = [NSTextCheckingResult linkCheckingResultWithRange:bodyRange
                                                                                                            URL:[NSURL URLWithString:link]];
                            
                            [links addObject:linkMatch];
                            
                            // compensate for removing html tags in the A text between <a> and </a>
                            plainOffset += htmlBodyLength - body.length;
                            
                        }
                        
                        break;
                        
                    }
                    
                }
                
            }

        }
        
    }
    
    return (NSArray *)links;
    
}

- (NSString *)stripHTMLTags
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

- (NSString *)stringByReplacingFirstOccurrenceOfString:(NSString *)target withString:(NSString *)replacement
{
    NSString *ret = nil;
    NSRange loc = [self rangeOfString:target];
    if (NSNotFound != loc.location) {
        ret = [self stringByReplacingCharactersInRange:loc withString:replacement];
        
    } else {
        ret = [self copy];
        
    }
    
    return ret;
}

- (NSTextCheckingResult *)firstRegularExpressionMatch:(NSString *)regex
{
    NSString *delim = [regex substringToIndex:1];
    NSRange optionsRange = [regex rangeOfString:delim options:NSBackwardsSearch];
    NSString *pattern = [regex substringWithRange:NSMakeRange(1, optionsRange.location - 1)];
    NSString *options = [regex substringFromIndex:optionsRange.location + 1];
    NSRegularExpressionOptions regexOptions = 0;
    
    unichar optionsBuffer[options.length];
    [options getCharacters:optionsBuffer];
    
    for (NSInteger i = 0; i < options.length; i++) {
        unichar ch = optionsBuffer[i];
        //NSLog(@"%hu", ch);
        switch (ch) {
            case 'i':
                regexOptions |= NSRegularExpressionCaseInsensitive;
                break;
                
            default:
                NSAssert(NO, @"Unknown delimiter %hu", ch);
                break;
        }
    }
    
    NSError *error = nil;
    NSRegularExpression *trueRegex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:regexOptions
                                                                                 error:&error];

    NSTextCheckingResult *match = [trueRegex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return match;
    
}

- (nullable UIColor *)colorValue
{
    return [UIColor colorWithRGBString:self];
}

@end
