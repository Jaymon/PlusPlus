//  Created by Jay Marcyes on 8/11/15.

#import "NSString+Plus.h"
#import "UIColor+Plus.h"


@implementation NSString (Plus)

- (BOOL)isHTTPLink
{
    return [self.lowercaseString hasPrefix:@"http"];
}

- (NSUInteger)linebreakCount
{
    // other way: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/TextLayout/Tasks/CountLines.html
    NSString *regex = @"\r\n|\n|\r(?!\n)";
    return [[regex regularExpressionValue] numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

- (bool)anySuffix:(NSArray<NSString *> *)suffixes
{
    bool hasSuffix = NO;
    for (NSString *suffix in suffixes) {
        if ([self hasSuffix:suffix]) {
            hasSuffix = YES;
            break;
        }
    }
    return hasSuffix;
}

- (bool)any:(NSArray<NSString *> *)strings
{
    bool has = NO;
    for (NSString *s in strings) {
        if ([self isEqualToString:s]) {
            has = YES;
            break;
        }
    }
    return has;
}


// #############################################################################
#pragma mark html
// #############################################################################

- (NSArray <NSTextCheckingResult *> *)linksFromHTMLWithPlainTextRanges {
    return [self linksFromHTMLWithRangesFor:[self stripHTMLTags]];
}

- (nonnull NSArray <NSTextCheckingResult *> *)linksFromHTMLWithRangesFor:(nonnull NSString *)plainText;
{
    NSMutableArray <NSTextCheckingResult *> *links = [NSMutableArray new];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSString *tag = nil;
    NSString *body = nil;
    NSInteger plainStartOffset = 0;
    NSInteger plainStopOffset = 0;
    NSUInteger tagLengthCount = 0; // holds how many chars total of html is in a tag, between < and >
    NSString *plainHtml = [self stripHTMLTags];
    NSInteger rangeBuffer = plainText.length - plainHtml.length;
    NSArray *linkRegexes = @[@"(?i)href=\"([^\"]+)",
                         @"(?i)href='([^']+)",
                         @"(?i)href=([^\\s>]+)"];
    
    // http://stackoverflow.com/questions/2606134/
    while ([scanner isAtEnd] == NO) {
        
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&tag];
        
        if (tag) {
            
            tagLengthCount += tag.length + 1;
            scanner.scanLocation += [scanner isAtEnd] ? 0 : 1; // move passed closing >
            
            ///NSTextCheckingResult *match = [tag firstRegularExpressionMatch:@"/^<a\\s+/i"];
            NSTextCheckingResult *match = [tag firstRegularExpressionMatch:@"(?i)^<a\\s+"];
            if (match) {
                
                for (NSString *regex in linkRegexes) {
                    
                    match = [tag firstRegularExpressionMatch:regex];
                    if (match) {
            
                        plainStartOffset = scanner.scanLocation - tagLengthCount;
                        NSRange group = [match rangeAtIndex:1];
                        NSString *link = [tag substringWithRange:group];
                        
                        [scanner scanUpToString:@"</a>" intoString:&body];
                        if (!body) {
                            [scanner scanUpToString:@"</A>" intoString:&body];
                        }
                        
                        if (body) {
                            
                            NSString *plainHtmlBody = [body stripHTMLTags];
                            tagLengthCount += body.length - plainHtmlBody.length; // account for non <a> tags between the <a>'s
                            
                            plainStopOffset = scanner.scanLocation - tagLengthCount;
                            NSUInteger plainLength = plainStopOffset - plainStartOffset;
                            
                            NSUInteger location = plainStartOffset - rangeBuffer;
                            // we want to check a range of buffer on either side
                            NSRange range = NSMakeRange(location,
                                                  MIN(plainHtmlBody.length + (rangeBuffer << 2), plainText.length - location));
                            NSString *plainTextBody = [plainText substringWithRange:range];
                            NSRange actualRange = [plainTextBody rangeOfString:plainHtmlBody];
                            if (actualRange.location != NSNotFound) {
                                
                                plainStartOffset -= rangeBuffer;
                                plainStartOffset += actualRange.location;
                                plainLength = actualRange.length;
                                
                            }
                            
                            NSRange bodyRange = NSMakeRange(plainStartOffset, plainLength);
                            NSTextCheckingResult *linkMatch = [NSTextCheckingResult linkCheckingResultWithRange:bodyRange
                                                                                                            URL:[NSURL URLWithString:link]];
                            
                            [links addObject:linkMatch];
                            
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


// #############################################################################
#pragma mark color
// #############################################################################

- (nullable UIColor *)colorValue
{
    return [UIColor colorWithHex:self];
}


// #############################################################################
#pragma mark regex
// #############################################################################

- (NSTextCheckingResult *)firstRegularExpressionMatch:(NSString *)regex
{
    NSTextCheckingResult *match = [[regex regularExpressionValue] firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return match;
}

- (nullable NSRegularExpression *)regularExpressionValue
{
    NSRegularExpressionOptions regexOptions = 0;
    NSError *error = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:self
                                                                               options:regexOptions
                                                                                 error:&error];
    
    return regexp;
    
}

//- (nullable NSRegularExpression *)regularExpressionValue
//{
//    NSString *delim = [self substringToIndex:1];
//    NSRange optionsRange = [self rangeOfString:delim options:NSBackwardsSearch];
//    NSString *pattern = [self substringWithRange:NSMakeRange(1, optionsRange.location - 1)];
//    NSString *options = [self substringFromIndex:optionsRange.location + 1];
//    NSRegularExpressionOptions regexOptions = 0;
//    
//    unichar optionsBuffer[options.length];
//    [options getCharacters:optionsBuffer];
//    
//    for (NSInteger i = 0; i < options.length; i++) {
//        unichar ch = optionsBuffer[i];
//        //NSLog(@"%hu", ch);
//        switch (ch) {
//            case 'i':
//                regexOptions |= NSRegularExpressionCaseInsensitive;
//                break;
//                
//            default:
//                NSAssert(NO, @"Unknown delimiter %hu", ch);
//                break;
//        }
//    }
//    
//    NSError *error = nil;
//    NSRegularExpression *trueRegex = [NSRegularExpression regularExpressionWithPattern:pattern
//                                                                               options:regexOptions
//                                                                                 error:&error];
//    
//    return trueRegex;
//
//}

@end
