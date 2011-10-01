#import <Carbon/Carbon.h>
#import <QuartzCore/QuartzCore.h>
#import "EWEndGameMode.h"
#import "EWGame.h"
#import "EWGameMode.h"
#import "EWLayers.h"
#import "EWWordLayout.h"
#import "NSString+EWStringAdditions.h"

@implementation EWEndGameMode
{
    unsigned aiBand;

    CALayer *wordLayer;
    CATextLayer *lastMoveDescriptionLayer;
    CATextLayer *suggestionLayer;
    CATextLayer *winnerLayer;
    CALayer *button;
    
    CALayer *pressed;
}

- (id)initWithGame:(EWGame *)game nextAIBand:(unsigned)band
{
    self = [super init];
    if (self)
    {
        aiBand = band;
    
        wordLayer = [CALayer layer];
        [wordLayer setLayoutManager:[[EWWordLayout alloc] init]];
        [wordLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [wordLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintHeight  scale:0.67 offset:0.0]];
        NSString *letters = [game letters];
        size_t n = [letters length];
        for (size_t i = 0; i < n; ++i)
        {
            [wordLayer addSublayer:[EWLayers letterLayer:[NSString stringWithCharacter:toupper([letters characterAtIndex:i])]]];
        }
        
        lastMoveDescriptionLayer = [EWLayers textLayer:[game lastMoveDescription]];
        [lastMoveDescriptionLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [lastMoveDescriptionLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.85 offset:0.0]];
        
        suggestionLayer = [EWLayers textLayer:[game suggestion]];
        [suggestionLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [suggestionLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.45 offset:0.0]];

        winnerLayer = [EWLayers textLayer:[NSString stringWithFormat:@"%@ wins!", [game winner]]];
        [winnerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [winnerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.35 offset:0.0]];
        
        button = [EWLayers buttonLayer:@"Play Again! "];
        [button setName:@"play"];
        [button addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintWidth scale:0.9 offset:0.0]];
        [button addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.1 offset:0.0]];
    }
    
    return self;
}

- (void)play
{
    [[self delegate] changeMode:[[EWGameMode alloc] initWithAIBand:aiBand]];
    // now self is dealloc'd !!!  don't touch us !!!
}

- (void)keyDown:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    if ([event keyCode] == kVK_Return)
    {
        [self play];
        // now self is dealloc'd !!!  don't touch us !!!
    }
}

- (void)mouseDown:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    pressed = [superlayer hitTest:[event locationInWindow]];
}

- (void)mouseDragged:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    
}

- (void)mouseUp:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    CALayer *released = [superlayer hitTest:[event locationInWindow]];
    if (pressed == released)
    {
        [self play];
        // now self is dealloc'd !!!  don't touch us !!!
    }
    else
    {
        pressed = nil;
    }
}

- (void)addLayersTo:(CALayer *)layer
{
    [layer addSublayer:wordLayer];
    [layer addSublayer:lastMoveDescriptionLayer];
    [layer addSublayer:suggestionLayer];
    [layer addSublayer:winnerLayer];
    [layer addSublayer:button];
}

@end
