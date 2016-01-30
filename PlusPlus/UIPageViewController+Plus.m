//  Created by Jay Marcyes on 1/28/16.

#import "UIPageViewController+Plus.h"
@import ObjectiveC.runtime;


@implementation UIPageViewController (Plus)

- (UIScrollView *)scrollView
{
    UIScrollView *_scrollView = objc_getAssociatedObject(self, "_scrollView");
    if (!_scrollView) {
        // thanks to Kyle for giving me the idea on how to get trixy to figure
        // out how far the view has scrolled
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView *)view;
                objc_setAssociatedObject(self, "_scrollView", _scrollView, OBJC_ASSOCIATION_ASSIGN);
                break;
            }
        }
    }
    
    return _scrollView;
}

@end
