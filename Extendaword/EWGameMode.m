#import <Carbon/Carbon.h>
#import <QuartzCore/QuartzCore.h>
#import "EWAI.h"
#import "EWCGColors.h"
#import "EWDictionary.h"
#import "EWEndGameMode.h"
#import "EWGame.h"
#import "EWGameMode.h"
#import "EWLayers.h"
#import "EWWordLayout.h"
#import "NSArray+EWArrayAdditions.h"
#import "NSString+EWStringAdditions.h"

@implementation EWGameMode
{
    EWDictionary *dict;
    EWAI         *ai;
    unsigned      aiBand;
    EWGame       *game;
    
    CALayer *alphabetPanel;
    CALayer *wordLayer;
    CALayer *gapLayers[2];
    CATextLayer *lastMoveDescriptionLayer;
    NSArray *letterLayers;
    CALayer *challengeWord;
    CALayer *challengeNoWord;
    
    CALayer *pressedLayer;
    int tick;
    int target;
}

- (void)positionAlphabetPanelOnscreen
{
    [alphabetPanel setConstraints:[NSArray array]];
    [alphabetPanel addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
    [alphabetPanel addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.33 offset:0.0]];
}

- (void)positionAlphabetPanelOffscreen
{
    [alphabetPanel setConstraints:[NSArray array]];
    [alphabetPanel addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
    [alphabetPanel addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMinY offset:-384.0]];
}

- (void)startGame
{
    [game removeObserver:self forKeyPath:@"letters"];
    [game removeObserver:self forKeyPath:@"gameState"];
    [game removeObserver:self forKeyPath:@"lastMoveDescription"];
    game = [[EWGame alloc] initWithDictionary:dict player1Name:@"Human" player2Name:@"Mac"];
    [game addObserver:self forKeyPath:@"letters" options:NSKeyValueObservingOptionInitial context:NULL];
    [game addObserver:self forKeyPath:@"gameState" options:NSKeyValueObservingOptionInitial context:NULL];
    [game addObserver:self forKeyPath:@"lastMoveDescription" options:NSKeyValueObservingOptionInitial context:NULL];
    ai = [[EWAI alloc] initWithMaxBand:aiBand dictionary:dict];
}

- (id)initWithAIBand:(unsigned)band
{
    self = [super init];
    if (self)
    {
        dict = [[EWDictionary alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"English" withExtension:@"sqlite3"]];
        if (!dict) return nil;
        aiBand = band;
    
        wordLayer = [CALayer layer];
        [wordLayer setLayoutManager:[[EWWordLayout alloc] init]];
        [wordLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [wordLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintHeight  scale:0.67 offset:0.0]];
        
        gapLayers[0] = [EWLayers gapLayer];
        [gapLayers[0] setName:@"gap0"];
        gapLayers[1] = [EWLayers gapLayer];
        [gapLayers[1] setName:@"gap1"];
        
        [wordLayer addSublayer:gapLayers[0]];
        [wordLayer addSublayer:gapLayers[1]];
        
        challengeWord = [EWLayers buttonLayer:@"Hey!\nThat's a word! "];
        [challengeWord setName:@"challengeWord"];
        [challengeWord setPosition:CGPointMake(50, 50)];
        [challengeWord addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintWidth scale:0.25 offset:0.0]];
        [challengeWord addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.33 offset:0.0]];
        
        challengeNoWord = [EWLayers buttonLayer:@"There's no word \nlike that!"];
        [challengeNoWord setName:@"challengeNoWord"];
        [challengeNoWord setPosition:CGPointMake(200, 50)];
        [challengeNoWord addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintWidth scale:0.75 offset:0.0]];
        [challengeNoWord addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.33 offset:0.0]];
        
        lastMoveDescriptionLayer = [EWLayers textLayer:@""];
        [lastMoveDescriptionLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [lastMoveDescriptionLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:0.85 offset:0.0]];
        
        alphabetPanel = [EWLayers alphabetPanel];
        [self positionAlphabetPanelOffscreen];
        
        [self startGame];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)updateLetterTiles
{
    [gapLayers[0] removeFromSuperlayer];
    [gapLayers[1] removeFromSuperlayer];
    for (CALayer *l in letterLayers)
    {
        [l removeFromSuperlayer];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    size_t j = 0;
    for (size_t i = 0; i < [[game letters] length]; ++i)
    {
        NSString *letterString = [NSString stringWithCharacter:toupper([[game letters] characterAtIndex:i])];
        if (j < [letterLayers count] && [[[(CATextLayer *)[letterLayers objectAtIndex:j] string] string] isEqualToString:letterString])
        {
            [array addObject:[letterLayers objectAtIndex:j]];
            ++j;
        }
        else
        {
            [array addObject:[EWLayers letterLayer:letterString]];
        }
    }
    letterLayers = array;
    
    [wordLayer addSublayer:gapLayers[0]];
    for (CALayer *l in letterLayers)
    {
        [wordLayer addSublayer:l];
    }
    [wordLayer addSublayer:gapLayers[1]];
    
    [wordLayer layoutIfNeeded];
}

- (void)checkGameOver
{
    if ([game gameState] == EWGameOver)
    {
        if ([game winner])
        {
            aiBand = MAX(aiBand - 1, EW_AI_MIN_BAND);
        }
        else
        {
            aiBand = MIN(aiBand + 1, EW_MAX_BAND);
        }
    
        [[self delegate] changeMode:[[EWEndGameMode alloc] initWithGame:game nextAIBand:aiBand]];
        // now self is dealloc'd !!!  don't touch us !!!
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    assert(object == game);
    
    if ([keyPath isEqualToString:@"letters"])
    {
        [self updateLetterTiles];
    }
    else if ([keyPath isEqualToString:@"gameState"])
    {
        [self checkGameOver];
    }
    else if ([keyPath isEqualToString:@"lastMoveDescription"])
    {
        [lastMoveDescriptionLayer setString:[[NSAttributedString alloc] initWithString:[game lastMoveDescription] attributes:
            [NSDictionary dictionaryWithObjectsAndKeys:
                [NSFont fontWithName:@"Ubuntu-Medium" size:21.0], NSFontAttributeName,
                [NSColor whiteColor], NSForegroundColorAttributeName,
                nil]]];
    }
    else
    {
        abort();
    }
}

- (void)targetLeft
{
    target = -1;
    [gapLayers[0] setBackgroundColor:[EWCGColors highlightGreen]];
    [self positionAlphabetPanelOnscreen];
}

- (void)targetRight
{
    target = 1;
    [gapLayers[1] setBackgroundColor:[EWCGColors highlightGreen]];
    [self positionAlphabetPanelOnscreen];
}

- (void)aiMove
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ai makeMove:game];
    });
}

