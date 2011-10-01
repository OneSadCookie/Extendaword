#import <Foundation/Foundation.h>

#define EW_MAX_BAND      35
#define EW_AI_MIN_BAND   11
#define EW_AI_START_BAND 18

@class EWDictionary, EWGame;

@interface EWAI : NSObject

- (id)initWithMaxBand:(unsigned)maxBand dictionary:(EWDictionary *)dictionary;

- (void)makeMove:(EWGame *)game;

@end
