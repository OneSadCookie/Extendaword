#import "EWMode.h"

@implementation EWMode

@synthesize delegate;

- (void)keyDown:(NSEvent *)event superlayer:(CALayer *)superlayer {}
- (void)keyUp:(NSEvent *)event superlayer:(CALayer *)superlayer {}

- (void)mouseDown:(NSEvent *)event superlayer:(CALayer *)superlayer {}
- (void)mouseDragged:(NSEvent *)event superlayer:(CALayer *)superlayer {}
- (void)mouseUp:(NSEvent *)event superlayer:(CALayer *)superlayer {}

- (void)addLayersTo:(CALayer *)layer {}

@end
