//  Created by Jay Marcyes on 7/11/15.

@import UIKit;


@interface UIScrollView (Plus)

/**
 *  returns the touch location of the scroll
 *  search string: "get the touch coordinates from scrollview"
 */
@property (nonatomic, readonly) CGPoint touchPoint;

/**
 * returns the percentage of the screen of this scroll
 */
@property (nonatomic, readonly) CGFloat percentage;

/**
 * allows us to box a percentage move of the scrollview to a certain size
 *
 * @param   offset  what is the maximum offset you want to have
 * @param   max the maximum percentage you want between 0 and 1.0 normally, 1.2 would be 120%
 * @return  the percentage of the current offset of offset
 */
- (CGFloat)percentageToOffset:(CGFloat)stopOffset toMaxPercent:(CGFloat)max;

- (CGFloat)percentageBetweenOffset:(CGFloat)startOffset toOffset:(CGFloat)stopOffset toMaxPercent:(CGFloat)max;

//- (CGFloat)percentageOfOffset:(CGFloat)stopOffset startingFromOffset:(CGFloat)startOffset toMaxPercent:(CGFloat)max;

@end
