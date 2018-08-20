//
//  ToolUtil.h
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyScene.h"
#import "BallUtil.h"
//#import "BrickUtil.h"
#import "TimerThread.h"

@class BrickUtil;

@interface ToolUtil : SKSpriteNode

@property bool isStartDownTool;
@property BallUtil * ball;

+(instancetype)initWithBallView:(MyScene*) ballView BrickUtil:(BrickUtil*) brickUtil;
-(void) moveDownToolObj;
-(void) doTool:(NSMutableArray*) ballUtils ball:(BallUtil*) ball showToolEffectTime:(NSMutableArray*)showToolEffectTime;
-(void) doToolFinish;
-(TimerThread*) getToolTimerThread;
-(SKTexture*)getToolBitmap;
@end
