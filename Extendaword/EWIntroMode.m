#import <Carbon/Carbon.h>
#import <QuartzCore/QuartzCore.h>
#import "EWAI.h"
#import "EWGameMode.h"
#import "EWIntroMode.h"
#import "EWLayers.h"

static NSString * const EWRulesText =
    @"• Take turns adding a letter to the beginning or the end.\n"
     "\n"
     "• You must make part of a word.\n"
     "\n"
     "• You must not make a whole word.\n"
     "\n"
     "• If your opponent breaks the rules, challenge!";

@implementation EWIntroMode
{
    CATextLayer *textLayer;
    CATextLayer *button;
    
    CALayer *pressed;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        textLayer = [EWLayers textLayer:EWRulesText];
        [textLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintWidth scale:0.1 offset:0.0]];
        [textLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
        
        button = [EWLayers buttonLayer:@"Play! "];
        [button setName:@"play"];
        [button addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintWidth scale:0.9 offset:0.0]];
        [button addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.1 offset:0.0]];
    }
    
    return self;
}

- (void)play
{
    [[self delegate] changeMode:[[EWGameMode alloc] initWithAIBand:EW_AI_START_BAND]];
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
    [layer addSublayer:textLayer];
    [layer addSublayer:button];
}

@end
