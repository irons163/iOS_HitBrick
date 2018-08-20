//
//  BrickUtil.m
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "BrickUtil.h"
#import "MyScene.h"

#import "BrickMaxConfig.h"
#import "BitmapUtil.h"
#import "BallUtil.h"

@implementation BrickUtil{
    MyScene *  ballView;
    EffectUtil * effectUtil;
    SKTexture * bitmap;
    Rect rect;
}

const int Brick_Once = 0;
const int Brick_Twice = 1;
const int Brick_Three = 2;
const int Brick_Iron = 3;
const int Brick_Time = 4;
const int Brick_Tool = 5;
const int Brick_BallLevelUP = 6;
//Rect rect = new Rect();


int whichBrickType;

BrickMaxConfig * brickMaxConfig;
BitmapUtil * bitmapUtil;

//public BrickUtil(BallView ballView) {
//    this.ballView = ballView;
//}

+ (id)initWithBallView:(MyScene *)_ballview {
    BrickUtil * brick = [BrickUtil spriteNodeWithImageNamed:@"block.png"];
    if (brick) {
    
        int blockWidth = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"].size.width;
        float padding = 20.0f;
        // 2 Calculate the xOffset
        float xOffset = 0;
        // 3 Create the blocks and add them to the scene
//            SKSpriteNode* block = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"];
//            brick.position = CGPointMake(brick.frame.size.width + xOffset, self.frame.size.height * 0.8f);
            brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
            brick.physicsBody.allowsRotation = NO;
            brick.physicsBody.friction = 0.0f;
            brick.physicsBody.density = 0.0f;
            brick.name = MyScene.blockCategoryName;
            brick.physicsBody.categoryBitMask = MyScene.blockCategory;
        brick.physicsBody.dynamic = NO;
        
//            [self addChild:brick];
        
        brick->ballView = _ballview;
//        brickMaxConfig = [BrickMaxConfig sharedInstance];
        bitmapUtil = [BitmapUtil sharedInstance];
    }
    return brick;
}


-(void) setPlayGameLevel:(int)playGameLevel Left:(int)left Top: (int) top Right: (int) right Bottom:(int) bottom {
    rect.left = left;
    rect.top = top;
    rect.right = right;
    rect.bottom = bottom;
    self.size = CGSizeMake(right - left, top - bottom);
    self.position = CGPointMake(left+self.size.width/2, top-self.size.height);
    
//    self.anchorPoint = CGPointMake(0, 1);
    self.left = left;
    self.top = top;
    self.right = right;
    self.bottom = bottom;
    
    do {
        // 5關
        if (playGameLevel == 0)
            whichBrickType = Brick_Once;
        else if (playGameLevel == 1) {
            int temp = arc4random_uniform(3);
            if (temp == 0) {
                whichBrickType = Brick_Twice;
            } else if (temp == 1) {
                whichBrickType = Brick_Tool;
            } else {
                whichBrickType = Brick_BallLevelUP;
            }
        } else if (playGameLevel == 2) {
            int temp = arc4random_uniform(4);
            if (temp == 0) {
                whichBrickType = Brick_Three;
            } else if (temp == 1) {
                whichBrickType = Brick_Iron;
            } else if (temp == 2) {
                whichBrickType = Brick_Tool;
            } else {
                whichBrickType = Brick_BallLevelUP;
            }
        } else if (playGameLevel == 3) {
            int temp = arc4random_uniform(5);
            if (temp == 0) {
                whichBrickType = Brick_Twice;
            } else if (temp == 1) {
                whichBrickType = Brick_Three;
            } else if (temp == 2) {
                whichBrickType = Brick_Time;
            } else if (temp == 3) {
                whichBrickType = Brick_Tool;
            } else {
                whichBrickType = Brick_BallLevelUP;
            }
        } else if (playGameLevel == 4) {
            int temp = arc4random_uniform(6);
            if (temp == 0) {
                whichBrickType = Brick_Twice;
            } else if (temp == 1) {
                whichBrickType = Brick_Three;
            } else if (temp == 2) {
                whichBrickType = Brick_Iron;
            } else if (temp == 3) {
                whichBrickType = Brick_Time;
            } else if (temp == 4) {
                whichBrickType = Brick_Tool;
            } else {
                whichBrickType = Brick_BallLevelUP;
            }
        }
    } while ([brickMaxConfig isBrickMaxConfigEnable]
             && [brickMaxConfig isBrickOverMax:whichBrickType]);
    
    bitmap = [SKTexture textureWithImageNamed:@"block.png"];
    
    self.texture = bitmap;
    
    [self setBitmapByBrickType:whichBrickType];
    [self setEffect:whichBrickType];
}

-(void) setBitmapByBrickType:(int) whichBrickType {
    switch (whichBrickType) {
		case 0:
			bitmap = bitmapUtil.brick_once_bmp;
			break;
		case 1:
			bitmap = bitmapUtil.brick_twice_bmp;
			break;
		case 2:
			bitmap = bitmapUtil.brick_three_bmp;
			break;
		case 3:
			bitmap = bitmapUtil.brick_iron_bmp;
			break;
		case 4:
			bitmap = bitmapUtil.brick_time_bmp;
			break;
		case 5:
			bitmap = bitmapUtil.brick_tool_bmp;
			break;
		case 6:
			bitmap = bitmapUtil.brick_ball_level_up_bmp;
			break;
    }
    
    self.texture = bitmap;
}

-(void) setEffect:(int) whichBrickType {
    effectUtil = [EffectUtil initWithBallView:ballView withBrickUtil:self];
    [effectUtil setEffect:whichBrickType];
}

-(EffectUtil*) getEffect {
    return effectUtil;
}

-(void) doHitEffect:(BallUtil*) ball showTimeBrickEffectTime:(NSMutableArray*) showTimeBrickEffectTime {
    [effectUtil doEffect:ball show:showTimeBrickEffectTime];
    SKTexture* newBrickBmp = [self getNewBrickBmpAfterHit:[effectUtil getNeedHitCount]];
    if (newBrickBmp != nil) {
        bitmap = newBrickBmp;
        self.texture = bitmap;
    }
}

-(bool) isBrickExist{
    return [effectUtil getNeedHitCount] != 0;
}

-(SKTexture*) getBrickBitmap{
    return bitmap;
}

-(Rect) getRect{
    return rect;
}

-(bool) isHitIronBrick {
    if (whichBrickType == 3 && effectUtil.ironsCombo) {
        return true;
    }
    return false;
}

-(SKTexture*) getNewBrickBmpAfterHit:(int) needHitCount {
    SKTexture* bitmap = nil;
    switch (needHitCount) {
		case 1:
			bitmap = bitmapUtil.brick_once_bmp;
			break;
		case 2:
			bitmap = bitmapUtil.brick_twice_bmp;
			break;
		case -1:
			bitmap = bitmapUtil.brick_iron_break_bmp;
			break;
		default:
			break;
    }
    return bitmap;
}

-(bool) isIronsBrick {
    return whichBrickType == 3;
}

@end
