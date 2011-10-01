#import <sqlite3.h>
#import "EWDictionary.h"

__attribute__((unused)) static void EWTrace(void *_,const char *s)
{
    NSLog(@"SQLite3 Trace: %s", s);
}

@implementation EWDictionary
{
    sqlite3 *db;
    sqlite3_stmt *containsQuery;
    sqlite3_stmt *exactQuery;
    BOOL busy;
}

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        if (sqlite3_open_v2(
                [[url path] fileSystemRepresentation],
                &db,
                SQLITE_OPEN_READONLY,
                NULL) != SQLITE_OK)
        {
            NSLog(@"Can't open database %@", url);
            return nil;
        }
        
        if (sqlite3_prepare_v2(
                db,
                "SELECT band, word FROM words WHERE word LIKE ?1",
                -1,
                &containsQuery,
                NULL) != SQLITE_OK)
        {
            NSLog(@"Can't prepare contains query");
            return nil;
        }
        
        if (sqlite3_prepare_v2(
                db,
                "SELECT band, word FROM words WHERE word = ?1",
                -1,
                &exactQuery,
                NULL) != SQLITE_OK)
        {
            NSLog(@"Can't prepare exact query");
            return nil;
        }
        
        //sqlite3_trace(db, EWTrace, NULL);
    }
    
    return self;
}

- (void)dealloc
{
    sqlite3_finalize(containsQuery);
    sqlite3_finalize(exactQuery);
    sqlite3_close(db);
}

- (void)eachWordInQuery:(sqlite3_stmt*)stmt with1Param:(NSString *)param block:(void (^)(BOOL *done, unsigned band, NSString *word))block
{
    assert(!busy);
    @try
    {
        busy = YES;
        sqlite3_reset(stmt);
        sqlite3_clear_bindings(stmt);
        
        char const *s = [param UTF8String];
        if (sqlite3_bind_text(stmt, 1, s, (int)strlen(s), SQLITE_STATIC) != SQLITE_OK) abort();
        
        int state = sqlite3_step(stmt);
        BOOL done = NO;
        while (!done && state == SQLITE_ROW)
        {
            void const *data = sqlite3_column_text(stmt, 1);
            size_t length = sqlite3_column_bytes(stmt, 1);
            block(&done, sqlite3_column_int(stmt, 0), [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding]);
            state = sqlite3_step(stmt);
        }
        if (!done && state != SQLITE_DONE)
        {
            NSLog(@"sqlite3_step returned error %s", sqlite3_errmsg(db));
            abort();
        }
    }
    @finally
    {
        busy = NO;
    }
}

- (NSString *)wordContaining:(NSString *)substring
{
    __block NSString *result = nil;
    [self eachWordInQuery:containsQuery with1Param:[NSString stringWithFormat:@"%%%@%%", substring] block:^(BOOL *done, unsigned band, NSString *word) {
        result = word;
        *done = YES;
    }];
    return result;
}

- (void)eachWordContaining:(NSString *)substring block:(void (^)(BOOL *done, unsigned band, NSString *word))block
{
    [self eachWordInQuery:containsQuery with1Param:[NSString stringWithFormat:@"%%%@%%", substring] block:block];
}

- (BOOL)isWord:(NSString *)string
{
    unsigned band;
    return [self isWord:string band:&band];
}

- (BOOL)isWord:(NSString *)string band:(unsigned *)band
{
    __block NSString *result = nil;
    [self eachWordInQuery:exactQuery with1Param:string block:^(BOOL *done, unsigned b, NSString *word) {
        result = word;
        *band = b;
        *done = YES;
    }];
    return result != nil;
}

@end
