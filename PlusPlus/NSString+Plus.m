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
    NSString *regex = @"/\r\n|\n|\r(?!\n)/";
    return [[regex regularExpressionValue] numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
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
    
    // http://stackoverflow.com/questions/2606134/
    while ([scanner isAtEnd] == NO) {
        
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&tag];
        
        if (tag) {
            
            tagLengthCount += tag.length + 1;
            scanner.scanLocation += [scanner isAtEnd] ? 0 : 1; // move passed closing >
            
            plainStartOffset = scanner.scanLocation - tagLengthCount;
            
            NSLog(@"tag %@ with location %lu", tag, scanner.scanLocation);
            
            ///NSTextCheckingResult *match = [tag firstRegularExpressionMatch:@"/^<a\\s+/i"];
            NSTextCheckingResult *match = [tag firstRegularExpressionMatch:@"(?i)^<a\\s+"];
            if (match) {
                
                NSArray *regexes = @[@"(?i)href=\"([^\"]+)",
                                     @"(?i)href='([^']+)",
                                     @"(?i)href=([^\\s>]+)"];
                
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
                            
                            NSLog(@"body %@ with location %lu", body, scanner.scanLocation);
                            
                            ///tagLengthCount += body.length;
                            
                            NSString *htmlSub = [self substringToIndex:plainStartOffset + tagLengthCount];
                            NSString *plainSub = [plainText substringToIndex:plainStartOffset];
                            NSInteger diffLength = plainSub.length - (htmlSub.length - tagLengthCount);
                            NSLog(@"diffLength: %lu, plain %lu, html %lu", diffLength, plainSub.length, htmlSub.length);
                            NSLog(@"htmlSub %@, plainSub %@", htmlSub, plainSub);
                            
                            
                            NSString *plainBody = [body stripHTMLTags];
                            tagLengthCount += body.length - plainBody.length;
                            plainStopOffset = scanner.scanLocation - tagLengthCount;
//
//                            NSInteger htmlBodyLength = body.length;
//                            body = [body stripHTMLTags];
//
//                            NSInteger htmlOffsetLinebreakCount = [[self substringToIndex:htmlOffset] linebreakCount];
//                            NSInteger htmlLengthLinebreakCount = [[self substringWithRange:NSMakeRange(htmlOffset, htmlBodyLength)] linebreakCount];
//                            
//                            NSInteger plainOffsetLinebreakCount = [[plainText substringToIndex:plainOffset] linebreakCount];
//                            NSInteger plainLengthLinebreakCount = [[plainText substringWithRange:NSMakeRange(plainOffset, body.length)] linebreakCount];
//                            
//                            NSInteger linebreakOffsetCount = plainOffsetLinebreakCount - htmlOffsetLinebreakCount;
//                            NSInteger linebreakLengthCount = plainLengthLinebreakCount - htmlLengthLinebreakCount;
//                            
                            NSRange bodyRange = NSMakeRange(plainStartOffset, plainStopOffset - plainStartOffset);
                            NSTextCheckingResult *linkMatch = [NSTextCheckingResult linkCheckingResultWithRange:bodyRange
                                                                                                            URL:[NSURL URLWithString:link]];
                            
                            [links addObject:linkMatch];
                            
                            // compensate for removing html tags in the A text between <a> and </a>
                            ///plainOffset += (htmlBodyLength - body.length) + linebreakOffsetCount + linebreakLengthCount;
                            
                        }
                        
                        break;
                        
                    }
                    
                }
                
            }

        } else {
            // TODO: update plain offset?
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
    return [UIColor colorWithRGBString:self];
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
