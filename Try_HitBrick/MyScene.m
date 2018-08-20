//
//  MyScene.m
//  Try_HitBrick
//
//  Created by irons on 2015/5/6.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "BrickUtil.h"
#import "BrickMaxConfig.h"
#import "BallViewConfig.h"
#import "BallUtil.h"
#import "ToolUtil.h"
#import "BitmapUtil.h"
#import "GameOverViewController.h"

const int N = 4;
static NSString* ballCategoryName = @"ball";
static NSString* paddleCategoryName = @"paddle";
static NSString* blockCategoryName = @"block";
static NSString* blockNodeCategoryName = @"blockNode";

static const uint32_t ballCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t blockCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000
const uint32_t toolCategory = 0x1 << 4; // 00000000000000000000000000010000

#define MyRectMake(left, top, right, bottom)  [MyRect RectMakeL:left T:top R:right B:bottom]
@interface MyRect : NSObject
@property int left;
@property int top;
@property int right;
@property int bottom;
+(MyRect*)RectMakeL:(int) left T:(int) top R:(int) right B:(int) bottom;
@end

@implementation MyRect
+(MyRect *)RectMakeL:(int)left T:(int)top R:(int)right B:(int)bottom{
    MyRect* rect = [MyRect new];
    rect.left = left;
    rect.top = top;
    rect.right = right;
    rect.bottom = bottom;
    return rect;
}
@end

@interface MyScene()

@property (nonatomic) BOOL isFingerOnPaddle;

@end

@implementation MyScene{
    BrickUtil* rBrick[N][N];
    int iNumBricks;
    bool bRbOn[N][N];
    int playGameLevel;
    float widthScreen;
    float heightScreen;
    BallViewConfig * ballViewConfig;
    BallUtil* ball;
    
    NSMutableArray * toolUtils;
    NSMutableArray * ballUtils;
    NSMutableArray * showToolEffectTime;
    NSMutableArray * showTimeBrickEffectTime;
    NSMutableArray * showToolEffectTimeNodes;
    NSMutableArray * showTimeBrickEffectTimeNodes;
    NSArray* colors;
    
    BitmapUtil* bitmapUtil;
    
//    int hitBrickLevelDownCount;
//    int hitIronBrickLevelDownCount;
    int clearBrickCount;
    int comboCount;
    int comboScoreCount;
    int clearIronBrickCount;
    
    int score;
    int lastTimeCount;
    int increaseScroe;
    
    int count;
    
    SKLabelNode *scroeTextView, *increaseScroeTextView;
    SKSpriteNode *gameTimeHundredsCountNode,
    *gameTimeTensCountNode,
    *gameTimeSingleDigitsCountNode,
    *gameTimeNode;
    
    bool isFirstDoGameFinish;
    
    SKSpriteNode *ballIconNode;
    SKLabelNode *ballCHangeLabelNode;
    
    bool isBallLifeChange;
    int ballLifeChange;
    
    int ballLifeShowBmpCount;
    
    SKLabelNode *ballLifeNode;
    
    bool gameSuccess;
    
    NSTimer *timer;
    
    int ballLevel;
    
    bool readyFlag;
    
    SKSpriteNode* readyAlertBox;
    SKSpriteNode* paddle;
    CGSize paddleOriginalSize;
    
    int ballLife;
//    SKSpriteNode * toolEffectTimeTenNode, * toolEffectTimeSingleNode, *toolEffectTimeNode;
}

@synthesize hitBrickLevelDownCount;
@synthesize hitIronBrickLevelDownCount;

const int BRICK_LEVEL_DOWN_SCORE = 300;
const int BRICK_IRON_LEVEL_DOWN_SCORE = 500;
const int BRICK_CLEAR_SCORE = 1000;
const int BRICK_COMBO_SCORE = 100;
const int BRICK_IRON_CLEAR_SCORE = 1500;

bool ball_isRun = false;
const static int GAME_TIME = 50;

const int CHANGE_MUSIC_TIME = 30;

const int InitRadius = 20;
int RADIUS = InitRadius;

const int Init_THICK_OF_STICK = 100;
int THICK_OF_STICK = Init_THICK_OF_STICK;

float imageX = -50.0f, imageY = -50.0f;
float fAngle;
float speedY = -15;
float speedX = -15;

const int ballInitLife = 2; // 剩餘兩顆

static bool waitGameSuccessProcessing = false;

const int BALL_LIFE_UP = 1;
const int BALL_LIFE_DOWN = -1;

const int BALL_LIFE_SHOW_COUNT = 100;

static bool gameFlag = true;

+(uint32_t)blockCategory{
    return blockCategory;
}

+(NSString*)blockCategoryName{
    return blockCategoryName;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self initGame];
        
        SKSpriteNode* background = [SKSpriteNode spriteNodeWithImageNamed:@"bg.png"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
        
        self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
        
        // 1 Create an physics body that borders the screen
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(self.frame.origin.x, self.frame.origin.y - 50, self.frame.size.width, self.frame.size.height + 50)];
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody;
        // 3 Set the friction of that physicsBody to 0
        self.physicsBody.friction = 0.0f;
        

        
        paddle = [[SKSpriteNode alloc] initWithImageNamed: @"paddle.png"];
        paddle.name = paddleCategoryName;
        paddleOriginalSize = paddle.size;
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 0.6f);
        [self addChild:paddle];
        
        paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
