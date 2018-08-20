//
//  MyScene.h
//  Try_HitBrick
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"

extern const uint32_t toolCategory;
const static int MAX_LEVEL = 10;

@interface MyScene : SKScene<SKPhysicsContactDelegate>

@property int hitBrickLevelDownCount;
@property int hitIronBrickLevelDownCount;

@property (weak) id<gameDelegate> gameDelegate;

+(uint32_t)blockCategory;
+(NSString*)blockCategoryName;
+(id)initWithSize:(CGSize)size playGameLevel:(int)playGameLevel withViewController:(ViewController*)viewcontroller;
-(int) getBallLevel;
//getBricksAreaBottom;
-(void) setStickLong:(float)stickLong;
-(float) getStickLong;
-(void) setBallLife:(int) life;
-(int) getBallLife;
-(void) resetBall;

@end
