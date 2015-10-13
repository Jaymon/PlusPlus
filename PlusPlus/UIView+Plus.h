//  Created by Jay Marcyes on 7/21/15.

@import UIKit;


@interface UIView (Plus)

/**
 * setting this will position this view at the given point
 */
@property (nonatomic) CGPoint point;

@property (nonatomic, strong, readonly) NSLayoutConstraint *leftContstraint;
@property (nonatomic, strong, readonly) NSLayoutConstraint *bottomContstraint;
@property (nonatomic, strong, readonly) NSLayoutConstraint *topContstraint;

/**
 *  fade out the view in duration, and then run completion when done fading out
 */
- (void)fadeOut:(NSTimeInterval)duration completion:(void(^)())completion;

- (void)fadeIn:(NSTimeInterval)duration completion:(void(^)())completion;

- (UIView *)findSubviewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;

@end
