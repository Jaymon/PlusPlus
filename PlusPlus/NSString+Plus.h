//  Created by Jay Marcyes on 8/11/15.

@import Foundation;

@interface NSString (Plus)

/**
 *  YES if the string is a link that begins with http
 */
@property (nonatomic, readonly) BOOL isHTTPLink;

/**
 *  returns an array of the links found in the href attribute of the string's HTML <a> tags
 *
 *  what is a little strange is this will return those URLs with a range for the string that
 *  assumes the string is plain text, an example will illustrate
 *
 *  @example
 *      NSString *html = @"<a href="http://example.com">foo</a>";
 *      NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
 *      NSLog(@"url will be http://example.com %@", links[0].url);
 *      NSLog(@"range will be {0, 3} %@", links[0].range);
 *      NSLog(@"text will be foo %@", [html substringWithRange:links[0].range]);
 *
 *  @return a list of NSTextCheckingResult instances with .range and .url set
 */
- (nonnull NSArray <NSTextCheckingResult *> *)linksFromHTMLWithPlainTextRanges;

/**
 *  removes all HTML tags from the string
 */
- (nonnull NSString *)stripHTMLTags;

/**
 *  this only replaces the first occurence of a string instead of every occurence in the entire
 *  string.
 *
 *  @link   http://stackoverflow.com/a/25156178/5006
 *
 *  @param  target  the first substring of this value will be replaced
 *  @param  replacement the string that will replace the first occurence of target
 *  @return the string with the first occurence of target replaced, or just the string if no occurences of target were found
 */
- (nonnull NSString *)stringByReplacingFirstOccurrenceOfString:(nonnull NSString *)target withString:(nonnull NSString *)replacement;

/**
 *  find the first match of the given regular expression, this is a little different
 *  than a traditional regex in that it uses grep/sed/awk/perl/php's regex syntax with
 *  delimiters, so ignore case foo would be /foo/i
 *
 *  @param regex the delimited regex, currently only i (ignore case) is supported
 *
 *  @return the match that will let you get the grouping ranges and pull them from the string
 */
- (nullable NSTextCheckingResult *)firstRegularExpressionMatch:(nonnull NSString *)regex;

/**
 *  if the string contains something like #RRGGBB then it will return a UIColor instance
 *
 *  @return a UIColor instance that contains the color of the RGB string value
 */
- (nullable UIColor *)colorValue;

@end
