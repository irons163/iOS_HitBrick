//
//  EffectUtil.h
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyScene.h"
//#import "BrickUtil.h"
#import "BallUtil.h"
#import "ToolUtil.h"


@class BrickUtil;

@interface EffectUtil : NSObject

@property bool ironsCombo;

+(instancetype)initWithBallView:(MyScene*)ballView withBrickUtil:(BrickUtil*)brickUtil;
-(void)setEffect:(int) whichType;
-(void) doEffect:(BallUtil*) ball show:(NSMutableArray*)showTimeBrickEffectTime;
-(int) getNeedHitCount;
-(bool) isHasTool;
-(ToolUtil*) getToolObj;
-(void) doEffectFinish:(NSMutableArray*) ballUtils;
@end
