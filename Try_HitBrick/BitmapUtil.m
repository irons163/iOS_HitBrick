//
//  BitmapUtil.m
//  Try_downStage
//
//  Created by irons on 2015/5/20.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "BitmapUtil.h"

@implementation BitmapUtil{
    SKTexture * time01, *time02, *time03, *time04, *time05, *time06, *time07, *time08, *time09, *time00, *timeQ;
    NSArray * timeScores;
}

-(id)init{
    if(self = [super init]){
        
        self.bar = [SKTexture textureWithImageNamed:@"bar"];
    
        self.brick_once_bmp=[SKTexture textureWithImageNamed:@"brick01"];
        self.brick_twice_bmp=[SKTexture textureWithImageNamed:@"brick02"];
        self.brick_three_bmp=[SKTexture textureWithImageNamed:@"brick03"];
        self.brick_iron_bmp = [SKTexture textureWithImageNamed:@"brick04"];
        self.brick_time_bmp = [SKTexture textureWithImageNamed:@"brick05"];
        self.brick_tool_bmp = [SKTexture textureWithImageNamed:@"brick06"];
        self.brick_ball_level_up_bmp = [SKTexture textureWithImageNamed:@"brick07"];
        self.brick_iron_break_bmp = [SKTexture textureWithImageNamed:@"brick04_1"];
        
        self.tool_BallSpeedUp_bmp = [SKTexture textureWithImageNamed:@"tool01"];
        self.tool_BallSpeedDown_bmp = [SKTexture textureWithImageNamed:@"tool02"];
        self.tool_StickLongUp_bmp = [SKTexture textureWithImageNamed:@"tool03"];
        self.tool_StickLongDown_bmp = [SKTexture textureWithImageNamed:@"tool04"];
        self.tool_BallCountUpToThree_bmp = [SKTexture textureWithImageNamed:@"tool05"];
        self.tool_LifeUp_bmp = [SKTexture textureWithImageNamed:@"tool06"];
        self.tool_Weapen_bmp = [SKTexture textureWithImageNamed:@"tool07"];
        self.tool_BallReset_bmp = [SKTexture textureWithImageNamed:@"tool08"];
        self.tool_StickLongMax_bmp = [SKTexture textureWithImageNamed:@"tool09"];
        self.tool_BallRadiusUp_bmp = [SKTexture textureWithImageNamed:@"tool10"];
        self.tool_BallRadiusDown_bmp = [SKTexture textureWithImageNamed:@"tool11"];
        self.tool_BlackHole_bmp = [SKTexture textureWithImageNamed:@"tool12"];
        self.tool_BallLevelUpTwice_bmp = [SKTexture textureWithImageNamed:@"tool13"];
        self.tool_BallLevelDownOnce_bmp = [SKTexture textureWithImageNamed:@"tool14"];
        
        self.ball_Show_bmp = [SKTexture textureWithImageNamed:@"ball2"];
        
        time01  = [SKTexture textureWithImageNamed:@"s1"];
        time02  = [SKTexture textureWithImageNamed:@"s2"];
        time03  = [SKTexture textureWithImageNamed:@"s3"];
        time04  = [SKTexture textureWithImageNamed:@"s4"];
        time05  = [SKTexture textureWithImageNamed:@"s5"];
        time06  = [SKTexture textureWithImageNamed:@"s6"];
        time07  = [SKTexture textureWithImageNamed:@"s7"];
        time08  = [SKTexture textureWithImageNamed:@"s8"];
        time09  = [SKTexture textureWithImageNamed:@"s9"];
        time00  = [SKTexture textureWithImageNamed:@"s0"];
        timeQ  = [SKTexture textureWithImageNamed:@"dot"];
        
        timeScores = @[time00, time01, time02, time03, time04, time05,time06, time07, time08, time09, timeQ];
        
        self.ballTextures = @[[SKTexture textureWithImageNamed:@"ball"],
                              [SKTexture textureWithImageNamed:@"ball1"],
                              [SKTexture textureWithImageNamed:@"ball2"]];
    }
    return self;
}

-(NSArray *)timeTextures{
    return timeScores;
}

+ (id)sharedInstance {
    static BitmapUtil* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}



@end
