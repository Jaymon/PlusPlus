//  Created by Jay Marcyes on 5/27/15.

#import "UIScreen+Plus.h"


@implementation UIScreen (Plus)

- (CGRect)frame
{
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    CGRect originalFrame = [self bounds];
    CGRect adjustedFrame = [rootView convertRect:originalFrame fromView:nil];
    return adjustedFrame;
}

+ (CGFloat)height
{
    return [UIScreen mainScreen].frame.size.height;
}

+ (CGFloat)width
{
    return [UIScreen mainScreen].frame.size.width;
}

+ (CGPoint)center
{
    CGFloat height = [self height];
    CGFloat width = [self width];
    return CGPointMake(width / 2.0, height / 2.0);
}

+ (CGSize)resolution
{
    return CGSizeMake([self width], [self height]);
}

+ (CGSize)iPhone4Resolution
{
    return CGSizeMake(320.0, 480.0);
}

+ (CGSize)iPhone5Resolution
{
    return CGSizeMake(320.0, 568.0);
}

+ (CGSize)iPhone6Resolution;
{
    return CGSizeMake(375.0, 667.0);
}

+ (CGSize)iPhone6PlusResolution
{
    return CGSizeMake(414.0, 736.0);
}

+ (CGSize)iPadMiniResolution
{
    return CGSizeMake(768.0, 1024.0);
}

+ (CGSize)iPadResolution
{
    return CGSizeMake(768.0, 1024.0);
}

@end
