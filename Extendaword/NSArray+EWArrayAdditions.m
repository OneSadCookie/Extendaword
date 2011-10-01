#import "NSArray+EWArrayAdditions.h"

@implementation NSArray (EWArrayAdditions)

- (NSArray *)map:(id (^)(id))block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in self)
    {
        [result addObject:block(obj)];
    }
    return [result copy];
}

- (NSArray *)filter:(BOOL (^)(id))block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in self)
    {
        if (block(obj)) [result addObject:obj];
    }
    return [result copy];
}

- (NSArray *)shuffledCopy
{
    NSMutableArray *result = [self mutableCopy];
    uint32_t n = (uint32_t)[self count];
    for (uint32_t i = 0; i < n; ++i)
    {
        size_t j = arc4random_uniform(n);
        id temp = [result objectAtIndex:i];
        [result replaceObjectAtIndex:i withObject:[result objectAtIndex:j]];
        [result replaceObjectAtIndex:j withObject:temp];
    }
    return [result copy];
}

@end
