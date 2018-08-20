//
//  BallViewConfig.m
//  
//
//  Created by irons on 2015/6/3.
//
//

#import "BallViewConfig.h"


@implementation BallViewConfig

- (id)init {
    if (self=[super init]) {
        
    }
    return self;
}


+ (id)sharedInstance {
    static BallViewConfig* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BallViewConfig* tmp = [[self alloc] init];
        instance = tmp;
    });
    return instance;
}

@end
