//
//  TimerThread.m
//  Try_HitBrick
//
//  Created by irons on 2015/5/25.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "TimerThread.h"
#import "ToolUtil.h"
#import "EffectUtil.h"
#import "MyScene.h"
#import "BallViewConfig.h"

@implementation TimerThread{
    int time;
    ToolUtil* tool;
    EffectUtil* effect;
    bool flag;
//    Object Lock;
}


-(void)initValue{
    flag = true;
//    Lock = new Object();
}

+(instancetype)initWithTime:(int)time{
    TimerThread* timer = [[TimerThread alloc] init];
    timer->time = time;
    [timer initValue];
    return timer;
}

-(instancetype)initWithTime:(int) time tool:(ToolUtil*)tool{
    if(self = [super init]){
        self->time = time;
        self->tool = tool;
    }
    return self;
}

-(instancetype)initWithTime:(int)time effect:(EffectUtil*)effect{
    if(self = [super init]){
        self->time = time;
        self->effect = effect;
    }
    return self;
}

//public TimerThread(int time) {
//        this.time = time;
//}
//    
//public TimerThread(int time, ToolUtil tool) {
//        this.time = time;
//        this.tool = tool;
//}
//
//public TimerThread(int time, EffectUtil effect) {
//        this.time = time;
//        this.effect = effect;
//}

-(void)start{
    [self run];
}

-(void)run{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(flag && time != 0){
            BallViewConfig * ballViewConfig = [BallViewConfig sharedInstance];
            while(ballViewConfig.gameFlag && !ballViewConfig.waitGameSuccessProcessing){
                sleep(1);
                @synchronized(self){
                    if (time > 0)
                        time--;
                }
                
                if(ballViewConfig.GAME_PAUSE_FLAG){
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                    dispatch_semaphore_signal(sema);
                }
            }
        }
        
    });
}

//    @Override
//    public void run() {
//        
//        while (flag && time != 0) {
//            while(BallView.gameFlag && !BallView.waitGameSuccessProcessing){
//                try {
//                    Thread.sleep(1000);
//                } catch (InterruptedException e) {
//                    // TODO Auto-generated catch block
//                    e.printStackTrace();
//                }
//                synchronized (MainActivity.Lock) {
//                    //				if (MainActivity.GAME_PAUSE_FLAG)
//                    //					try {
//                    //						MainActivity.Lock.wait();
//                    //					} catch (InterruptedException e) {
//                    //						// TODO Auto-generated catch block
//                    //						e.printStackTrace();
//                    //					}
//                    if (time > 0)
//                        time--;
//                }
//                if(MainActivity.GAME_PAUSE_FLAG){
//                    synchronized (BallView.LOCK) {
//                        try {
//                            BallView.LOCK.wait();
//                        } catch (InterruptedException e) {
//                            // TODO Auto-generated catch block
//                            e.printStackTrace();
//                        }
//                    }
//                }
//            }}
//    }

    -(void)cancel{
        flag = false;
    }
    
    -(int) getCurrentTime {
        return time;
    }
    
    -(void) setCurrentTime:(int) time {
        @synchronized (self) {
            self->time = time;
        }
    }



@end
