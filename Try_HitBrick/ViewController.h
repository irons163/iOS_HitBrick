//
//  ViewController.h
//  Try_HitBrick
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@protocol gameDelegate <NSObject>
- (void)showWinDialog;
- (void)showLoseDialog:(int)score;
- (void)goToMenu;
- (void)goToNextLevel;
- (void)restart;
@end

@interface ViewController : UIViewController<gameDelegate>

@end
