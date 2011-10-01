#import "EWMode.h"

@class EWGame;

@interface EWEndGameMode : EWMode

- (id)initWithGame:(EWGame *)game nextAIBand:(unsigned)band;

@end
