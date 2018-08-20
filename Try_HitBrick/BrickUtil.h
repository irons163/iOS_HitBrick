//
//  BrickUtil.h
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"
#import "BallUtil.h"
#import "EffectUtil.h"

//@class EffectUtil;

@interface BrickUtil : SKSpriteNode

@property int left, top, right, bottom;

+ (id)init __unavailable;
+ (id)initWithBallView:(MyScene *)ballview;
-(void) setPlayGameLevel:(int)playGameLevel Left:(int)left Top: (int) top Right: (int) right Bottom:(int) bottom;
-(bool) isHitIronBrick;
-(bool) isIronsBrick;
-(Rect) getRect;
-(void) doHitEffect:(BallUtil*) ball showTimeBrickEffectTime:(NSMutableArray*) showTimeBrickEffectTime;
-(bool) isBrickExist;
-(EffectUtil*) getEffect;
@end
