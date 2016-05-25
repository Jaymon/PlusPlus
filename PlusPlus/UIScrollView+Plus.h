//  Created by Jay Marcyes on 7/11/15.

@import UIKit;


@interface UIScrollView (Plus)

/**
 *  returns the touch location of the scroll
 *  search string: "get the touch coordinates from scrollview"
 */
@property (nonatomic, readonly) CGPoint touchPoint;

/**
 *  returns the percentage of the screen of this scroll
 */
@property (nonatomic, readonly) CGFloat percentage;

/**
 *  allows us to box a percentage move of the scrollview to a certain size
 *
 *  you would use this when doing an animation that might finish halfway through the scroll,
 *  so, for instance, if you wanted the animation to move quicker than the scrollview until
 *  the scrollview has gone 50% of the distance, you could call this with max=0.5 and stopOffset
 *  set to it's maximum movement
 *
 *  @param   offset  what is the maximum offset you want to have
 *  @param   max the maximum percentage you want between 0 and 1.0 normally, 1.2 would be 120%
 *  @return  the percentage of the current offset of offset
 */
- (CGFloat)percentageToOffset:(CGFloat)stopOffset toMaxPercent:(CGFloat)max;

/**
 *  if you only want move between a certain start and stopping point, then you can use this
 *
 *  this will figure out the scrollview's current movement between startOffset and stopOffset and
 *  return the percentage it has moved between startOffset and stopOffset, handy for animations
 *
 *  @param   startOffset  the starting point to figure out how far the scrollview has moved
 *  @param   stopOffset  what is the maximum stopping offset you want to check
 *  @param   max the maximum percentage you want between 0 and 1.0 normally, 1.2 would be 120%
 *  @return  the percentage of the current offset of offset
 */
- (CGFloat)percentageBetweenOffset:(CGFloat)startOffset toOffset:(CGFloat)stopOffset toMaxPercent:(CGFloat)max;

//- (CGFloat)percentageOfOffset:(CGFloat)stopOffset startingFromOffset:(CGFloat)startOffset toMaxPercent:(CGFloat)max;

@end
