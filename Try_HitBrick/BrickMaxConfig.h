//
//  BrickMaxConfig.h
//  Try_HitBrick
//
//  Created by irons on 2015/5/22.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrickMaxConfig : NSObject


@property int LV2_Brick_Twice_MAX;
@property int LV2_Brick_Tool_MAX;
@property int LV2_Brick_BallLevelUP_MAX;

@property int LV3_Brick_Three_MAX;
@property int LV3_Brick_Iron_MAX;
@property int LV3_Brick_Tool_MAX;
@property int LV3_Brick_BallLevelUP_MAX;

@property int LV4_Brick_Twice_MAX;
@property int LV4_Brick_Three_MAX;
@property int LV4_Brick_Time_MAX;
@property int LV4_Brick_Tool_MAX;
@property int LV4_Brick_BallLevelUP_MAX;

@property int LV5_Brick_Twice_MAX;
@property int LV5_Brick_Three_MAX;
@property int LV5_Brick_Iron_MAX;
@property int LV5_Brick_Time_MAX;
@property int LV5_Brick_Tool_MAX;
@property int LV5_Brick_BallLevelUP_MAX;

@property bool brickMaxConfigEnable;

+ (id)sharedInstance;

-(void) setBrickMaxConfigEnable:(bool) brickMaxConfigEnable PlayGameLevel:(int) playGameLevel;

-(void) setBrickMaxBy:(int) playGameLevel;

-(bool) isBrickMaxConfigEnable;

-(bool) isBrickOverMax:(int) whichBrickType;

@end
