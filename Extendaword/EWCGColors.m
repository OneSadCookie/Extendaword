#import "EWCGColors.h"

@implementation EWCGColors

static CGColorRef
    EWBlack,
    EWYellow,
    EWBeige,
    EWFeltGreen,
    EWPocketGreen,
    EWHighlightGreen;

+ (void)initialize
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        EWBlack = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0);
        EWYellow = CGColorCreateGenericRGB(1.0, 1.0, 0.0, 1.0);
        EWBeige = CGColorCreateGenericRGB(0.87, 0.86, 0.76, 1.0);
        EWFeltGreen = CGColorCreateGenericRGB(0.0, 0.15, 0.0, 1.0);
        EWPocketGreen = CGColorCreateGenericRGB(0.0, 0.125, 0.0, 1.0);
        EWHighlightGreen = CGColorCreateGenericRGB(0.0, 0.25, 0.0, 1.0);
    });
}

+ (CGColorRef)black
{
    return EWBlack;
}

+ (CGColorRef)yellow
{
    return EWYellow;
}

+ (CGColorRef)beige
{
    return EWBeige;
}

+ (CGColorRef)feltGreen
{
    return EWFeltGreen;
}

+ (CGColorRef)pocketGreen
{
    return EWPocketGreen;
}

+ (CGColorRef)highlightGreen
{
    return EWHighlightGreen;
}

@end
