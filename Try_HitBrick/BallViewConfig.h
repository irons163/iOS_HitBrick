//
//  BallViewConfig.h
//  
//
//  Created by irons on 2015/6/3.
//
//

#import <Foundation/Foundation.h>

@interface BallViewConfig : NSObject

@property bool gameFlag;
@property bool waitGameSuccessProcessing;
@property bool GAME_PAUSE_FLAG;

+(id)sharedInstance;

@end