//        paddle.physicsBody.restitution = 0.1f;
//        paddle.physicsBody.friction = 0.4f;
        paddle.physicsBody.restitution = 1.0f;
        paddle.physicsBody.friction = 0.0f;
        // make physicsBody static
        paddle.physicsBody.dynamic = NO;
        
        [self resetBall];
        
        //        CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y - ball.size.height, self.frame.size.width, 1);
        SKNode* bottom = [SKNode node];
        bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
        [self addChild:bottom];
        
        bottom.physicsBody.categoryBitMask = bottomCategory;
        
        paddle.physicsBody.categoryBitMask = paddleCategory;
        
        
        
        self.physicsWorld.contactDelegate = self;
        
        // 1 Store some useful variables
        int numberOfBlocks = 3;
        int blockWidth = [SKSpriteNode spriteNodeWithImageNamed:@"block.png"].size.width;
        float padding = 20.0f;
        // 2 Calculate the xOffset
        float xOffset = (self.frame.size.width - (blockWidth * numberOfBlocks + padding * (numberOfBlocks-1))) / 2;
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    if(readyFlag)
        [self shootBall:touchLocation];
    
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node.name isEqualToString: paddleCategoryName]) {
        NSLog(@"Began touch on paddle");
        self.isFingerOnPaddle = YES;
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // 1 Check whether user tapped paddle
    if (self.isFingerOnPaddle) {
        // 2 Get touch location
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        // 3 Get node for paddle
        SKSpriteNode* paddle = (SKSpriteNode*)[self childNodeWithName: paddleCategoryName];
        // 4 Calculate new position along x for paddle
        int paddleX = paddle.position.x + (touchLocation.x - previousLocation.x);
        // 5 Limit x so that the paddle will not leave the screen to left or right
        paddleX = MAX(paddleX, paddle.size.width/2);
        paddleX = MIN(paddleX, self.size.width - paddle.size.width/2);
        // 6 Update position of paddle
        paddle.position = CGPointMake(paddleX, paddle.position.y);
        
        if(readyFlag){
            ball.position = CGPointMake(paddle.position.x, paddle.position.y + paddle.size.height);
        }
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    self.isFingerOnPaddle = NO;
}

- (void)didBeginContact:(SKPhysicsContact*)contact {
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // 3 react to the contact between ball and bottom
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory) {
        //TODO: Replace the log statement with display of Game Over Scene
//        GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:NO];
//        [self.view presentScene:gameOverScene];
        
        if(!gameFlag)
            return;
        
        if (!gameSuccess) {
            int maxLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
            if (maxLevel < MAX_LEVEL && playGameLevel >= maxLevel) {
                int lv = maxLevel + 1;
                [[NSUserDefaults standardUserDefaults] setInteger:lv forKey:@"level"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            BallUtil* ball = firstBody.node;
            if(ballUtils.count<=1 && [ballUtils containsObject:ball]){
//                gameFlag = false;
                [self gameSuccess];
            }else{
                [ballUtils removeObject:ball];
                [ball removeFromParent];
            }
            
             
            return;
        }
        
        [self.gameDelegate showLoseDialog:score];
    }
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == blockCategory) {
//        [secondBody.node removeFromParent];
        BrickUtil * brick = secondBody.node;
        [brick doHitEffect:ball showTimeBrickEffectTime:showTimeBrickEffectTime];
        if(![brick isBrickExist]){
            [brick removeFromParent];
            if(brick.isHitIronBrick){
                clearIronBrickCount++;
            }else{
                clearBrickCount++;
            }
        }
        
        if (!brick.isIronsBrick || brick.isHitIronBrick){
            comboCount++;
        }
        
        EffectUtil* effect = [brick getEffect];
        if ([effect isHasTool]) {
            [toolUtils addObject:[effect getToolObj]];
        }
        
        if ([self isGameWon]) {
//            GameOverScene* gameWonScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:YES];
//            [self.view presentScene:gameWonScene];
            [self gameSuccess];
        }
    }
    
    if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == toolCategory) {
        //TODO: Replace the log statement with display of Game Over Scene
        //        GameOverScene* gameOverScene = [[GameOverScene alloc] initWithSize:self.frame.size playerWon:NO];
        //        [self.view presentScene:gameOverScene];
        
        self.scene.paused = YES;
    }
    
    if(firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == paddleCategory){
        comboCount = -1;
        comboScoreCount = 0;
    }
    
}

-(BOOL) isGameWon {
    int numberOfBricks = 0;
    for (SKNode* node in self.children) {
        if ([node.name isEqual: blockCategoryName]) {
            numberOfBricks++;
        }
    }
    return numberOfBricks <= 0;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    SKNode* ball = [self childNodeWithName: ballCategoryName];
    static int maxSpeed = 1000;
    float speed = sqrt(ball.physicsBody.velocity.dx*ball.physicsBody.velocity.dx + ball.physicsBody.velocity.dy * ball.physicsBody.velocity.dy);
    if (speed > maxSpeed) {
        ball.physicsBody.linearDamping = 0.4f;
    } else {
        ball.physicsBody.linearDamping = 0.0f;
    }
    
    [self checkGameTime];
    
    if(!gameFlag)
        return;
    
    for (int i = 0; i < toolUtils.count; i++) {
        ToolUtil* tool = toolUtils[i];
        [tool moveDownToolObj];
        if (tool.position.y < 0) {
            [toolUtils removeObjectAtIndex:i];
            i--;
        }
    }
    
    [self checkHitTool];
    
    [self drawToolEffectTime];
    [self drawTimeBrickEffectTime];
    
//    [self drawBallLifeChange];
    
    
    
    [self checkGameEnd];
}

-(void)checkHitTool{
    bool isHit = false;
    for (int i = 0; i < toolUtils.count; i++) {
        ToolUtil* tool = toolUtils[i];
        for(BallUtil* ball in ballUtils){
            if(CGRectIntersectsRect(ball.calculateAccumulatedFrame, tool.calculateAccumulatedFrame)){
                [tool doTool:ballUtils ball:ball showToolEffectTime:showToolEffectTime];
                [tool removeFromParent];
                [toolUtils removeObjectAtIndex:i];
                isHit = true;
                break;
            }
        }
        if(isHit){
            break;
        }
    }
}

