#import "EWAI.h"
#import "EWDictionary.h"
#import "EWGame.h"
#import "NSArray+EWArrayAdditions.h"

@implementation EWAI
{
    unsigned      band;
    EWDictionary *dict;
}

- (id)initWithMaxBand:(unsigned)maxBand dictionary:(EWDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        band = maxBand;
        dict = dictionary;
    }
    
    return self;
}

- (BOOL)shouldRecognizeWordInBand:(unsigned)b
{
    if (b < band) return YES;
    float chance = 1.0f / (b - band);
    //NSLog(@"chance to recognize word in band %u for AI at %u is %f", b, band, chance);
    if (((double)arc4random() / (double)0xffffffff) < chance) return YES;
    //NSLog(@"AI at %u not recognizing word at %u (chance was %f)", band, b, chance);
    return NO;
}

- (void)makeMove:(EWGame *)game
{
    NSString *letters = [game letters];
    unsigned b;
    if ([dict isWord:letters band:&b] && [self shouldRecognizeWordInBand:b])
    {
        dispatch_async(dispatch_get_main_queue(), ^{ [game challengeWord]; });
        return;
    }
    __block BOOL shouldChallenge = YES;
    [dict eachWordContaining:letters block:^(BOOL *done, unsigned b, NSString *word) {
        if ([self shouldRecognizeWordInBand:b])
        {
            shouldChallenge = NO;
        }
        *done = YES;
    }];
    if (shouldChallenge)
    {
        dispatch_async(dispatch_get_main_queue(), ^{ [game challengeNoWord]; });
        return;
    }
    
    NSMutableArray *words = [NSMutableArray array];
    [dict eachWordContaining:letters block:^(BOOL *done, unsigned int b, NSString *word) {
        if ([self shouldRecognizeWordInBand:b])
        {
            [words addObject:word];
        }
    }];
    
    //NSLog(@"%@ ----------", letters);
    NSMutableArray *options = [NSMutableArray array];
    for (id word in words)
    {
        //NSLog(@"looking at %@", word);
        NSRange r = [word rangeOfString:letters];
        if (r.location > 0)
        {
            NSString *candidate = [word substringWithRange:NSMakeRange(r.location - 1, r.length + 1)];
            //NSLog(@"before: %@", candidate);
            if (![dict isWord:candidate])
            {
                //NSLog(@"adding %@", candidate);
                [options addObject:candidate];
            }
        }
        if (r.location + r.length < [word length])
        {
            NSString *candidate = [word substringWithRange:NSMakeRange(r.location, r.length + 1)];
            //NSLog(@"after: %@", candidate);
            if (![dict isWord:candidate])
            {
                //NSLog(@"adding %@", candidate);
                [options addObject:candidate];
            }
        }
    }
    
    NSArray *orderedOptions = [options shuffledCopy];
    NSString *choice = arc4random_uniform(2)
        ? [NSString stringWithFormat:@"%@%c", letters, 'a' + arc4random_uniform(26)]
        : [NSString stringWithFormat:@"%c%@", 'a' + arc4random_uniform(26), letters];
    if ([orderedOptions count] > 0)
    {
        choice = [orderedOptions objectAtIndex:0];
    }
    
    if ([[choice substringFromIndex:1] isEqualToString:letters])
    {
        dispatch_async(dispatch_get_main_queue(), ^{ [game addLetterToStart:[choice characterAtIndex:0]]; });
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{ [game addLetterToEnd:[choice characterAtIndex:[choice length] - 1]]; });
        return;
    }
}

@end