- (void)addLetter:(unichar)c
{
    if ([game gameState] == EWWaitingOn1)
    {
        if (target == -1)
        {
            [game addLetterToStart:tolower(c)];
            [self aiMove];
        }
        else if (target == 1)
        {
            [game addLetterToEnd:tolower(c)];
            [self aiMove];
        }
    }
    target = 0;
    [gapLayers[0] setBackgroundColor:[EWCGColors pocketGreen]];
    [gapLayers[1] setBackgroundColor:[EWCGColors pocketGreen]];
    [self positionAlphabetPanelOffscreen];
}

- (void)challengeWord
{
    if ([game gameState] == EWWaitingOn1)
    {
        [game challengeWord];
    }
}

- (void)challengeNoWord
{
    if ([game gameState] == EWWaitingOn1)
    {
        [game challengeNoWord];
    }
}

- (void)layerClicked:(CALayer *)layer
{
    NSString *name = [layer name];
    if ([name isEqualToString:@"gap0"])
    {
        [self targetLeft];
    }
    else if ([name isEqualToString:@"gap1"])
    {
        [self targetRight];
    }
    else if ([name isEqualToString:@"challengeWord"])
    {
        [self challengeWord];
    }
    else if ([name isEqualToString:@"challengeNoWord"])
    {
        [self challengeNoWord];
    }
    else if ([name length] >= 6 && [[name substringToIndex:5] isEqualToString:@"alpha"])
    {
        [self addLetter:[name characterAtIndex:5]];
    }
}

- (void)keyDown:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    unsigned keyCode = [event keyCode];
    if (keyCode == kVK_LeftArrow)
    {
        [self targetLeft];
    }
    else if (keyCode == kVK_RightArrow)
    {
        [self targetRight];
    }
    else
    {
        NSString *s = [event charactersIgnoringModifiers];
        unichar c = [s characterAtIndex:0];
        if (isalpha(c))
        {
            [self addLetter:c];
        }
    }
}

- (void)keyUp:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    
}

- (void)mouseDown:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    pressedLayer = [superlayer hitTest:[event locationInWindow]];
}

- (void)mouseDragged:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    
}

- (void)mouseUp:(NSEvent *)event superlayer:(CALayer *)superlayer
{
    CALayer *upLayer = [superlayer hitTest:[event locationInWindow]];
    if (pressedLayer == upLayer)
    {
        [self layerClicked:upLayer];
    }
    pressedLayer = nil;
}

- (void)addLayersTo:(CALayer *)layer
{
    [layer addSublayer:wordLayer];
    [layer addSublayer:challengeWord];
    [layer addSublayer:challengeNoWord];
    [layer addSublayer:lastMoveDescriptionLayer];
    [layer addSublayer:alphabetPanel];
}

- (void)tick:(id)object
{
    [CATransaction setAnimationDuration:1.0];

    if (target == -1 && tick % 2)
    {
        [gapLayers[0] setBackgroundColor:[EWCGColors highlightGreen]];
    }
    else
    {
        [gapLayers[0] setBackgroundColor:[EWCGColors pocketGreen]];
    }

    if (target == 1 && tick % 2)
    {
        [gapLayers[1] setBackgroundColor:[EWCGColors highlightGreen]];
    }
    else
    {
        [gapLayers[1] setBackgroundColor:[EWCGColors pocketGreen]];
    }
    
    ++tick;
}

@end
