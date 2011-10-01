#import <Foundation/Foundation.h>

@interface NSArray (EWArrayAdditions)

- (NSArray *)map:(id (^)(id))block;
- (NSArray *)filter:(BOOL (^)(id))block;
- (NSArray *)shuffledCopy;

@end
