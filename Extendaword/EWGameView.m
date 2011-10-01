#import <QuartzCore/QuartzCore.h>
#import "EWCGColors.h"
#import "EWGameView.h"
#import "EWIntroMode.h"

@implementation EWGameView
{
    CALayer *backgroundLayer;
    EWMode  *mode;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        backgroundLayer = [CALayer layer];
        [backgroundLayer setOpaque:YES];
        [backgroundLayer setBackgroundColor:[EWCGColors feltGreen]];
        [backgroundLayer setLayoutManager:[CAConstraintLayoutManager layoutManager]];

        [self setLayer:backgroundLayer];
        [self setWantsLayer:YES];
        
        [self changeMode:[[EWIntroMode alloc] init]];
    }
    return self;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)keyDown:(NSEvent *)event
{
    [mode keyDown:event superlayer:backgroundLayer];
}

- (void)keyUp:(NSEvent *)event
{
    [mode keyUp:event superlayer:backgroundLayer];
}

- (void)mouseDown:(NSEvent *)event
{
    [mode mouseDown:event superlayer:backgroundLayer];
}

- (void)mouseDragged:(NSEvent *)event
{
    [mode mouseDragged:event superlayer:backgroundLayer];
}

- (void)mouseUp:(NSEvent *)event
{
    [mode mouseUp:event superlayer:backgroundLayer];
}

- (void)changeMode:(EWMode *)newMode
{
    for (CALayer *layer in [[backgroundLayer sublayers] copy])
    {
        [layer removeFromSuperlayer];
    }
    mode = newMode;
    [mode setDelegate:self];
    [mode addLayersTo:backgroundLayer];
}

@end