-(void)drawToolEffectTime{
    int effectItemWidth = 20, effectItemHeight = 20;
    for (int i = 0; i < showToolEffectTime.count; i++) {
        TimerThread *timerThread = [showToolEffectTime[i]
         getToolTimerThread ];
        int time = [timerThread getCurrentTime];
        SKTexture* toolEffectIcon = [((ToolUtil*)showToolEffectTime[i]) getToolBitmap];

        int toolEffectIconWidth = effectItemWidth;
        int toolEffectIconHeight = effectItemHeight + 10;
        SKTexture* toolEffectTimeTensCountBmp = [self getTimeTexture:time/10];
        SKTexture* toolEffectTimeSingleDigitsCountBmp = [self getTimeTexture:time%10];
        SKTexture* toolEffectTimeBmp = [SKTexture textureWithImageNamed:@"second_s"];
        
        SKSpriteNode * toolEffectIconNode;
        SKSpriteNode * toolEffectTimeTenNode;
        SKSpriteNode * toolEffectTimeSingleNode;
        SKSpriteNode * toolEffectTimeNode;
        
        if(showToolEffectTimeNodes.count>i){
            NSArray * nodes = [showToolEffectTimeNodes objectAtIndex:i];
            toolEffectIconNode = nodes[0];
            toolEffectTimeTenNode = nodes[1];
            toolEffectTimeSingleNode = nodes[2];
            toolEffectTimeNode = nodes[3];
        }else{
            toolEffectIconNode = [SKSpriteNode spriteNodeWithTexture:nil];
            toolEffectTimeTenNode = [SKSpriteNode spriteNodeWithTexture:nil];
            toolEffectTimeSingleNode = [SKSpriteNode spriteNodeWithTexture:nil];
            toolEffectTimeNode = [SKSpriteNode spriteNodeWithTexture:nil];
            
            [self addChild:toolEffectIconNode];
            [self addChild:toolEffectTimeTenNode];
            [self addChild:toolEffectTimeSingleNode];
            [self addChild:toolEffectTimeNode];
            
            NSArray * nodes = [NSArray arrayWithObjects:toolEffectIconNode, toolEffectTimeTenNode, toolEffectTimeSingleNode, toolEffectTimeNode, nil];
            
            [showToolEffectTimeNodes addObject:nodes];
        }

        MyRect* temp = MyRectMake(
                   (int) (widthScreen - toolEffectIconWidth * 4) - 10,
                   (int) (heightScreen/1.5 - THICK_OF_STICK
                          - toolEffectIconHeight * (i + 1) - 50 + 10),
                   (int) (widthScreen - toolEffectIconWidth * 3) - 10,
                   (int) (heightScreen/1.5 - THICK_OF_STICK
                          - toolEffectIconHeight * i - 50));
        CGRect rectToolEffectIcon = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        temp = MyRectMake(
                          (int) (widthScreen - toolEffectIconWidth * 3) - 10,
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * (i + 1) - 50 + 10),
                          (int) (widthScreen - toolEffectIconWidth * 2) - 10,
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * i - 50));
        CGRect rectTensCount = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        temp = MyRectMake(
                          (int) (widthScreen - toolEffectIconWidth * 2) - 10,
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * (i + 1) - 50 + 10),
                          (int) (widthScreen - toolEffectIconWidth) - 10,
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * i - 50));
        CGRect rectSingleDigitsCount = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        temp = MyRectMake(
                          (int) (widthScreen - toolEffectIconWidth) - 10,
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * (i + 1) - 50 + 10),
                          (int) (widthScreen - 10),
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * i - 50));
        CGRect rectToolEffectTime = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        
        toolEffectIconNode.texture = toolEffectIcon;
        toolEffectTimeTenNode.texture = toolEffectTimeTensCountBmp;
        toolEffectTimeSingleNode.texture = toolEffectTimeSingleDigitsCountBmp;;
        toolEffectTimeNode.texture = toolEffectTimeBmp;
        
        toolEffectIconNode.position = rectToolEffectIcon.origin;
        toolEffectTimeTenNode.position = rectTensCount.origin;
        toolEffectTimeSingleNode.position = rectSingleDigitsCount.origin;
        toolEffectTimeNode.position = rectToolEffectTime.origin;
        
        toolEffectIconNode.size = rectToolEffectIcon.size;
        toolEffectTimeTenNode.size = rectTensCount.size;
        toolEffectTimeSingleNode.size = rectTensCount.size;
        toolEffectTimeNode.size = rectToolEffectTime.size;
        
        
        if (time != 0) {
            if (time > 3) {
                
                toolEffectTimeTenNode.texture = toolEffectTimeTensCountBmp;
                toolEffectTimeSingleNode.texture = toolEffectTimeSingleDigitsCountBmp;;
                toolEffectTimeNode.texture = toolEffectTimeBmp;
                
                toolEffectTimeTenNode.position = rectTensCount.origin;
                toolEffectTimeSingleNode.position = rectSingleDigitsCount.origin;
                toolEffectTimeNode.position = rectToolEffectTime.origin;
                
                toolEffectTimeTenNode.size = rectTensCount.size;
                toolEffectTimeSingleNode.size = rectTensCount.size;
                toolEffectTimeNode.size = rectToolEffectTime.size;
            } else {
                
                toolEffectTimeTenNode.texture = toolEffectTimeTensCountBmp;
                toolEffectTimeSingleNode.texture = toolEffectTimeSingleDigitsCountBmp;;
                toolEffectTimeNode.texture = toolEffectTimeBmp;
                
                toolEffectTimeTenNode.position = rectTensCount.origin;
                toolEffectTimeSingleNode.position = rectSingleDigitsCount.origin;
                toolEffectTimeNode.position = rectToolEffectTime.origin;
                
                toolEffectTimeTenNode.size = rectTensCount.size;
                toolEffectTimeSingleNode.size = rectTensCount.size;
                toolEffectTimeNode.size = rectToolEffectTime.size;
            }
        } else {
            float alpha = toolEffectTimeNode.alpha;
            if(alpha>0){
                alpha -=0.05;
                toolEffectIconNode.alpha = alpha;
                toolEffectTimeTenNode.alpha = alpha;
                toolEffectTimeSingleNode.alpha = alpha;
                toolEffectTimeNode.alpha = alpha;
            }else{
                ToolUtil* tool = (ToolUtil*)showToolEffectTime[i];
                [tool doToolFinish];
                
                [showToolEffectTime removeObjectAtIndex:i];
                [showToolEffectTimeNodes removeObjectAtIndex:i];
                
                [toolEffectIconNode removeFromParent];
                [toolEffectTimeTenNode removeFromParent];
                [toolEffectTimeSingleNode removeFromParent];
                [toolEffectTimeNode removeFromParent];
                i--;
            }
        }
    }
}

