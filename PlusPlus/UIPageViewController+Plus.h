//  Created by Jay Marcyes on 1/28/16.

@import UIKit;


@interface UIPageViewController (Plus)

/**
 *  return the internal scrollview for the pageVC, this isn't technically private
 *  but you have to check each subview to find it, but you often want to set a
 *  delegate on it to do more advanced animations and this makes it easier to do
 *  that
 */
@property (nonatomic, readonly) UIScrollView *scrollView;

@end
