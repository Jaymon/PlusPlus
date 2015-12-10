//  Created by Jay Marcyes on 8/12/15.

@import UIKit;
@import XCTest;
#import "NSString+Plus.h"


@interface NSStringTests : XCTestCase

@end


@implementation NSStringTests

- (void)testFirstRegularExpressionMatch
{
    NSString *str = @"foo bar che";
    
    NSString *regex = @"/bar/";
    NSTextCheckingResult *match = [str firstRegularExpressionMatch:regex];
    NSString *matchedStr = [str substringWithRange:[match rangeAtIndex:0]];
    XCTAssertEqualObjects(@"bar", matchedStr);
    
    regex = @"/bar/i";
    str = @"foo BAR che";
    match = [str firstRegularExpressionMatch:regex];
    matchedStr = [str substringWithRange:[match rangeAtIndex:0]];
    XCTAssertEqualObjects(@"BAR", matchedStr);
    
    regex = @"/bar/";
    str = @"foo che";
    match = [str firstRegularExpressionMatch:regex];
    XCTAssertEqualObjects(nil, match);
    
}

- (void)testLinksFromHTMLMultiLinksUnicode
{
    NSString *html = @"несколько <a href=\"http://1.com\">знать</a> 𠸎 <a href=\"http://2.com\">𠻺</a> 𠾼";
    NSString *plain = [html stripHTMLTags];
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(2, [links count]);
    XCTAssertEqualObjects(@"знать", [plain substringWithRange:links[0].range]);
    XCTAssertEqualObjects(@"http://1.com", [links[0].URL absoluteString]);
    
    XCTAssertEqualObjects(@"𠻺", [plain substringWithRange:links[1].range]);
    XCTAssertEqualObjects(@"http://2.com", [links[1].URL absoluteString]);
    
}

- (void)testLinksFromHTMLMultiLinks
{
    NSString *html = @"prefix <a href=\"http://foo.com\">foo</a> and <a href=\"http://bar.com\">bar</a> suffix";
    NSString *plain = [html stripHTMLTags];
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(2, [links count]);
    XCTAssertEqualObjects(@"foo", [plain substringWithRange:links[0].range]);
    XCTAssertEqualObjects(@"http://foo.com", [links[0].URL absoluteString]);
    
    XCTAssertEqualObjects(@"bar", [plain substringWithRange:links[1].range]);
    XCTAssertEqualObjects(@"http://bar.com", [links[1].URL absoluteString]);
    
    html = @"prefix <a href=\"http://foo.com\">foo</a> and <a href=\"http://bar.com\">bar</a> with <a href=\"http://1.x\">1</a>";
    plain = [html stripHTMLTags];
    links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(3, [links count]);
    XCTAssertEqualObjects(@"1", [plain substringWithRange:links[2].range]);
    XCTAssertEqualObjects(@"http://1.x", [links[2].URL absoluteString]);
    
}

- (void)testLinksFromHTMLPrefix
{
    NSString *html = @"prefix <a href=\"http://example.com\">foo</a>";
    NSString *plain = [html stripHTMLTags];
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, [links count]);
    XCTAssertEqualObjects(@"foo", [plain substringWithRange:links[0].range]);
    XCTAssertEqualObjects(@"http://example.com", [links[0].URL absoluteString]);
    
}

- (void)testLinksFromHTMLOneLinkNoTagsinAText
{
    NSString *html = @"<a href=\"http://example.com\">foo</a>";
    NSString *plain = [html stripHTMLTags];
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, [links count]);
    XCTAssertEqualObjects(@"foo", [plain substringWithRange:links[0].range]);
    XCTAssertEqualObjects(@"http://example.com", [links[0].URL absoluteString]);
    
}

- (void)testLinksFromHTMLOneLinkTagsinAText
{
    NSString *html = @"<a href=\"http://example.com\">foo <b>bar</b> che</a>";
    NSString *plain = [html stripHTMLTags];
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, [links count]);
    XCTAssertEqualObjects(@"foo bar che", [plain substringWithRange:links[0].range]);
    XCTAssertEqualObjects(@"http://example.com", [links[0].URL absoluteString]);
    
}

- (void)testLinksFromHTML {
    
    NSString *html = @"<a href=\"http://venturebeat.com/2011/03/09/stumbleupon-funding/\" style=\"box-sizing: border-box; background-color: transparent; color: rgb(68, 121, 189); text-decoration: none;\">funding round</a>— $17 million";
    
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(links.count, 1);
    
    html = @"<a href=\"http://foo.com/\">foo</a> and <a href=\"http://bar.com/\">bar</a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    NSString *plain = [html stripHTMLTags];
    XCTAssertEqual(links.count, 2);
    XCTAssert([[plain substringWithRange:links[0].range] isEqualToString:@"foo"]);
    XCTAssert([[plain substringWithRange:links[1].range] isEqualToString:@"bar"]);
    
    html = @"<a href=\"http://foo.com/\">some more <i>tags</i></a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    plain = [html stripHTMLTags];
    XCTAssertEqual(links.count, 1);
    XCTAssert([[plain substringWithRange:links[0].range] isEqualToString:@"some more tags"]);
    
    html = @"<a HREF=\"http://foo.com/\">foo</a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    plain = [html stripHTMLTags];
    XCTAssert([[plain substringWithRange:links[0].range] isEqualToString:@"foo"]);
    
    html = @"<A HREF=\"http://foo.com/\">foo</A>";
    links = [html linksFromHTMLWithPlainTextRanges];
    plain = [html stripHTMLTags];
    XCTAssert([[plain substringWithRange:links[0].range] isEqualToString:@"foo"]);
    
    html = @"<A HREF=\"http://foo.com/\">foo</a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    plain = [html stripHTMLTags];
    XCTAssert([[plain substringWithRange:links[0].range] isEqualToString:@"foo"]);
    
    html = @"<a HREF=\"http://foo.com/\">foo</A>";
    links = [html linksFromHTMLWithPlainTextRanges];
    plain = [html stripHTMLTags];
    XCTAssert([[plain substringWithRange:links[0].range] isEqualToString:@"foo"]);
    
    html = @"<a href=http://foo.com/>foo</a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    plain = [html stripHTMLTags];
    XCTAssertEqual(links.count, 0);

}

@end