-(void)drawTimeBrickEffectTime{
    int effectItemWidth = 20, effectItemHeight = 20;
    for (int i = 0; i < showTimeBrickEffectTime.count; i++) {
        TimerThread *timerThread = [showTimeBrickEffectTime[i]
                                    getToolTimerThread];
        int time = [timerThread getCurrentTime];
        SKTexture* toolEffectIcon = bitmapUtil.brick_time_bmp;
        
        int toolEffectIconWidth = effectItemWidth;
        int toolEffectIconHeight = effectItemHeight + 10;
        SKTexture* toolEffectTimeTensCountBmp = [self getTimeTexture:time/10];
        SKTexture* toolEffectTimeSingleDigitsCountBmp = [self getTimeTexture:time%10];
        SKTexture* toolEffectTimeBmp = [SKTexture textureWithImageNamed:@"second_s"];
        
        SKSpriteNode * toolEffectIconNode;
        SKSpriteNode * toolEffectTimeTenNode;
        SKSpriteNode * toolEffectTimeSingleNode;
        SKSpriteNode * toolEffectTimeNode;
        
        if(showTimeBrickEffectTimeNodes.count>i){
            NSArray * nodes = [showTimeBrickEffectTimeNodes objectAtIndex:i];
            toolEffectIconNode = nodes[0];
            toolEffectTimeTenNode = nodes[1];
            toolEffectTimeSingleNode = nodes[2];
            toolEffectTimeNode = nodes[3];
        }else{
            toolEffectIconNode = [SKSpriteNode spriteNodeWithTexture:nil];
            toolEffectTimeTenNode = [SKSpriteNode spriteNodeWithTexture:nil];
            toolEffectTimeSingleNode = [SKSpriteNode spriteNodeWithTexture:nil];
            toolEffectTimeNode = [SKSpriteNode spriteNodeWithTexture:nil];
            
            [self addChild:toolEffectIconNode];
            [self addChild:toolEffectTimeTenNode];
            [self addChild:toolEffectTimeSingleNode];
            [self addChild:toolEffectTimeNode];
            
            NSArray * nodes = [NSArray arrayWithObjects:toolEffectIconNode, toolEffectTimeTenNode, toolEffectTimeSingleNode, toolEffectTimeNode, nil];
            
            [showTimeBrickEffectTimeNodes addObject:nodes];
        }
        
        MyRect* temp = MyRectMake(
                                  0 + toolEffectIconWidth/2 - (-10),
                                  (int) (heightScreen/1.5 - THICK_OF_STICK
                                         - toolEffectIconHeight * (i + 1) - 50 + 10),
                                  0 + toolEffectIconWidth * 2 - (-10),
                                  (int) (heightScreen/1.5 - THICK_OF_STICK
                                         - toolEffectIconHeight * i - 50));
        CGRect rectToolEffectIcon = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        temp = MyRectMake(
                          0 + toolEffectIconWidth * 2
                          - (-10), (int) (heightScreen/1.5 - THICK_OF_STICK
                                          - toolEffectIconHeight * (i + 1) - 50 + 10), 0
                          + toolEffectIconWidth * 3 - (-10),
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * i - 50));
        CGRect rectTensCount = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        temp = MyRectMake(
                          0 + toolEffectIconWidth * 3 - (-10),
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * (i + 1) - 50 + 10),
                          0 + toolEffectIconWidth * 4 - (-10),
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * i - 50));
        CGRect rectSingleDigitsCount = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        temp = MyRectMake(
                          0 + toolEffectIconWidth
                          * 4 - (-10), (int) (heightScreen/1.5 - THICK_OF_STICK
                                              - toolEffectIconHeight * (i + 1) - 50 + 10), 0
                          + toolEffectIconWidth * 5 - (-10),
                          (int) (heightScreen/1.5 - THICK_OF_STICK
                                 - toolEffectIconHeight * i - 50));
        CGRect rectToolEffectTime = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
        
        
        toolEffectIconNode.texture = toolEffectIcon;
        toolEffectTimeTenNode.texture = toolEffectTimeTensCountBmp;
        toolEffectTimeSingleNode.texture = toolEffectTimeSingleDigitsCountBmp;;
        toolEffectTimeNode.texture = toolEffectTimeBmp;
        
        toolEffectIconNode.position = rectToolEffectIcon.origin;
        toolEffectTimeTenNode.position = rectTensCount.origin;
        toolEffectTimeSingleNode.position = rectSingleDigitsCount.origin;
        toolEffectTimeNode.position = rectToolEffectTime.origin;
        
        toolEffectIconNode.size = rectToolEffectIcon.size;
        toolEffectTimeTenNode.size = rectTensCount.size;
        toolEffectTimeSingleNode.size = rectTensCount.size;
        toolEffectTimeNode.size = rectToolEffectTime.size;
        
        
        if (time != 0) {
            if (time > 3) {
                
                toolEffectTimeTenNode.texture = toolEffectTimeTensCountBmp;
                toolEffectTimeSingleNode.texture = toolEffectTimeSingleDigitsCountBmp;;
                toolEffectTimeNode.texture = toolEffectTimeBmp;
                
                toolEffectTimeTenNode.position = rectTensCount.origin;
                toolEffectTimeSingleNode.position = rectSingleDigitsCount.origin;
                toolEffectTimeNode.position = rectToolEffectTime.origin;
                
                toolEffectTimeTenNode.size = rectTensCount.size;
                toolEffectTimeSingleNode.size = rectTensCount.size;
                toolEffectTimeNode.size = rectToolEffectTime.size;
            } else {
                
                toolEffectTimeTenNode.texture = toolEffectTimeTensCountBmp;
                toolEffectTimeSingleNode.texture = toolEffectTimeSingleDigitsCountBmp;;
                toolEffectTimeNode.texture = toolEffectTimeBmp;
                
                toolEffectTimeTenNode.position = rectTensCount.origin;
                toolEffectTimeSingleNode.position = rectSingleDigitsCount.origin;
                toolEffectTimeNode.position = rectToolEffectTime.origin;
                
                toolEffectTimeTenNode.size = rectTensCount.size;
                toolEffectTimeSingleNode.size = rectTensCount.size;
                toolEffectTimeNode.size = rectToolEffectTime.size;
            }
        } else {
            float alpha = toolEffectTimeNode.alpha;
            if(alpha>0){
                alpha -=0.05;
                toolEffectIconNode.alpha = alpha;
                toolEffectTimeTenNode.alpha = alpha;
                toolEffectTimeSingleNode.alpha = alpha;
                toolEffectTimeNode.alpha = alpha;
            }else{
//                ToolUtil* tool = (ToolUtil*)showToolEffectTime[i];
//                [tool doToolFinish];
                [((EffectUtil*)showTimeBrickEffectTime[i]) doEffectFinish:ballUtils];
                
                [showTimeBrickEffectTime removeObjectAtIndex:i];
                [showTimeBrickEffectTimeNodes removeObjectAtIndex:i];
                
                [toolEffectIconNode removeFromParent];
                [toolEffectTimeTenNode removeFromParent];
                [toolEffectTimeSingleNode removeFromParent];
                [toolEffectTimeNode removeFromParent];
                i--;
            }
        }
    }
}

