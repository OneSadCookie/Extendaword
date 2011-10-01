#import <QuartzCore/QuartzCore.h>
#import "EWCGColors.h"
#import "EWLayers.h"
#import "EWWordLayout.h"
#import "NSString+EWStringAdditions.h"

@implementation EWLayers

+ (CALayer *)gapLayer
{
    CALayer *layer = [CALayer layer];
    [layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setBackgroundColor:[EWCGColors pocketGreen]];
    [layer setBounds:CGRectMake(0.0, 0.0, TILE_WIDTH, TILE_HEIGHT)];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowColor:[EWCGColors highlightGreen]];
    [layer setShadowOpacity:0.75f];
    
    return layer;
}

+ (CATextLayer *)letterLayer:(NSString *)letter
{
    CATextLayer *layer = [CATextLayer layer];
    [layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    [layer setAlignmentMode:kCAAlignmentCenter];
    [layer setString:[[NSAttributedString alloc] initWithString:letter attributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont fontWithName:@"Ubuntu-Medium" size:42.0], NSFontAttributeName,
            [NSColor blackColor], NSForegroundColorAttributeName,
            nil]]];
    [layer setCornerRadius:CORNER_RADIUS];
    [layer setBackgroundColor:[EWCGColors beige]];
    [layer setBounds:CGRectMake(0.0, 0.0, TILE_WIDTH, TILE_HEIGHT)];
    [layer setShadowOffset:CGSizeMake(2, -2)];
    [layer setShadowColor:[EWCGColors black]];
    [layer setShadowOpacity:0.5f];
    
    return layer;
}

// [NSColor colorWithDeviceRed:0.87 green:0.86 blue:0.76 alpha:1.0]
+ (CATextLayer *)buttonLayer:(NSString *)label
{
    CATextLayer *layer = [CATextLayer layer];
    [layer setAlignmentMode:kCAAlignmentCenter];
    [layer setString:[[NSAttributedString alloc] initWithString:label attributes:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont fontWithName:@"Bangers" size:42.0], NSFontAttributeName,
            [NSColor yellowColor], NSForegroundColorAttributeName,
            nil]]];
    [layer setShadowOffset:CGSizeMake(0, 0)];
    [layer setShadowColor:[EWCGColors black]];
    [layer setShadowOpacity:0.75f];
    [layer setAffineTransform:CGAffineTransformMakeRotation(1.0 * M_PI / 24.0)];
    
    return layer;
}

+ (CATextLayer *)textLayer:(NSString *)label
{
    CATextLayer *textLayer = [CATextLayer layer];
    [textLayer setString:[[NSAttributedString alloc] initWithString:label attributes:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont fontWithName:@"Ubuntu-Medium" size:21.0], NSFontAttributeName,
            [NSColor whiteColor], NSForegroundColorAttributeName,
            nil]]];
    [textLayer setShadowOffset:CGSizeMake(0, 0)];
    [textLayer setShadowColor:[EWCGColors black]];
    [textLayer setShadowOpacity:0.75f];
    
    return textLayer;
}

+ (CALayer *)alphabetRowNamed:(NSString *)name start:(unichar)start end:(unichar)end
{
    CALayer *row = [CALayer layer];
    [row setName:name];
    [row setLayoutManager:[[EWWordLayout alloc] init]];
    for (unichar c = start; c <= end; ++c)
    {
        CALayer *letterLayer = [self letterLayer:[NSString stringWithCharacter:c]];
        [letterLayer setName:[NSString stringWithFormat:@"alpha%c", c]];
        [row addSublayer:letterLayer];
    }
    return row;
}

+ (CALayer *)alphabetPanel
{
    CALayer *panel = [CALayer layer];
    [panel setLayoutManager:[CAConstraintLayoutManager layoutManager]];
    
    CALayer *row0 = [self alphabetRowNamed:@"row0" start:'A' end:'J'];
    [row0 addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
    [row0 addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"row1" attribute:kCAConstraintMinY offset:TILE_HEIGHT + INTERTILE_GAP]];
    [panel addSublayer:row0];
    CALayer *row1 = [self alphabetRowNamed:@"row1" start:'K' end:'T'];
    [row1 addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
    [row1 addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
    [panel addSublayer:row1];
    CALayer *row2 = [self alphabetRowNamed:@"row2" start:'U' end:'Z'];
    [row2 addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
    [row2 addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"row1" attribute:kCAConstraintMinY offset:-(TILE_HEIGHT + INTERTILE_GAP)]];
    [panel addSublayer:row2];
    
    return panel;
}

@end
