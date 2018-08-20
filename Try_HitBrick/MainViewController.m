//
//  MainViewController.m
//  Try_HitBrick
//
//  Created by irons on 2015/11/29.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "GameCenterUtil.h"
#import "RankViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    //    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startClick:(id)sender {
    ViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (IBAction)leaderboardClick:(id)sender {
    RankViewController * rankViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
    
//    [self.navigationController pushViewController:rankViewController animated:YES];
    [self presentViewController:rankViewController animated:NO completion:nil];
}
@end
