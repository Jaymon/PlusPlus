//  Created by Jay Marcyes on 5/1/17.

@import XCTest;
#import "UIApplication+Plus.h"


@interface UIApplicationTests : XCTestCase

@end

@implementation UIApplicationTests

- (void)testNetworkActivity {
    
    XCTAssertFalse([UIApplication sharedApplication].networkActivityIndicatorVisible);
    
    [[UIApplication sharedApplication] startNetworkActivity];
    [[UIApplication sharedApplication] startNetworkActivity];
 
    XCTestExpectation *expectation = [self expectationWithDescription:@"Network Indicator increment worked"];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) {
        
        ///NSLog(@"1");
        
        [[UIApplication sharedApplication] stopNetworkActivity];
        
        XCTAssertTrue([UIApplication sharedApplication].networkActivityIndicatorVisible);
        
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) {

            ///NSLog(@"2");
            XCTAssertTrue([UIApplication sharedApplication].networkActivityIndicatorVisible);
            
            [[UIApplication sharedApplication] stopNetworkActivity];
            
            [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) {
            
                ///NSLog(@"3");
                XCTAssertFalse([UIApplication sharedApplication].networkActivityIndicatorVisible);
                [expectation fulfill];
                
            }];
            
        }];
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {}];
    
    XCTAssertFalse([UIApplication sharedApplication].networkActivityIndicatorVisible);
}

- (void)testClearNetworkActivity {
    
    [[UIApplication sharedApplication] startNetworkActivity];
    [[UIApplication sharedApplication] startNetworkActivity];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Network Indicator increment worked"];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) {
        
        XCTAssertTrue([UIApplication sharedApplication].networkActivityIndicatorVisible);
        [[UIApplication sharedApplication] clearNetworkActivity];
        [expectation fulfill];
        
    }];
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {}];

    XCTAssertFalse([UIApplication sharedApplication].networkActivityIndicatorVisible);
    
}

@end