-(void) initBallLifeNode{
    ballLifeNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", ballLife]];
    ballLifeNode.position = CGPointMake(280, 0);
    [self addChild:ballLifeNode];
}

-(void) initBallLifeChangeNodes{
    ballIconNode = [SKSpriteNode spriteNodeWithTexture:nil];
    ballCHangeLabelNode = [SKLabelNode labelNodeWithText:@"011"];
    ballIconNode.position = CGPointMake(ballLifeNode.position.x - 25, ballLifeNode.position.y);
//    ballCHangeLabelNode.position = CGPointMake(130, 200);
    ballCHangeLabelNode.position = ballLifeNode.position;
    
    ballIconNode.zPosition = 1;
    ballCHangeLabelNode.zPosition = 1;
    ballIconNode.anchorPoint = CGPointMake(0.5, 0);
    ballIconNode.alpha = 0;
    ballCHangeLabelNode.alpha = 0;
    ballCHangeLabelNode.fontColor = [UIColor redColor];
    [self addChild:ballIconNode];
    [self addChild:ballCHangeLabelNode];
}

//-(void) drawBallLifeChange{
//    SKTexture* ballShowBmp = bitmapUtil.ball_Show_bmp;
////    Rect rectShowBall = new Rect(0, 0, 0, 0);
//    int ballLifeShowBmpCount = 0;
//    NSString* textToDraw;
//    if (ballLifeChange == BALL_LIFE_UP) {
//        textToDraw = @" + 1";
//    } else {
//        textToDraw = @" - 1";
//    }
//    
//    SKLabelNode* labelNode = [SKLabelNode labelNodeWithText:textToDraw];
//    labelNode.fontSize = 15;
//    labelNode.fontColor = [UIColor greenColor];
//    
//    MyRect* temp = MyRectMake((int) widthScreen - ballShowBmp.size.width / 2,
//                              (int) heightScreen - ballShowBmp.size.height
//                              - THICK_OF_STICK - 50 - ballLifeShowBmpCount,
//                              (int) (widthScreen - ballShowBmp.size.width/2) + ballShowBmp.size.width,
//                              (int) (heightScreen - THICK_OF_STICK - 50)
//                              - ballLifeShowBmpCount);
//    CGRect rectShowBall = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
//    
////    canvas.drawBitmap(ballShowBmp, null, rectShowBall, null);
//    ballIconNode.texture = ballShowBmp;
//    ballIconNode.size = ballShowBmp.size;
//    
//    labelNode.position = rectShowBall.origin;
//    [self addChild:labelNode];
//}

-(void)initGameTimeNode{
    gameTimeHundredsCountNode = [SKSpriteNode spriteNodeWithTexture:nil];
    gameTimeTensCountNode = [SKSpriteNode spriteNodeWithTexture:nil];
    gameTimeSingleDigitsCountNode = [SKSpriteNode spriteNodeWithTexture:nil];
    gameTimeNode = [SKSpriteNode spriteNodeWithTexture:nil];
    
    [self addChild:gameTimeHundredsCountNode];
    [self addChild:gameTimeTensCountNode];
    [self addChild:gameTimeSingleDigitsCountNode];
    [self addChild:gameTimeNode];
}

-(void) checkGameTime {
    
    CGSize timeTextureSize = CGSizeMake(30, 30);
    
    MyRect* temp = MyRectMake(0, 0 + 60,
                              timeTextureSize.width,
                              timeTextureSize.height + 60);
    CGRect rectHundredsCount = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
    
    temp = MyRectMake(timeTextureSize.width, 0 + 60,
                      timeTextureSize.width * 2,
                      timeTextureSize.height + 60);
    
    CGRect rectTensCount = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
    
    temp = MyRectMake(
                      timeTextureSize.width * 2, 0 + 60,
                      timeTextureSize.width * 3,
                      timeTextureSize.height + 60);
    CGRect rectSingleDigitsCount = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
    
    temp = MyRectMake(timeTextureSize.width * 3,
                      0 + 60, timeTextureSize.width * 4,
                      timeTextureSize.height + 60);
    CGRect rectgameTime = CGRectMake(temp.left, temp.top, temp.right - temp.left, temp.bottom - temp.top);
    
//    if (waitGameSuccessProcessing) {
//        wait(100);
//        sleep(0.2f);
//        count--;
        [self countScore];
//    }
    
//    if (count >= 100) {
//        gameTimeHundredsCountBmp = BitmapFactory.decodeResource(
//                                                                getResources(), R.drawable.second_1);
//    }
    
    SKTexture* gameTimeHundredsCountBmp = [self getTimeTexture:count/100%10];
    SKTexture* gameTimeTensCountBmp = [self getTimeTexture:count/10%10];
    SKTexture* gameTimeSingleDigitsCountBmp = [self getTimeTexture:count%10];
    SKTexture* gameTimeBmp = [SKTexture textureWithImageNamed:@"second_s"];
    
    gameTimeHundredsCountNode.texture = gameTimeHundredsCountBmp;
    gameTimeTensCountNode.texture = gameTimeTensCountBmp;
    gameTimeSingleDigitsCountNode.texture = gameTimeSingleDigitsCountBmp;;
    gameTimeNode.texture = gameTimeBmp;
    
    gameTimeHundredsCountNode.position = rectHundredsCount.origin;
    gameTimeTensCountNode.position = rectTensCount.origin;
    gameTimeSingleDigitsCountNode.position = rectSingleDigitsCount.origin;
    gameTimeNode.position = rectgameTime.origin;
    
    gameTimeHundredsCountNode.size = rectHundredsCount.size;
    gameTimeTensCountNode.size = rectTensCount.size;
    gameTimeSingleDigitsCountNode.size = rectSingleDigitsCount.size;
    gameTimeNode.size = rectgameTime.size;
    
    if(count==CHANGE_MUSIC_TIME && !waitGameSuccessProcessing){
//        AudioUtil.pauseMusic();
//        AudioUtil.playMusic(R.raw.time_count_music);
    }
    
    if (count <= 0 && isFirstDoGameFinish) {
        isFirstDoGameFinish = false;
        if (waitGameSuccessProcessing) {
            waitGameSuccessProcessing = false;
//            handler.sendEmptyMessage(0);
//            showGameSuccess();
//            [self.gameDelegate showWinDialog];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self showWinView];
            });
            
        }
        
