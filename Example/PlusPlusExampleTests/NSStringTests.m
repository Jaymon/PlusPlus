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
    
    NSString *regex = @"bar";
    NSTextCheckingResult *match = [str firstRegularExpressionMatch:regex];
    NSString *matchedStr = [str substringWithRange:[match rangeAtIndex:0]];
    XCTAssertEqualObjects(@"bar", matchedStr);
    
    regex = @"(?i)bar";
    str = @"foo BAR che";
    match = [str firstRegularExpressionMatch:regex];
    matchedStr = [str substringWithRange:[match rangeAtIndex:0]];
    XCTAssertEqualObjects(@"BAR", matchedStr);
    
    regex = @"bar";
    str = @"foo che";
    match = [str firstRegularExpressionMatch:regex];
    XCTAssertEqualObjects(nil, match);
    
}

- (void)testNonHttpLinksFromHTML
{
    NSString *html = @"<a href=\"/foo/bar\">foo</a>";
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, links.count);
    XCTAssertEqualObjects(@"/foo/bar", [links[0].URL absoluteString]);
    
    html = @"<a href=\"#anchor\">foo</a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, links.count);
    XCTAssertEqualObjects(@"#anchor", [links[0].URL absoluteString]);
    
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

- (void)testAltLinkSyntaxFromHTML
{
    NSString *html = @"<a href='http://1.com'>1</a>";
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, [links count]);
    XCTAssertEqualObjects(@"http://1.com", [links[0].URL absoluteString]);
    
    html = @"<a href=http://2.com class=\"something\">2</a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, [links count]);
    XCTAssertEqualObjects(@"http://2.com", [links[0].URL absoluteString]);
    
    html = @"<a href=http://3.com>3</a>";
    links = [html linksFromHTMLWithPlainTextRanges];
    XCTAssertEqual(1, [links count]);
    XCTAssertEqualObjects(@"http://3.com", [links[0].URL absoluteString]);
    
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
    XCTAssertEqual(1, links.count);
    XCTAssert([[plain substringWithRange:links[0].range] isEqualToString:@"foo"]);

}

/**
 *  so it turns out that copying html in iOS will keep newlines in the plaintext version
 *  of the paste but strip all the newlines in the html version, so that has to be
 *  accounted for :(
 */
- (void)testPastedLinks {
    ///NSString *html = @"<!DOCTYPE html><p style=\"box-sizing: border-box; margin: 0px 0px 1.5em; font-family: Balto, Helvetica, Arial, 'Nimbus Sans L', sans-serif; font-weight: normal; font-size: 1.3em; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; color: rgb(76, 78, 77); font-style: normal; font-variant-caps: normal; letter-spacing: normal; orphans: auto; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-tap-highlight-color: rgba(26, 26, 26, 0.301961); -webkit-text-size-adjust: 100%; -webkit-text-stroke-width: 0px;\">It's really hard to overstate how screwed Marco Rubio is.</p><p style=\"box-sizing: border-box; margin: 0px 0px 1.5em; font-family: Balto, Helvetica, Arial, 'Nimbus Sans L', sans-serif; font-weight: normal; font-size: 1.3em; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; color: rgb(76, 78, 77); font-style: normal; font-variant-caps: normal; letter-spacing: normal; orphans: auto; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: auto; word-spacing: 0px; -webkit-tap-highlight-color: rgba(26, 26, 26, 0.301961); -webkit-text-size-adjust: 100%; -webkit-text-stroke-width: 0px;\">I'm not even talking about<span class=\"Apple-converted-space\"> </span><a href=\"http://www.vox.com/2016/3/15/11242326/marco-rubio-drop-out\" style=\"box-sizing: border-box; image-rendering: optimizequality; transition: all 100ms ease; -webkit-transition: all 100ms ease; text-decoration: none; color: rgb(79, 113, 119); font-weight: 700; -webkit-font-smoothing: antialiased; background-image: none !important; font-size: 1em !important; background-position: initial initial !important; background-repeat: initial initial !important;\">his failed presidential campaign</a>. That's over, his humiliation is complete. But he also has no political career to speak of after this. He's retiring from his Senate seat, and while he could<span class=\"Apple-converted-space\"> </span><em style=\"box-sizing: border-box;\">theoretically</em><span class=\"Apple-converted-space\"> </span>jump back in that race, two GOP congress members and Florida's lieutenant governor are already running, making a late entry awkward to say the least.</p>";
    
    ///NSString *text = @"It's really hard to overstate how screwed Marco Rubio is.\n\nI'm not even talking about his failed presidential campaign. That's over, his humiliation is complete. But he also has no political career to speak of after this. He's retiring from his Senate seat, and while he could theoretically jump back in that race, two GOP congress members and Florida's lieutenant governor are already running, making a late entry awkward to say the least.";
    
    
    ///NSString *html = @"foo <a href=\".\">bar</a>";
    ///NSString *text = @"foo bar";
    
    ///NSString *html = @"<a href=\"http://foo.com/\">foo</a> and <a href=\"http://bar.com/\">bar</a>";
    ///NSString *text = @"foo and bar";
    
    ///NSString *html = @"<p>foo bar</p><p>che <a href=\".\">baz</a> and boom</p>";
    ///NSString *text = @"foo bar\r\n\r\nche baz and boom\r\n";
    
    ///NSString *html = @"<p>foo bar</p> <p>che <a href=\".\">baz</a> and boom</p>";
    ///NSString *text = @"foo bar che baz and boom";
    
    NSString *html = @"<!DOCTYPE html><p>It's really hard to overstate how screwed Marco Rubio is.</p><p>I'm not even talking about<span class=\"Apple-converted-space\"> </span><a href=\"http://www.vox.com/2016/3/15/11242326/marco-rubio-drop-out\">his failed presidential campaign</a>. That's over, his humiliation is complete. But he also has no political career to speak of after this. He's retiring from his Senate seat, and while he could<span class=\"Apple-converted-space\"> </span><em>theoretically</em><span class=\"Apple-converted-space\"> </span>jump back in that race, two GOP congress members and Florida's lieutenant governor are already running, making a late entry awkward to say the least.</p>";

    NSString *text = @"It's really hard to overstate how screwed Marco Rubio is.\n\nI'm not even talking about his failed presidential campaign. That's over, his humiliation is complete. But he also has no political career to speak of after this. He's retiring from his Senate seat, and while he could theoretically jump back in that race, two GOP congress members and Florida's lieutenant governor are already running, making a late entry awkward to say the least.";
    
    NSArray <NSTextCheckingResult *> *links = [html linksFromHTMLWithRangesFor:text];
    NSLog(@"%@", links);
    NSLog(@"%@", [text substringWithRange:links[0].range]);
    ///NSLog(@"%@", [text substringWithRange:links[1].range]);
    
}

@end
