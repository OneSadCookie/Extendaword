#import "EWDictionary.h"
#import "EWGame.h"
#import "NSString+EWStringAdditions.h"

@interface EWGame ()

@property (readwrite, strong) NSString    *letters;
@property (readwrite)         EWGameState  gameState;
@property (readwrite, strong) NSString    *lastMoveDescription;

@end

@implementation EWGame
{
    EWDictionary *dict;
    NSString     *player1Name;
    NSString     *player2Name;
    
    NSString     *letters;
    EWGameState   gameState;
    
    NSString     *previouslyValidState;
    
    NSString     *winner;
    NSString     *suggestion;
    
    NSString     *lastMoveDescription;
}

- (id)initWithDictionary:(EWDictionary *)dictionary player1Name:(NSString *)player1 player2Name:(NSString *)player2;
{
    self = [super init];
    if (self)
    {
        dict = dictionary;
        player1Name = player1;
        player2Name = player2;
        letters = [NSString stringWithCharacter:arc4random_uniform(26) + 'a'];
        previouslyValidState = letters;
        gameState = EWWaitingOn1;
        self.lastMoveDescription = [NSString stringWithFormat:@"Game begins with “%@”.", letters];
    }
    return self;
}

@synthesize letters;
@synthesize gameState;
@synthesize lastMoveDescription;

@synthesize winner;
@synthesize suggestion;

- (void)challengeWord
{
    assert(self.gameState == EWWaitingOn1 || self.gameState == EWWaitingOn2);
    if ([dict isWord:letters])
    {
        winner = gameState == EWWaitingOn1 ? player1Name : player2Name;
        // TODO suggest a not-a-word from previous state
        suggestion = @"";
        self.lastMoveDescription = [NSString stringWithFormat:@"%@ correctly says “%@” is a word.", winner, letters];
    }
    else
    {
        winner = gameState == EWWaitingOn1 ? player2Name : player1Name;
        suggestion = @"";
        self.lastMoveDescription = [NSString stringWithFormat:@"%@ incorrectly says “%@” is a word.", gameState == EWWaitingOn1 ? player1Name : player2Name, letters];
    }
    self.gameState = EWGameOver;
}

- (void)challengeNoWord
{
    assert(self.gameState == EWWaitingOn1 || self.gameState == EWWaitingOn2);
    NSString *superset = [dict wordContaining:letters];
    if (!superset)
    {
        winner = gameState == EWWaitingOn1 ? player1Name : player2Name;
        suggestion = [NSString stringWithFormat:@"“%@” contained ”%@”", [dict wordContaining:previouslyValidState], previouslyValidState];
        self.lastMoveDescription = [NSString stringWithFormat:@"%@ correctly says “%@” cannot become a word.", winner, letters];
    }
    else
    {
        winner = gameState == EWWaitingOn1 ? player2Name : player1Name;
        suggestion = @"";
        self.lastMoveDescription = [NSString stringWithFormat:@"%@ incorrectly says “%@” cannot become a word; it could become “%@”.", gameState == EWWaitingOn1 ? player1Name : player2Name, letters, superset];
    }
    self.gameState = EWGameOver;
}

- (void)addLetterToStart:(unichar)letter
{
    assert(self.gameState == EWWaitingOn1 || self.gameState == EWWaitingOn2);
    NSString *newLetters = [NSString stringWithFormat:@"%c%@", letter, self.letters];
    if ([dict wordContaining:newLetters]) previouslyValidState = newLetters;
    self.letters = newLetters;
    self.lastMoveDescription = [NSString stringWithFormat:@"%@ adds “%c” to the start.", gameState == EWWaitingOn1 ? player1Name : player2Name, letter];
    self.gameState = self.gameState == EWWaitingOn1 ? EWWaitingOn2 : EWWaitingOn1;
}

- (void)addLetterToEnd:(unichar)letter
{
    assert(self.gameState == EWWaitingOn1 || self.gameState == EWWaitingOn2);
    NSString *newLetters = [NSString stringWithFormat:@"%@%c", self.letters, letter];
    if ([dict wordContaining:newLetters]) previouslyValidState = newLetters;
    self.letters = newLetters;
    self.lastMoveDescription = [NSString stringWithFormat:@"%@ adds “%c” to the end.", gameState == EWWaitingOn1 ? player1Name : player2Name, letter];
    self.gameState = self.gameState == EWWaitingOn1 ? EWWaitingOn2 : EWWaitingOn1;
}

@end