//        else {
////            gameOver();
////            [self.gameDelegate showLoseDialog:score];
//            [self gameOver];
//        }
    }
}

-(void) gameSuccess {
//    AudioUtil.pauseMusic();
//    AudioUtil.playMusic(R.raw.v2);
//    isGameFinish = true;
    gameFlag = false;
    waitGameSuccessProcessing = true;
    lastTimeCount = count;
    [self setPaused:true];
//    paddle.userInteractionEnabled = false;
//    [self.gameDelegate showWinDialog];
}

-(void) showWinView{
    [self.gameDelegate showWinDialog];
}

-(void) gameOver {
//    AudioUtil.pauseMusic();
//    AudioUtil.playMusic(R.raw.gameover_music);
//    isGameFinish = true;
    gameFlag = false;
//    handler.sendEmptyMessage(1);
    [self.gameDelegate showLoseDialog:score];
    [self setPaused:true];
}

-(void)checkGameEnd{
    for (int ballNum = 0; ballNum < ballUtils.count; ballNum++) {
        BallUtil* ball = ballUtils[ballNum];
        ballLevel = [ball getBallLevel];

        RADIUS = ball.size.width/2;
        
        
       
//        for (int i = 0; i < N; i++) {
//            for (int j = 0; j < N; j++) {
//                if (!rBrick[i][j].isBrickExist) {
//                    if(rBrick[i][j].isHitIronBrick){
//                        clearIronBrickCount++;
//                    }else{
//                        clearBrickCount++;
//                    }
//                    iNumBricks--;
//                }
//                if (!rBrick[i][j].isIronsBrick || rBrick[i][j].isHitIronBrick){
//                    comboCount++;
//                }
//                
//                bRbOn[i][j] = rBrick[i][j].isBrickExist;
//            }
//        }

        
        
        if (ballLevel <= -1) {
            [ballUtils removeObjectAtIndex:ballNum];
            ballNum--;
            [ball removeFromParent];
            
            if (ballUtils.count == 0) {
//                setBallLife(ballLife - 1);
                [self setBallLife:ballLife-1];
//                resetBall();
//                [self reset];
                if (ballLife < 0) {
//                    gameOver();
                    [self gameOver];
                }else{
                    [self resetBall];
                    [self setReadyAlertBox:true];
                }
                return;
            }
        }
        if (iNumBricks == 0) {
//            gameSuccess();
            [self gameSuccess];
            return;
        } else if (ballLife < 0) {
//            gameOver();
            [self gameOver];
            return;
        }
    }

}

-(void) submitScore:(bool) isGameSuccess {
//    if(isGameSuccess)
//        win
//    else
//        lose
   
}

int increaseScroe = 0;
int lastTimeCount;

-(void) countScore {
    
    if (!waitGameSuccessProcessing) {
        increaseScroe += hitIronBrickLevelDownCount * BRICK_IRON_LEVEL_DOWN_SCORE;
        increaseScroe += hitBrickLevelDownCount * BRICK_LEVEL_DOWN_SCORE;
        increaseScroe += clearBrickCount * BRICK_CLEAR_SCORE;
        increaseScroe += clearIronBrickCount * BRICK_IRON_CLEAR_SCORE;
        increaseScroe += (comboCount - comboScoreCount) * BRICK_COMBO_SCORE > 0 ? comboCount
        * BRICK_COMBO_SCORE
        : 0;
        score += increaseScroe;
        if(comboCount>0){
            ;
        }
            
    } else {
        sleep(0.2f);
        count--;
        
        increaseScroe += ((lastTimeCount - count) * 100);
//        Log.e("s", lastTimeCount + ":" + count + ":" + increaseScroe);
        score += 100;
    }
    
    scroeTextView.text = [NSString stringWithFormat:@"%d", score];
    if (increaseScroe != 0){
        if([increaseScroeTextView hasActions]){
            [increaseScroeTextView removeAllActions];
            increaseScroeTextView.alpha = 1;
            increaseScroeTextView.position = CGPointMake(scroeTextView.position.x, scroeTextView.position.y + 30);
            return;
        }
        
        increaseScroeTextView.position = scroeTextView.position;
        increaseScroeTextView.alpha = 0;
        
        increaseScroeTextView.text = [NSString stringWithFormat:@"%d", increaseScroe];
        increaseScroe = 0;
        SKAction* move = [SKAction moveByX:0 y:3 duration:0.1];
        SKAction* alpha = [SKAction runBlock:^{
            increaseScroeTextView.alpha += 0.1;
        }];
//        SKAction* wait = [SKAction waitForDuration:0.1];
        SKAction* increaseScoreAction = [SKAction repeatAction:[SKAction sequence:@[alpha, move]] count:10];
        SKAction* end = [SKAction runBlock:^{
            increaseScroeTextView.alpha = 0;
            increaseScroeTextView.position = scroeTextView.position;
        }];
        [increaseScroeTextView runAction:[SKAction sequence:@[increaseScoreAction, end]]];
    }
    
    hitIronBrickLevelDownCount = 0;
    hitBrickLevelDownCount = 0;
    clearBrickCount = 0;
    clearIronBrickCount = 0;
    if (comboCount > 0) {
        comboScoreCount = comboCount;
        //combo animation
    }
    
}


////////////////////////////////////

-(void)initGame{
//    bRbOn = bool[1][1];
//    rBrick = BrickUtil[N][N];
    comboCount = -1;
    count = GAME_TIME;
    ballLife = ballInitLife;
    isFirstDoGameFinish = true;
    isBallLifeChange = false;
    ballLifeShowBmpCount = BALL_LIFE_SHOW_COUNT;
    ball_isRun = true;
    gameFlag = true;
    [self initReadyAlertBox];
    
    bitmapUtil = [BitmapUtil sharedInstance];
    
    ballViewConfig = [BallViewConfig sharedInstance];
    ballViewConfig.gameFlag = true;
    ballViewConfig.waitGameSuccessProcessing = false;
    ballViewConfig.GAME_PAUSE_FLAG = false;
    toolUtils = [NSMutableArray array];
    ballUtils = [NSMutableArray array];
    showToolEffectTime  = [NSMutableArray array];
    showTimeBrickEffectTime  = [NSMutableArray array];
    showToolEffectTimeNodes = [NSMutableArray array];
    showTimeBrickEffectTimeNodes = [NSMutableArray array];
    
    colors = @[ @[ [UIColor redColor], [UIColor magentaColor], [UIColor yellowColor] ],
                    @[ [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor] ],
                @[ [UIColor blackColor], [UIColor darkGrayColor], [UIColor grayColor] ] ];
    
    scroeTextView = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", score]];
    scroeTextView.position = CGPointMake(100, 10);
    [self addChild:scroeTextView];
    increaseScroeTextView = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", increaseScroe]];
    increaseScroeTextView.position = scroeTextView.position;
    [self addChild:increaseScroeTextView];
    increaseScroeTextView.alpha = 0;
    increaseScroeTextView.fontColor = [UIColor redColor];

    
    
    [self initBallLifeNode];
    [self initBallLifeChangeNodes];
    [self initGameTimeNode];
//    toolEffectTimeTenNode = [];
//    toolEffectTimeTenNode
}

