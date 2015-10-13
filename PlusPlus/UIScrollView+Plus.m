//  Created by Jay Marcyes on 7/11/15.

#import "UIScrollView+Plus.h"

#import "UIScreen+Plus.h"
#include <math.h>


@implementation UIScrollView (Plus)

- (CGPoint)touchPoint
{
    // http://stackoverflow.com/a/17345611/5006
    CGPoint location = [self.panGestureRecognizer locationInView:self];
    return location;
}

- (CGFloat)percentage
{
    CGFloat start = 0.0;
    CGFloat stop = 0.0;
    
    if (self.contentOffset.x == 0.0) {
        start = fabs(self.contentOffset.y);
        stop = [UIScreen height];
        
    } else if (self.contentOffset.y == 0.0) {
        start = fabs(self.contentOffset.x);
        stop = [UIScreen width];
        
    }
    
    // page view controllers can actually double the width or height (eg, they will
    // go from 320 to 640), so we need to normalize the values a bit
    return fabs(start - stop) / stop;
}

- (CGFloat)percentageBetweenOffset:(CGFloat)startOffset toOffset:(CGFloat)stopOffset toMaxPercent:(CGFloat)max;
{
    CGFloat percentage = 0.0;
    CGFloat currentOffset = 0.0;
    
    if (self.contentOffset.x == 0.0) {
        currentOffset = fabs(self.contentOffset.y);
        
    } else if (self.contentOffset.y == 0.0) {
        currentOffset = fabs(self.contentOffset.x);
        
    }
    
    if (currentOffset > startOffset) {
        CGFloat start = currentOffset - startOffset;
        CGFloat stop = stopOffset - startOffset;
        percentage = fminf(start / stop, max);
    }
    
    return percentage;
}

- (CGFloat)percentageToOffset:(CGFloat)stopOffset toMaxPercent:(CGFloat)max
{
    return [self percentageBetweenOffset:0.0 toOffset:stopOffset toMaxPercent:1.0];
}

@end
