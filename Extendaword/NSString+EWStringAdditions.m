#import "NSString+EWStringAdditions.h"

@implementation NSString (EWStringAdditions)

+ (id)stringWithCharacter:(unichar)c
{
    return [self stringWithCharacters:(unichar[]){c} length:1];
}

@end
