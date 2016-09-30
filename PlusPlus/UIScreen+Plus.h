//  Created by Jay Marcyes on 5/27/15.

@import UIKit;


@interface UIScreen (Plus)

@property (nonatomic, readonly) CGRect frame;

/**
 *  the height of the current screen
 *
 *  @return height of current device
 */
+ (CGFloat)height;

/**
 *  the width of the current screen
 *
 *  @return width of current device
 */
+ (CGFloat)width;

/**
 *  the center point of the current device screen
 *
 *  @return x, y
 */
+ (CGPoint)center;

/**
 *  the native resolution for the current device
 *
 *  @return cgsize of the height and the width of the current phone's screen
 */
+ (CGSize)resolution;

/**
 return the resolution not in points but in pixels

 @link  http://stackoverflow.com/questions/14003955/getting-the-screen-resolution-in-iphone
 @return cgsize of the height and width
 */
+ (CGSize)pixelResolution;

+ (CGSize)resolutionThreeFiveInch;
+ (CGSize)resolutionFourInch;
+ (CGSize)resolutionFourSevenInch;
+ (CGSize)resolutionFiveFiveInch;
+ (CGSize)resolutionSevenNineInch;
+ (CGSize)resolutionNineSevenInch;
+ (CGSize)resolutionTwelveNineInch;

/**
 *  the iPhone 4 device resolution
 *
 *  @see http://www.iosres.com/
 *
 *  @return device's width and height in CGSize
 */
+ (CGSize)iPhone4Resolution;

/**
 *  the iPhone 5 device resolution
 *
 *  @see https://coronalabs.com/blog/2014/10/23/the-point-of-resolution-independence-ios-and-iphone-6-plus/
 *
 *  @return device's width and height in CGSize
 */
+ (CGSize)iPhone5Resolution;
+ (CGSize)iPhoneSEResolution;

/**
 *  the iPhone 6 device resolution
 *
 *  @see http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
 *
 *  @return device's width and height in CGSize
 */
+ (CGSize)iPhone6Resolution;
+ (CGSize)iPhone7Resolution;

/**
 *  the iPhone 6+ device resolution
 *
 *  @return device's width and height in CGSize
 */
+ (CGSize)iPhone6PlusResolution;
+ (CGSize)iPhone7PlusResolution;

/**
 *  the iPad Mini device resolution
 *
 *  @return device's width and height in CGSize
 */
+ (CGSize)iPadMiniResolution;

/**
 *  the full size iPad device resolution
 *
 *  @return device's width and height in CGSize
 */
+ (CGSize)iPadResolution;

/**
 *  the 12.9" size iPad device resolution
 *
 *  @return device's width and height in CGSize
 */
+ (CGSize)iPadProResolution;

@end
