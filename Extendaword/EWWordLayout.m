#import <QuartzCore/QuartzCore.h>
#import "EWLayers.h"
#import "EWWordLayout.h"

@implementation EWWordLayout

- (CGSize)preferredSizeOfLayer:(CALayer *)layer
{
    size_t layerCount = [[layer sublayers] count];
    CGFloat totalWidth = layerCount * TILE_WIDTH + (layerCount - 1) * INTERTILE_GAP;
    // NSLog(@"totalWidth = %f for %zu layers", totalWidth, [[layer sublayers] count]);
    return CGSizeMake(totalWidth, TILE_HEIGHT);
}

- (void)invalidateLayoutOfLayer:(CALayer *)layer
{}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    //NSLog(@"laying out %zu sublayers", [[layer sublayers] count]);
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    for (CALayer *sublayer in [layer sublayers])
    {
        //NSLog(@"putting %@ (%@) at (%f, %f)", sublayer, [sublayer isKindOfClass:[CATextLayer class]] ? [[(CATextLayer *)sublayer string] string] : @"/* not a text layer */", x, y);
        [sublayer setPosition:CGPointMake(x, y)];
        x += TILE_WIDTH + INTERTILE_GAP;
    }
}

@end
