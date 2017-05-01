//  Created by Jay Marcyes on 5/01/2017.

#import "UIApplication+Plus.h"
#import <stdatomic.h> // http://en.cppreference.com/w/c/atomic


@implementation UIApplication (Plus)

/**
 this holds the total number of open network connections (basically how many times
 startNetworkActivity has been called without a corresponding stopNetworkActivity)
 */
static volatile _Atomic(int) activeNetworkConnectionsCount;

- (void)startNetworkActivity
{
    // returns previous value instead of new value :(
    atomic_fetch_add_explicit(&activeNetworkConnectionsCount, 1, memory_order_relaxed);
    self.networkActivityIndicatorVisible = atomic_load_explicit(&activeNetworkConnectionsCount, memory_order_relaxed) > 0;
    ///NSLog(@"%i - %i", activeNetworkConnectionsCount, self.networkActivityIndicatorVisible);
}

- (void)stopNetworkActivity
{
    // returns previous value instead of new value :(
    atomic_fetch_sub_explicit(&activeNetworkConnectionsCount, 1, memory_order_relaxed);
    self.networkActivityIndicatorVisible = atomic_load_explicit(&activeNetworkConnectionsCount, memory_order_relaxed) > 0;
    ///NSLog(@"%i - %i", activeNetworkConnectionsCount, self.networkActivityIndicatorVisible);
}

- (void)clearNetworkActivity
{
    atomic_exchange_explicit(&activeNetworkConnectionsCount, 0, memory_order_relaxed);
    self.networkActivityIndicatorVisible = atomic_load_explicit(&activeNetworkConnectionsCount, memory_order_relaxed) > 0;
}

@end
