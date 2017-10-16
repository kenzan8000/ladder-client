#import "LDROperation.h"
#import "Reachability.h"


#pragma mark - LDROperation
@implementation LDROperation


#pragma mark - synthesize


#pragma mark - api
- (void)start
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        self.handler(nil,
                     @{},
                     [[NSError alloc] initWithDomain: NSMachErrorDomain
                                                code: 0
                                                userInfo:@{}]);
        return;
    }

    [super start];
}


#pragma mark - private api


@end

