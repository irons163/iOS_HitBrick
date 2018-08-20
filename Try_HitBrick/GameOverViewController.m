//
//  GameOverViewController.m
//  Try_downStage
//
//  Created by irons on 2015/6/25.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameOverViewController.h"
//#import "GameOverViewController2.h"
#import "DatabaseManager.h"

@interface MyObject:NSObject<UIAlertViewDelegate>
typedef void (^okBlock)();
@property (strong) okBlock okBlock;
@end

@implementation MyObject
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self okBlock];
}
@end

@interface GameOverViewController ()

@end

@implementation GameOverViewController{
    int gameScore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.gameOverTitleLabel.text = NSLocalizedString(@"Rank", "");
    self.gameScoreLabel.text = [NSString stringWithFormat:@"%d", gameScore];
    [self.gameScoreLabel sizeToFit];
    self.nameEditView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setScore:(int)score{
    gameScore = score;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToMenu:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.gameDelegate goToMenu];
}

- (IBAction)sendScore:(id)sender {
//    SQLiteHelper helper = new SQLiteHelper(context);
    NSString* name = self.nameEditView.text;
    if ([name  isEqual: @""] || [[name stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]]isEqual: @""]) {
        UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"CannotNull",@"") delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alerView show];
    } else {
        DatabaseManager* manager = [DatabaseManager sharedInstance];
        [manager insertWithName:name withScore:gameScore];
        
        UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"success" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        
        self.gameOverTitleLabel.hidden = YES;
        self.gameScoreLabel.hidden = YES;
        self.nameEditView.hidden = YES;
        self.submitButton.hidden = YES;
        
        [alerView show];
    }
}

- (IBAction)restartClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.gameDelegate restart];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
