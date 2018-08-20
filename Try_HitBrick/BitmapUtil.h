//
//  BitmapUtil.h
//  Try_downStage
//
//  Created by irons on 2015/5/20.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface BitmapUtil : NSObject

@property SKTexture * bar;

@property SKTexture * brick_once_bmp;
@property SKTexture * brick_twice_bmp;
@property SKTexture * brick_three_bmp;
@property SKTexture * brick_iron_bmp;
@property SKTexture * brick_time_bmp;
@property SKTexture * brick_tool_bmp;
@property SKTexture * brick_ball_level_up_bmp;
@property SKTexture * brick_iron_break_bmp;

@property SKTexture * tool_BallSpeedUp_bmp;
@property SKTexture * tool_BallSpeedDown_bmp;
@property SKTexture * tool_StickLongUp_bmp;
@property SKTexture * tool_StickLongDown_bmp;
@property SKTexture * tool_BallCountUpToThree_bmp;
@property SKTexture * tool_LifeUp_bmp;
@property SKTexture * tool_Weapen_bmp;
@property SKTexture * tool_BallReset_bmp;
@property SKTexture * tool_StickLongMax_bmp;
@property SKTexture * tool_BallRadiusUp_bmp;
@property SKTexture * tool_BallRadiusDown_bmp;
@property SKTexture * tool_BlackHole_bmp;
@property SKTexture * tool_BallLevelUpTwice_bmp;
@property SKTexture * tool_BallLevelDownOnce_bmp;

@property SKTexture * ball_Show_bmp;

@property NSArray* ballTextures;

-(NSArray *)timeTextures;

+(id)sharedInstance;

@end
