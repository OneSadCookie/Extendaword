#import <Foundation/Foundation.h>

@class EWDictionary;

typedef enum EWGameState
{
    EWWaitingOn1,
    EWWaitingOn2,
    EWGameOver,
}
EWGameState;

@interface EWGame : NSObject

- (id)initWithDictionary:(EWDictionary *)dictionary player1Name:(NSString *)player1Name player2Name:(NSString *)player2Name;

@property (readonly, strong) NSString    *letters;
@property (readonly)         EWGameState  gameState;
@property (readonly, strong) NSString    *lastMoveDescription;

// diagnosis after game over
@property (readonly)         NSString    *winner;
@property (readonly)         NSString    *suggestion;

- (void)challengeWord;
- (void)challengeNoWord;
- (void)addLetterToStart:(unichar)letter;
- (void)addLetterToEnd:(unichar)letter;

@end