-(void)initTimer{
    if(timer==nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count) userInfo:nil repeats:YES];
    }
}

-(void)count{
    if(!gameFlag){
        [timer invalidate];
        timer = nil;
    }
    
    if(self.paused){
        return;
    }
    
    if(count<0){
        [self gameOver];
        return;
    }
    
//    while (ball_isRun) {
//        while (gameFlag) {
//            sleep(1);
            if (gameFlag && !waitGameSuccessProcessing) {
                count--;
            } else if(waitGameSuccessProcessing){
                ball_isRun = false;
                //                    break end;
                [self gameOver];
            }
            
//        }
//    }
}

+(id)initWithSize:(CGSize)size playGameLevel:(int)playGameLevel withViewController:(ViewController*)viewcontroller{
    
    MyScene * scene = [MyScene sceneWithSize:size];
    
        /* Setup your scene here */

        scene->playGameLevel = playGameLevel;
        
        scene->iNumBricks = N * N;
        
        scene->widthScreen = size.width;
        scene->heightScreen = size.height;
    
        [[BrickMaxConfig sharedInstance] setBrickMaxConfigEnable:true PlayGameLevel:playGameLevel];
    
        // 磚塊初始化
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                scene->bRbOn[i][j] = true;
                // rBrick[i][j] = new Rect();
                scene->rBrick[i][j] = [BrickUtil initWithBallView:scene];
                [scene addChild:scene->rBrick[i][j]];
                [scene->rBrick[i][j] setPlayGameLevel:playGameLevel Left:(int) scene->widthScreen * j / N Top: scene->heightScreen - (int) scene->heightScreen * i / N / 3  Right: (int) scene->widthScreen
                 * (j + 1) / N Bottom: scene->heightScreen - (int) scene->heightScreen * (i + 1) / N
                 / 3];
            }
        }
        
        NSLog(@"ImageCollisionV2:%d, %d, %d, %d", (int) (scene->widthScreen / 3), (int) (scene->heightScreen - THICK_OF_STICK), (int) (scene->widthScreen * 2 / 3), (int) (scene->heightScreen - 1));
        
//        AudioUtil.playMusic(R.raw.game_main_music);
        scene->ballViewConfig = [BallViewConfig sharedInstance];
        scene->ballViewConfig.waitGameSuccessProcessing = false;
    
    return scene;
}

-(void)onSizeChanged{
    int w = self.frame.size.width;
    int h = self.frame.size.height;
    widthScreen = w;
    heightScreen = h;

}

-(void)initReadyAlertBox{
    readyFlag = true;
    readyAlertBox = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"cn_TapToStart"] size:CGSizeMake(80, 50)];
    readyAlertBox.position = CGPointMake(self.frame.size.width/2, 100);
    readyAlertBox.anchorPoint = CGPointMake(0.5, 0);
    readyAlertBox.zPosition = 1;
    [self addChild:readyAlertBox];
}

-(void)setReadyAlertBox:(BOOL) willChangeToReady{
    readyFlag = willChangeToReady;
    if(readyFlag){
        readyAlertBox.hidden = NO;
    }else{
        readyAlertBox.hidden = YES;
    }
}

-(void)shootBall:(CGPoint)touchPoint{
    float length = sqrt(10*10+10*10);
    float radians = [self pointPairToBearingRadians:ball.position secondPoint:touchPoint];
    
    float vX = cosf(radians)*length;
    float vY = sinf(radians)*length;
    [ball.physicsBody applyImpulse:CGVectorMake(vX, vY)];
//    [ball.physicsBody applyImpulse:CGVectorMake(10, -10)];
    [self setReadyAlertBox:false];
    
    [self initTimer];
}

