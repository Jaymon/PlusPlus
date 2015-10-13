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
 *  this will create a color that is a cross betwen self and the passed in color
 *
 *  @param  percentage  the percent (between 0.0-1.0) you want between self and color
 *  @param  color   the final color you are shooting for
 *
 *  @return the color that sits percentage between self and color
 */
- (UIColor *)colorBetween:(CGFloat)percentage toColor:(UIColor *)color;

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

@end
