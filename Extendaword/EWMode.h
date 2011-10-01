#import <Foundation/Foundation.h>

@class CALayer;

@interface EWMode : NSObject

@property (readwrite, assign) id delegate;

- (void)keyDown:(NSEvent *)event superlayer:(CALayer *)superlayer;
- (void)keyUp:(NSEvent *)event superlayer:(CALayer *)superlayer;

- (void)mouseDown:(NSEvent *)event superlayer:(CALayer *)superlayer;
- (void)mouseDragged:(NSEvent *)event superlayer:(CALayer *)superlayer;
- (void)mouseUp:(NSEvent *)event superlayer:(CALayer *)superlayer;

- (void)addLayersTo:(CALayer *)layer;

@end

@interface NSObject (EWModeDelegate)

- (void)changeMode:(EWMode *)newMode;

@end
