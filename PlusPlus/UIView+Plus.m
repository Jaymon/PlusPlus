//  Created by Jay Marcyes on 7/21/15.

#import "UIView+Plus.h"


@implementation UIView (Plus)

- (CGPoint)point
{
    return self.frame.origin;
}

- (void)setPoint:(CGPoint)point
{
    CGRect frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    self.frame = frame;
}

- (NSLayoutConstraint *)leftContstraint
{
    // http://rypress.com/tutorials/objective-c/data-types/nsset
    NSSet *left = [NSSet setWithArray:@[@(NSLayoutAttributeLeft),
                                        @(NSLayoutAttributeLeftMargin),
                                        @(NSLayoutAttributeLeading),
                                        @(NSLayoutAttributeLeadingMargin)]];
    
    NSSet *right = [NSSet setWithArray:@[@(NSLayoutAttributeRight),
                                         @(NSLayoutAttributeRightMargin),
                                         @(NSLayoutAttributeTrailing),
                                         @(NSLayoutAttributeTrailingMargin)]];
    
    return [self constraintWithFirstAttributes:left orSecondAttributes:right];
}

- (NSLayoutConstraint *)rightContstraint
{
    // http://rypress.com/tutorials/objective-c/data-types/nsset
    NSSet *right = [NSSet setWithArray:@[@(NSLayoutAttributeLeft),
                                        @(NSLayoutAttributeLeftMargin),
                                        @(NSLayoutAttributeLeading),
                                        @(NSLayoutAttributeLeadingMargin)]];
    
    NSSet *left = [NSSet setWithArray:@[@(NSLayoutAttributeRight),
                                         @(NSLayoutAttributeRightMargin),
                                         @(NSLayoutAttributeTrailing),
                                         @(NSLayoutAttributeTrailingMargin)]];
    
    return [self constraintWithFirstAttributes:left orSecondAttributes:right];
}

- (NSLayoutConstraint *)bottomContstraint
{
    NSSet *bottom = [NSSet setWithArray:@[@(NSLayoutAttributeBottom), @(NSLayoutAttributeBottomMargin)]];
    return [self constraintWithFirstAttributes:bottom orSecondAttributes:bottom];
}

- (NSLayoutConstraint *)topContstraint
{
    NSSet *top = [NSSet setWithArray:@[@(NSLayoutAttributeTop), @(NSLayoutAttributeTopMargin)]];
    return [self constraintWithFirstAttributes:top orSecondAttributes:top];
}

- (NSLayoutConstraint *)constraintWithFirstAttributes:(NSSet *)first orSecondAttributes:(NSSet *)second
{
    NSLayoutConstraint *constraint = nil;
    NSArray *constraints = self.superview.constraints;
    if (constraints) {
        
        for (NSLayoutConstraint *c in constraints) {
            
            if (c.firstItem == self) {
                
                if ([first containsObject:@(c.firstAttribute)]) {
                    
                    constraint = c;
                    break;
                }
                
            } else if (c.secondItem == self) {
                
                if ([second containsObject:@(c.secondAttribute)]) {
                    constraint = c;
                    break;
                }
                
            }
            
        }
        
    }
    
    return constraint;
}


- (void)fadeOut:(NSTimeInterval)duration completion:(void(^)())completion
{
    [UIView animateWithDuration:duration animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        if (finished && completion) {
            completion();
        }
        
    }];
}

- (void)fadeIn:(NSTimeInterval)duration completion:(void(^)())completion
{
    [UIView animateWithDuration:duration animations:^{
        
        self.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        if (finished && completion) {
            completion();
        }
        
    }];
}

- (UIView *)findSubviewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    UIView *v = nil;
    for (UIView *view in self.subviews) {
        if ([view.accessibilityIdentifier isEqual:accessibilityIdentifier]) {
            v = (UIView *)view;
            break;
        }
    }
    
    return v;
}

@end
