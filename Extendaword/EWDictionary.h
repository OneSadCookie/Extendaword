#import <Foundation/Foundation.h>

@interface EWDictionary : NSObject

- (id)initWithURL:(NSURL *)url;

- (NSString *)wordContaining:(NSString *)substring;
- (void)eachWordContaining:(NSString *)substring block:(void (^)(BOOL *done, unsigned band, NSString *word))block;

- (BOOL)isWord:(NSString *)string;
- (BOOL)isWord:(NSString *)string band:(unsigned *)band;

@end
