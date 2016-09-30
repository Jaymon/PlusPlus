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
    ///return [UIScreen mainScreen].frame.size.height;
    return [[self class] mainScreen].frame.size.height;
}

+ (CGFloat)width
{
    ///return [UIScreen mainScreen].frame.size.width;
    return [[self class] mainScreen].frame.size.width;
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

+ (CGSize)pixelResolution
{
    CGFloat scaleFactor = [[self class] mainScreen].scale;
    CGSize size = [[self class] resolution];
    return CGSizeMake(size.width * scaleFactor, size.height * scaleFactor);
}

+ (CGSize)resolutionThreeFiveInch
{
    return CGSizeMake(320.0, 480.0);
}

+ (CGSize)resolutionFourInch
{
    return CGSizeMake(320.0, 568.0);
}

+ (CGSize)resolutionFourSevenInch
{
    return CGSizeMake(375.0, 667.0);
}

+ (CGSize)resolutionFiveFiveInch
{
    return CGSizeMake(414.0, 736.0);
}

+ (CGSize)resolutionSevenNineInch
{
    return CGSizeMake(768.0, 1024.0);
}

+ (CGSize)resolutionNineSevenInch
{
    return CGSizeMake(768.0, 1024.0);
}

+ (CGSize)resolutionTwelveNineInch
{
    return CGSizeMake(1024.0, 1366.0);
}

+ (CGSize)iPhone4Resolution
{
    return [[self class] resolutionThreeFiveInch];
}

+ (CGSize)iPhone5Resolution
{
    return [[self class] resolutionFourInch];
}
+ (CGSize)iPhoneSEResolution
{
    return [[self class] iPhone5Resolution];
}

+ (CGSize)iPhone6Resolution;
{
    return [[self class] resolutionFourSevenInch];
}
+ (CGSize)iPhone7Resolution
{
    return [[self class] iPhone6Resolution];
}

+ (CGSize)iPhone6PlusResolution
{
    return [[self class] resolutionFiveFiveInch];
}
+ (CGSize)iPhone7PlusResolution
{
    return [[self class] iPhone6PlusResolution];
}

+ (CGSize)iPadMiniResolution
{
    return [[self class] resolutionSevenNineInch];
}

+ (CGSize)iPadResolution
{
    return [[self class] resolutionNineSevenInch];
}

+ (CGSize)iPadProResolution
{
    return [[self class] resolutionTwelveNineInch];
}

@end
