#import <Foundation/Foundation.h>

#define TILE_WIDTH 44.0
#define TILE_HEIGHT 50.0
#define INTERTILE_GAP 6.0
#define CORNER_RADIUS 8.0

@class CATextLayer;

@interface EWLayers : NSObject

+ (CALayer *)gapLayer;
+ (CATextLayer *)letterLayer:(NSString *)letter;
+ (CATextLayer *)buttonLayer:(NSString *)label;
+ (CATextLayer *)textLayer:(NSString *)label;

+ (CALayer *)alphabetPanel;

@end