-(void)resetBall{
//    showTimeBrickEffectTime.clear();
//    showToolEffectTime.clear();
    for (int i = 0; i < showToolEffectTime.count; i++) {
        SKSpriteNode * toolEffectIconNode;
        SKSpriteNode * toolEffectTimeTenNode;
        SKSpriteNode * toolEffectTimeSingleNode;
        SKSpriteNode * toolEffectTimeNode;

        NSArray * nodes = [showToolEffectTimeNodes objectAtIndex:i];
        toolEffectIconNode = nodes[0];
        toolEffectTimeTenNode = nodes[1];
        toolEffectTimeSingleNode = nodes[2];
        toolEffectTimeNode = nodes[3];
        
        [showToolEffectTime removeObjectAtIndex:i];
        [showToolEffectTimeNodes removeObjectAtIndex:i];
        
        [toolEffectIconNode removeFromParent];
        [toolEffectTimeTenNode removeFromParent];
        [toolEffectTimeSingleNode removeFromParent];
        [toolEffectTimeNode removeFromParent];
        i--;
    }
    
    for (int i = 0; i < showTimeBrickEffectTime.count; i++) {
        SKSpriteNode * toolEffectIconNode;
        SKSpriteNode * toolEffectTimeTenNode;
        SKSpriteNode * toolEffectTimeSingleNode;
        SKSpriteNode * toolEffectTimeNode;
        
        NSArray * nodes = [showTimeBrickEffectTimeNodes objectAtIndex:i];
        toolEffectIconNode = nodes[0];
        toolEffectTimeTenNode = nodes[1];
        toolEffectTimeSingleNode = nodes[2];
        toolEffectTimeNode = nodes[3];
        
        [showTimeBrickEffectTime removeObjectAtIndex:i];
        [showTimeBrickEffectTimeNodes removeObjectAtIndex:i];
        
        [toolEffectIconNode removeFromParent];
        [toolEffectTimeTenNode removeFromParent];
        [toolEffectTimeSingleNode removeFromParent];
        [toolEffectTimeNode removeFromParent];
        i--;
    }
    
    // 1
    //        SKSpriteNode* ball = [SKSpriteNode spriteNodeWithImageNamed: @"ball.png"];
    // 固定產生球的位置於擊板的上方
    
    imageX = widthScreen / 2;
    imageY = ((int) heightScreen) - THICK_OF_STICK - RADIUS - 1;// -1避免一開始就處於碰撞狀態
    
    for(BallUtil* ballUtil in ballUtils){
        [ballUtil removeFromParent];
    }
    [ballUtils removeAllObjects];
    ball = [BallUtil initBallUtil:0 speedX:speedX speedY:speedY imageX:imageX imageY:imageY fAngle:fAngle RADIUS:RADIUS];
    [ballUtils addObject:ball];
    
    ball.name = ballCategoryName;
    //        ball.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3);
    ball.position = CGPointMake(paddle.position.x, paddle.position.y + paddle.size.height);
    //        ball.size = CGSizeMake(50, 50);
    [self addChild:ball];
    
    // 2
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    // 3
    ball.physicsBody.friction = 0.0f;
    // 4
    ball.physicsBody.restitution = 1.0f;
    // 5
    ball.physicsBody.linearDamping = 0.0f;
    // 6
    ball.physicsBody.allowsRotation = NO;
    
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = bottomCategory | blockCategory | paddleCategory;
    //        [ball.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
    //shoot
    
    hitIronBrickLevelDownCount = 0;
    hitBrickLevelDownCount = 0;
    clearBrickCount = 0;
    clearIronBrickCount = 0;
    comboCount = -1;
    comboScoreCount = 0;
    
    paddle.size = paddleOriginalSize;
}

- (CGFloat) pointPairToBearingRadians:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    return bearingRadians;
}

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}


    
-(SKTexture*)getTimeTexture:(int)time{
    SKTexture* texture;
    switch (time) {
        case 0:
            texture = [bitmapUtil timeTextures][0];
            break;
        case 1:
            texture = [bitmapUtil timeTextures][1];
            break;
        case 2:
            texture = [bitmapUtil timeTextures][2];
            break;
        case 3:
            texture = [bitmapUtil timeTextures][3];
            break;
        case 4:
            texture = [bitmapUtil timeTextures][4];
            break;
        case 5:
            texture = [bitmapUtil timeTextures][5];
            break;
        case 6:
            texture = [bitmapUtil timeTextures][6];
            break;
        case 7:
            texture = [bitmapUtil timeTextures][7];
            break;
        case 8:
            texture = [bitmapUtil timeTextures][8];
            break;
        case 9:
            texture = [bitmapUtil timeTextures][9];
            break;
            //        default:
            //            texture = [self getTimeTexture:time/10];
            //            break;
    }
    return texture;
}

-(int)getBallLevel{
    return ballLevel;
}

-(void)setStickLong:(float)stickLong{
   SKSpriteNode* paddle = (SKSpriteNode*)[self childNodeWithName: paddleCategoryName];
    paddle.size = CGSizeMake(stickLong, paddle.size.height);
    
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
    paddle.physicsBody.restitution = 1.0f;
    paddle.physicsBody.friction = 0.0f;
    // make physicsBody static
    paddle.physicsBody.dynamic = NO;
    paddle.physicsBody.categoryBitMask = paddleCategory;
    //        paddle.physicsB
}

-(float)getStickLong{
    SKSpriteNode* paddle = (SKSpriteNode*)[self childNodeWithName: paddleCategoryName];
    return paddle.size.width;
}

-(void) setBallLife:(int) life {
//    ballLife = life;
    ballLifeChange = ballLife;
    ballLife = life;
    if (ballLife > ballLifeChange) {
        ballLifeShowBmpCount = BALL_LIFE_SHOW_COUNT;
        isBallLifeChange = true;
        ballLifeChange = BALL_LIFE_UP;
    } else if (ballLife < ballLifeChange) {
        ballLifeShowBmpCount = BALL_LIFE_SHOW_COUNT;
        isBallLifeChange = true;
        ballLifeChange = BALL_LIFE_DOWN;
    }
    NSString *changeBallLifeString;
    if (ballLifeChange >= 0)
        changeBallLifeString = [NSString stringWithFormat:@" +%d", ballLifeChange];
    else
        changeBallLifeString = [NSString stringWithFormat:@" %d", ballLifeChange];
    
    ballCHangeLabelNode.text = changeBallLifeString;
    // animationSet2.startNow();
//    changeBallLifeTextView.startAnimation(animationSet2);
    SKAction* move = [SKAction moveByX:0 y:3 duration:0.1];
    SKAction* alpha = [SKAction runBlock:^{
        ballCHangeLabelNode.alpha += 0.1;
    }];
    //        SKAction* wait = [SKAction waitForDuration:0.1];
    SKAction* increaseScoreAction = [SKAction repeatAction:[SKAction sequence:@[alpha, move]] count:10];
    SKAction* end = [SKAction runBlock:^{
        ballCHangeLabelNode.alpha = 0;
        ballCHangeLabelNode.position = ballLifeNode.position;
    }];
    [ballCHangeLabelNode runAction:[SKAction sequence:@[increaseScoreAction, end]]];
    
    [self ballIconNodeAnimation];
    
    ballLifeNode.text = [NSString stringWithFormat:@"%d", ballLife];
}

-(void)ballIconNodeAnimation{
    SKAction* move = [SKAction moveByX:0 y:3 duration:0.1];
    SKAction* alpha = [SKAction runBlock:^{
        ballIconNode.alpha += 0.1;
    }];
    //        SKAction* wait = [SKAction waitForDuration:0.1];
    SKAction* increaseScoreAction = [SKAction repeatAction:[SKAction sequence:@[alpha, move]] count:10];
    SKAction* end = [SKAction runBlock:^{
        ballIconNode.alpha = 0;
        ballIconNode.position = CGPointMake(ballLifeNode.position.x - 20, ballLifeNode.position.y);;
    }];
    [ballIconNode runAction:[SKAction sequence:@[increaseScoreAction, end]]];
}

-(int) getBallLife {
    return ballLife;
}

@end
