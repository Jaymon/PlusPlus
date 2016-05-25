//  Created by Jay Marcyes on 7/11/15.
//
// some refs:
//  http://arstechnica.com/apple/2009/02/iphone-development-accessing-uicolor-components/
//  http://stackoverflow.com/a/11599453/5006

@import Foundation;


@interface UIColor (Plus)

@property (nonatomic, readonly) CGFloat red;

@property (nonatomic, readonly) CGFloat green;

@property (nonatomic, readonly) CGFloat blue;

@property (nonatomic, readonly) CGFloat alpha;

///- (UIColor *)colorWithPercentage:(CGFloat)percentage;


/**
 *  this will create a color that is percentage betwen self and the passed in color
 *
 *  @param  percentage  the percent (between 0.0-1.0) you want between self and color
 *  @param  color   the final color you are shooting for
 *
 *  @return the color that sits percentage between self and color
 */
- (instancetype)colorBetween:(CGFloat)percentage toColor:(UIColor *)color;

/**
 *  just makes it easier to create a color
 *
 *  @see https://developer.apple.com/library/mac/qa/qa1405/_index.html
 *  @see http://www.cprogramming.com/tutorial/c/lesson17.html
 *  @param values R, G, B, a with R, G, B as integers between 0-255, and a float between 0.0-1.0 (eg 140, 140, 139, 0.5)
 *
 *  @return UIColor instance
 */
+ (instancetype)colorWithRGBa:(int) values, ...;
+ (instancetype)colorWithRGB:(int) values, ...;

/**
 *  Convert a string Hex color into a UIColor reference.
 *
 *  @code
 *  - #AARRGGBB
 *  - #ARGB
 *  - #RRGGBB
 *  - #RGB
 *  @endcode
 *
 *  An alpha of 1.0 is assumed if not provided.
 *
 *  @see http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
 *
 *  @param hexString A string representing a hex color.
 *
 *  @return A valid UIColor reference if the string provided was properly formatted
 */
+ (instancetype)colorWithHex:(NSString *)hexString;


@end
