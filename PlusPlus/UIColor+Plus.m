//  Created by Jay Marcyes on 7/11/15.

#import "UIColor+Plus.h"


@implementation UIColor (Plus)

- (CGFloat)red
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)green
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)blue
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)alpha
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return a;
}

- (instancetype)colorBetween:(CGFloat)percentage toColor:(UIColor *)color
{
    // 1 is the FROM color, 2 is the DESTINATION color
    
    // FROM
    CGFloat red1, green1, blue1, alpha1;
    [self getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    // http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
    CGFloat brightness1 = ((red1 * 299.0) + (green1 * 587.0) + (blue1 * 114.0)) / 1000.0;
    
    // TO
    CGFloat red2, green2, blue2, alpha2;
    [color getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    CGFloat brightness2 = ((red2 * 299.0) + (green2 * 587.0) + (blue2 * 114.0)) / 1000.0;
    
    CGFloat red3, green3, blue3;
    if (brightness1 > brightness2) {
        
        red3 = red2 + (fabs(red1 - red2) * (1.0 - percentage));
        green3 = green2 + (fabs(green1 - green2) * (1.0 - percentage));
        blue3 = blue2 + (fabs(blue1 - blue2) * (1.0 - percentage));
        
    } else {
        
        red3 = red1 + (fabs(red2 - red1) * percentage);
        green3 = green1 + (fabs(green2 - green1) * percentage);
        blue3 = blue1 + (fabs(blue2 - blue1) * percentage);
        
    }
    
    UIColor *color3 = [UIColor colorWithRed:red3 green:green3 blue:blue3 alpha:1.0];
    return color3;
}

+ (instancetype)colorWithRGBa:(int)red, ...
{
    va_list gba;
    va_start(gba, red);
    
    CGFloat green = va_arg(gba, int);
    CGFloat blue = va_arg(gba, int);
    CGFloat alpha = va_arg(gba, double); // in order to be a float/double, it has to be passed in with decimal (eg, 0.5)
    va_end(gba);

    UIColor *color = [UIColor colorWithRed:(((CGFloat)red)/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
    return color;
}

+ (instancetype)colorWithRGB:(int)red, ...
{
    va_list gba;
    va_start(gba, red);
    int green = va_arg(gba, int);
    int blue = va_arg(gba, int);
    va_end(gba);
    
    return [self colorWithRGBa:red, green, blue, 1.0];
}

+ (instancetype)colorWithHex:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
            
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
            
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
            
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
            
        default:
            [NSException raise:@"Invalid color" format: @"Invalid color %@. valid forms: #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

@end
