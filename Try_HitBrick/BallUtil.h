//
//  BallUtil.h
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BallUtil : SKSpriteNode

+(id)initBallUtil:(int)ballLevel speedX:(float)speedX speedY:(float)speedY imageX:(float)imageX imageY:(float)imageY
fAngle:(float)fAngle RADIUS:(float)RADIUS;

-(int) getBallLevel;
-(void) setBallLevel:(int) ballLevel;

-(void) setSpeedX:(float) speedX;
-(void) setSpeedY:(float) speedY;
-(float) getSpeedX;
-(float) getSpeedY;

@end
