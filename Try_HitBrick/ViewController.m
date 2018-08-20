//
//  ViewController.m
//  Try_HitBrick
//
//  Created by irons on 2015/5/6.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "BreakoutGameScene.h"
#import "WinDialogViewController.h"
#import "GameOverViewController.h"

extern const int MAX_LEVEL;

@implementation ViewController{
    MyScene * scene;
    WinDialogViewController * winDialogViewController;
    GameOverViewController* gameOverViewController;
}

MyScene* myView;
static int screenWidth;
static int screenHeight;
//TextView scoreTextView, increaseScroeTextView, gameLevelTextView,
//gameLifeTextView, changeBallLifeTextView, comboTextView;
//AnimationSet animationSet, animationSet2;
//Animation mAnimationReSize;

//public static boolean GAME_PAUSE_FLAG = false;
//public static Object Lock = new Object();
int level;

-(void)handleMsg:(int)msgWhat{
//        switch (msgWhat) {
//            case 0:
//                onBackPressed();
//                break;
//            case 1:
//                scoreTextView.setText(myView.score + "");
//                break;
//            case 2:
//                increaseScroeTextView.setText(" +" + myView.increaseScroe + "");
//                myView.increaseScroe = 0;
//                // animationSet.startNow();
//                increaseScroeTextView.startAnimation(animationSet);
//                break;
//            case 3:
//                gameLevelTextView.setText(myView.playGameLevel + 1 + "");
//                break;
//            case 4:
//                gameLifeTextView.setText(myView.ballLife + "");
//                break;
//            case 5:
//                comboTextView.setText("COMBO X " + msg.arg1);
//                // mAnimationReSize.startNow();
//                comboTextView.startAnimation(mAnimationReSize);
//                break;
//            case 6:
//                myView = new BallView(MainActivity.this, msg.arg1);
//                playGameLevel = msg.arg1;
//                setGameView();
//                break;
//            case 7:
//                String changeBallLifeString;
//                if (msg.arg1 >= 0)
//                    changeBallLifeString = "+" + msg.arg1;
//                else
//                    changeBallLifeString = "" + msg.arg1;
//                changeBallLifeTextView.setText(" " + changeBallLifeString + "");
//                // animationSet2.startNow();
//                changeBallLifeTextView.startAnimation(animationSet2);
//                break;
//        }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [MyScene initWithSize:skView.bounds.size playGameLevel:1 withViewController:self];
//    SKScene * scene = [BreakoutGameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    // Present the scene.
    [skView presentScene:scene];
}

-(void)showWinDialog{
    winDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WinDialogViewController"];
    winDialogViewController.gameDelegate = self;
    
    //    gameOverDialogViewController.gameLevelTensDigitalLabel = time;
    
    //    winDialogViewController.gameLevel = gameLevel;
    
    //    [self.navigationController popToViewController:gameOverDialogViewController animated:YES];
    
    //    [self.delegate BviewcontrollerDidTapButton:self];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [winDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
    //    [self.navigationController presentViewController:winDialogViewController animated:YES completion:^{
    //        //        [reset];
    //    }];
    
    winDialogViewController.view.
    backgroundColor = [UIColor blackColor];
    winDialogViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    //    winDialogViewController.view.alpha = 0.5;
    //    [self.navigationController pushViewController:winDialogViewController animated:YES];
    [self presentViewController:winDialogViewController animated:YES completion:nil];
    
    if (level == 2) {
        //        winDialogViewController.goToNextLevel.rank_level;
    }
}

//-(void)showLoseDialog:(int)score{
//    GameOverViewController* gameOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
//    gameOverViewController.gameDelegate = self;
//    [gameOverViewController setScore:score];
//    
//    self.providesPresentationContextTransitionStyle = YES;
//    self.definesPresentationContext = YES;
//    [gameOverViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//    
//    gameOverViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
//    
//    [self.navigationController presentViewController:gameOverViewController animated:YES completion:nil];
//}

-(void)showLoseDialog:(int)score{
    gameOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverViewController.gameDelegate = self;
    [gameOverViewController setScore:score];
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [gameOverViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    gameOverViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    
    [self presentViewController:gameOverViewController animated:YES completion:nil];
}

-(void)goToMenu{
    //    gameFlag = false;
    if(winDialogViewController!=nil){
        [winDialogViewController dismissViewControllerAnimated:true completion:nil];
        winDialogViewController = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
        //        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [gameOverViewController dismissViewControllerAnimated:true completion:nil];
        gameOverViewController = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)goToNextLevel{
    SKTexture* nextBackground;
    
    if (level + 1 < MAX_LEVEL) {
//        nextBackground = [TextureHelper bgTextures][level + 1];
    } else if (level + 1 == MAX_LEVEL) {
//        nextBackground = [TextureHelper bgTextures][level + 1];
    }
    
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    scene = [MyScene initWithSize:skView.bounds.size playGameLevel:level+1 withViewController:self];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Present the scene.
    [skView presentScene:scene];
    
    if(winDialogViewController){
        [winDialogViewController dismissViewControllerAnimated:true completion:nil];
        winDialogViewController = nil;
    }else if(gameOverViewController){
        [gameOverViewController dismissViewControllerAnimated:true completion:nil];
        gameOverViewController = nil;
    }
    
    level++;
    
//    [];
}

-(void)restart{
    level--;
    [self goToNextLevel];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
