//
//  EffectUtil.m
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "EffectUtil.h"
#import "MyScene.h"
#import "BrickUtil.h"
#import "ToolUtil.h"
#import "BallUtil.h"
#import "TimerThread.h"

typedef enum EffectType {
    Once, Twice, Three, Iron, Time, Tool, BallLevelUP
} EffectType;

@implementation EffectUtil{
    // BallView ballView;
    MyScene* ballView;
    BrickUtil* brickUtil;
    BallUtil* ball;
    TimerThread* timerThread;
    int toolEffectTwinkingAlpha;
    int toolEffectFinishAlpha;
    enum EffectType whichEffectType;
    ToolUtil* toolUtil;
    int needHitCount;
}


const int TYPE_NUM = 7;

const int TIME_EFFECT_COUNT = 60;
int timeCount = TIME_EFFECT_COUNT;




//EffectType whichEffectType;

-(void)initEffectUtilValue{
    toolEffectTwinkingAlpha = 255;
    toolEffectFinishAlpha = 255;
}

+(instancetype)initWithBallView:(MyScene*)ballView withBrickUtil:(BrickUtil*)brickUtil{
    EffectUtil * effect = [EffectUtil new];
    if(effect){
        effect->ballView = ballView;
        effect->brickUtil = brickUtil;
        effect.ironsCombo = false;
        [effect initEffectUtilValue];
    }
    return effect;
}

//public EffectUtil(BallView ballView, BrickUtil brickUtil) {
//    this.ballView = ballView;
//    this.brickUtil = brickUtil;
//    // setRandomEffectType();
//}

// private void setRandomEffectType(){
// Random random = new Random();
// int whichType = random.nextInt(TYPE_NUM-1);
//
// EffectType[] effectTypes = EffectType.values();
// whichEffectType = effectTypes[whichType];
// setInit();
// }

-(void)setEffect:(int) whichType {
    EffectType *effectTypes = malloc(sizeof(EffectType)*6);
    
//    EffectType effectTypes[7];
    
    effectTypes[0] = Once;
    effectTypes[1] = Twice;
    effectTypes[2] = Three;
    effectTypes[3] = Iron;
    effectTypes[4] = Time;
    effectTypes[5] = Tool;
    effectTypes[6] = BallLevelUP;
    
//    free(effectTypes);
    
    whichEffectType = effectTypes[whichType];
    switch (whichEffectType) {
		case Once:
			needHitCount = 1;
			break;
		case Twice:
			needHitCount = 2;
			break;
		case Three:
			needHitCount = 3;
			break;
		case Iron:
			needHitCount = -2;
			break;
		case Time:
			needHitCount = 1;
			break;
		case Tool:
			needHitCount = 1;
			break;
		case BallLevelUP:
			needHitCount = 1;
			break;
    }
}


-(void) doEffect:(BallUtil*) ball show:(NSMutableArray*)showTimeBrickEffectTime {
    self->ball = ball;
    switch (whichEffectType) {
		case Once:
		case Twice:
		case Three:
			[self doHitDetermine];
			break;
		case Iron:
			[self doHitIronDetermine];
			break;
		case Time:
			[self doHitDetermine];
            [self doTimeCountEffect:(NSMutableArray*)showTimeBrickEffectTime];
			break;
		case Tool:
			[self doHitDetermine];
            [self setToolEffect];
            [self startDownTool];
			break;
		case BallLevelUP:
			[self doHitDetermine];
            [self doBallLevelUPEffect:(BallUtil*)ball];
			break;
    }
}

-(void) doHitDetermine {
    if (needHitCount > 0) {
        int hit = [ballView getBallLevel] > 1 ? 2 : [ballView getBallLevel] + 1;
        if (needHitCount == 2) {
            ballView.hitBrickLevelDownCount += 1;
        } else if (needHitCount == 3) {
            ballView.hitBrickLevelDownCount += hit;
        }
        needHitCount = needHitCount - hit > 0 ? needHitCount - hit : 0;
    }
}

-(void) doHitIronDetermine {
    if ([ballView getBallLevel] == 2) {
        if (needHitCount == -2) {
            ballView.hitIronBrickLevelDownCount += 1;
        }
        needHitCount++;
        self.ironsCombo = true;
    } else {
        self.ironsCombo = false;
    }
}

-(void) doTimeCountEffect:(NSMutableArray*) showTimeBrickEffectTime {
    
    // handler.postDelayed(runnable, 1000);
    if (showTimeBrickEffectTime.count != 0) {
        EffectUtil* e = showTimeBrickEffectTime[0];
        TimerThread* t = [e getToolTimerThread];
        int currentTime = [t getCurrentTime];
        if (currentTime != 0) {
            int newTime = currentTime - TIME_EFFECT_COUNT / 2;
            if (newTime < 0)
                newTime = 0;
            [t setCurrentTime:newTime];
            return;
        }
    }
    timerThread = [TimerThread initWithTime:TIME_EFFECT_COUNT];
    [timerThread start];
    [showTimeBrickEffectTime addObject:self];
}

-(TimerThread*) getToolTimerThread {
    return timerThread;
}



-(int) getFinishAlpha {
    return toolEffectFinishAlpha;
}

-(void) setFinishAlpha:(int) toolEffectFinishAlpha {
    self->toolEffectFinishAlpha = toolEffectFinishAlpha;
}

-(void) setToolEffect {
    toolUtil = [ToolUtil initWithBallView:ballView BrickUtil:brickUtil];
    [ballView addChild:toolUtil];
}

-(int) getTwinklingAlpha {
    return toolEffectTwinkingAlpha;
}

-(void) setTwinklingAlpha:(int) toolEffectTwinkingAlpha {
    self->toolEffectTwinkingAlpha = toolEffectTwinkingAlpha;
}

-(void) doEffectFinish:(NSMutableArray*) ballUtils {
    for (BallUtil* ball in ballUtils) {
        [ball setBallLevel:-5];
    }
    // ball.setBallLevel(-5);
}

// private void downTool(){
// toolUtil.getToolRect();
// }

-(void) doBallLevelUPEffect:(BallUtil*) ball {
    // int ballLevel = ballView.getBallLevel()>1 ?
    // -1:ballView.getBallLevel()+1;
    // ballView.setBallLevel(ballLevel);
    int ballLevel = [ball getBallLevel] > 1 ? -1 : [ball getBallLevel] + 1;
    [ball setBallLevel:ballLevel];
}

-(int) getNeedHitCount {
    return needHitCount;
}

-(bool) isHasTool {
    return toolUtil != nil;
}

-(ToolUtil*) getToolObj {
    return toolUtil;
}

-(void) startDownTool {
    toolUtil.isStartDownTool = true;
}

// class EffectOnce{
//
// private final static EffectOnce II = new EffectOnce();
//
// private EffectOnce(){}
//
// public static EffectOnce getInstance(){
// return EFFECTONCE;
// }
//
// }

@end
