//
//  BallUtil.m
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "BallUtil.h"
#import "BitmapUtil.h"

static BitmapUtil* bitmapUtil;
@implementation BallUtil{
    int ballLevel;
    float speedX;
    float speedY;
    float imageX;
    float imageY;
    float angle;
    int radius;
    bool isErrorLeftWallDoubleHitFlag;
    bool isErrorRightWallDoubleHitFlag;
}

+(id)initBallUtil:(int)ballLevel speedX:(float)speedX speedY:(float)speedY imageX:(float)imageX imageY:(float)imageY
           fAngle:(float)fAngle RADIUS:(float)RADIUS{
//    BallUtil * ball = [BallUtil spriteNodeWithColor:[UIColor redColor] size:CGSizeZero];
    bitmapUtil = [BitmapUtil sharedInstance];
    BallUtil * ball = [BallUtil spriteNodeWithTexture:bitmapUtil.ballTextures[ballLevel]];
    ball->speedX = speedX;
    ball->speedY = speedY;
    ball->imageX = imageX;
    ball->imageY = imageY;
    ball->angle = fAngle;
    ball->radius = RADIUS;
    return ball;
}

-(void)initGame{
    isErrorLeftWallDoubleHitFlag = false;
    isErrorRightWallDoubleHitFlag = false;
}

-(id)initWithSpeedX:(float)speedX SpeedY:(float)speedY{
    if(self = [super init]){
        self->speedX = speedX;
        self->speedY = speedY;
    }
    return self;
}

-(id)initBallUtilWithBallLevel:(int)ballLevel SpeedX:(float)speedX SpeedY:(float)speedY ImageX:(float)imageX ImageY:(float)imageY Angle:(float)angle Radius:(int)radius{
    if(self = [super init]){
        self->ballLevel = ballLevel;
        self->speedX = speedX;
        self->speedY = speedY;
        self->imageX = imageX;
        self->imageY = imageY;
        self->angle = angle;
        self->radius = radius;
    }
    return self;
}

-(int) getBallLevel{
    return ballLevel;
}

-(void) setBallLevel:(int) ballLevel{
    self->ballLevel = ballLevel;
    if(ballLevel>=0 && ballLevel<=2)
        self.texture = bitmapUtil.ballTextures[ballLevel];
}

-(float) getSpeedX{
    return speedX;
}

-(void) setSpeedX:(float) speedX{
    self->speedX = speedX;
}

-(float) getSpeedY{
    return speedY;
}

-(void) setSpeedY:(float) speedY{
    self->speedY = speedY;
}

-(float) getImageX{
    return imageX;
}

-(void) setImageX:(float) imageX{
    self->imageX = imageX;
}

-(float) getImageY{
    return imageY;
}

-(void) setImageY:(float) imageY{
    self->imageY = imageY;
}

-(float) getAngle{
    return angle;
}

-(void) setAngle:(float) angle{
    self->angle = angle;
}

-(int) getRadius{
    return radius;
}

-(void) setRadius:(int) radius{
    self->radius = radius;
}

-(bool) getIsErrorLeftWallDoubleHitFlag{
    return isErrorLeftWallDoubleHitFlag;
}

-(void) setIsErrorLeftWallDoubleHitFlag:(bool) isErrorLeftWallDoubleHitFlag{
    self->isErrorLeftWallDoubleHitFlag = isErrorLeftWallDoubleHitFlag;
}

-(bool) getIsErrorRightWallDoubleHitFlag{
    return isErrorRightWallDoubleHitFlag;
}

-(void) setIsErrorRightWallDoubleHitFlag:(bool) isErrorRightWallDoubleHitFlag{
    self->isErrorRightWallDoubleHitFlag = isErrorRightWallDoubleHitFlag;
}

@end
