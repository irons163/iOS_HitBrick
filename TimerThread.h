//
//  TimerThread.h
//  Try_HitBrick
//
//  Created by irons on 2015/5/25.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerThread : NSObject

+(instancetype)initWithTime:(int)time;
-(int) getCurrentTime;
-(void) setCurrentTime:(int) time;
-(void)start;
@end
