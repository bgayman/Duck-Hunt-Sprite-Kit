//
//  DuckHuntMyScene.m
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntMyScene.h"
#import "DuckHuntGame.h"
#import "DuckHuntDog.h"
#import "DuckHuntDuck.h"
#import "DuckHuntBullet.h"
#import "DuckHuntGameOverScene.h"

#define ARC4RANDOM_MAX 0x100000000
#define DUCKWAVETIME 10

@interface DuckHuntMyScene() <SKPhysicsContactDelegate>

@property (nonatomic, strong) DuckHuntGame *game;
@property (nonatomic, strong) DuckHuntDog *dog;
@property (nonatomic, strong) DuckHuntDog *dogBehindBushes;
@property (nonatomic, strong) SKNode *ducks;
@property (nonatomic, strong) SKNode *bullets;
@property (nonatomic, strong) SKNode *shots;
@property (nonatomic, strong) SKNode *duckCount;
@property (nonatomic, strong) SKSpriteNode *sky;
@property (nonatomic, strong) SKLabelNode *score;
@property (nonatomic, strong) SKLabelNode *level;
@property (nonatomic, strong) SKLabelNode *countdown;
@property (nonatomic, strong) NSTimer *waveTimer;
@property (nonatomic, readwrite) int waveCountdown;
@end

@implementation DuckHuntMyScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:250.0/255.0 green:181.0/255.0 blue:212.0/255.0 alpha:1.0];
        
        SKSpriteNode *sky = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:104.0/255.0 green:178.0/255.0 blue:252.0/255.0 alpha:1.0] size:self.frame.size];
        sky.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.sky = sky;
        [self addChild:self.sky];
        
        self.ducks = [SKNode node];
        [self addChild:self.ducks];
        
        self.shots = [SKNode node];
        [self addChild:self.shots];
        
        SKSpriteNode *tree = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"tree"]]];
        tree.position = CGPointMake(tree.frame.size.width *0.5f, tree.frame.size.height*0.5 + 100.0f);
        [self addChild:tree];
        
        DuckHuntDog *dogBehindBushes = [DuckHuntDog node];
        dogBehindBushes.position = CGPointZero;
        self.dogBehindBushes = dogBehindBushes;
        [self addChild:self.dogBehindBushes];
        
        
        SKSpriteNode *bushes = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"back.png"]]];
        bushes.position = CGPointMake(bushes.frame.size.width*0.5f, bushes.frame.size.height * 0.5f);
        [self addChild:bushes];
        
        DuckHuntDog *dog = [DuckHuntDog node];
        dog.position = CGPointMake(dog.frame.size.width * -0.5f, dog.frame.size.height * 0.5f + 70.0f);
        self.dog = dog;
        [self addChild:self.dog];
        
        self.game = [[DuckHuntGame alloc]init];
        
        [self dogOpenningAnimation];
        
        SKLabelNode *level = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        level.fontSize =16.0;
        level.fontColor = [SKColor lightTextColor];
        level.name = @"LevelLabel";
        level.text = [NSString stringWithFormat:@"Level: %i",self.game.level];
        level.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        level.position = CGPointMake(self.frame.size.width, self.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height);
        self.level = level;
        [self addChild:self.level];
        
        SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        score.fontSize =16.0;
        score.fontColor = [SKColor lightTextColor];
        score.name = @"ScoreLabel";
        score.text = [NSString stringWithFormat:@"Score: %i",self.game.score];
        score.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        score.position = CGPointMake(0.0, self.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height);
        self.score = score;
        [self addChild:self.score];
        
        SKNode *bullets = [SKNode node];
        self.bullets = bullets;
        [self addChild:self.bullets];
        [self updateBulletCount];
        //self.physicsWorld.gravity = CGVectorMake(0, -1);
        
        self.physicsWorld.contactDelegate = self;
        
        SKNode *duckCount = [SKNode node];
        self.duckCount = duckCount;
        [self addChild:self.duckCount];
        [self updateDuckCount];
        
        self.waveTimer = [[NSTimer alloc]init];
        self.waveCountdown = DUCKWAVETIME;
        SKLabelNode *countdown = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        countdown.fontSize = 16.0;
        countdown.fontColor = [SKColor lightTextColor];
        countdown.name = @"CountdownLabel";
        countdown.text = [NSString stringWithFormat:@"%i",self.waveCountdown];
        countdown.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        countdown.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        countdown.position = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-2.0);
        self.countdown = countdown;
        [self addChild:self.countdown];

    }
    return self;
}

-(void) dogOpenningAnimation
{
    SKAction *opening = [SKAction playSoundFileNamed:@"start.mp3" waitForCompletion:NO];
    self.dog.alpha = 1.0;
    [self runAction:opening];
    [self nextLevel];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"dogSniff"];
    SKTexture *f1 = [atlas textureNamed:@"dogSniff1.png"];
    SKTexture *f2 = [atlas textureNamed:@"dogSniff2.png"];
    SKTexture *f3 = [atlas textureNamed:@"dogSniff3.png"];
    SKTexture *f4 = [atlas textureNamed:@"dogSniff4.png"];
    SKTexture *f5 = [atlas textureNamed:@"dogSniff5.png"];
    NSArray *dogSniffTextures = @[f1,f2,f3,f4,f5];
    
    SKAction *sniffAnimation = [SKAction animateWithTextures:dogSniffTextures timePerFrame:0.2 resize:NO restore:YES];
    SKAction *sniffRepeat = [SKAction repeatActionForever:sniffAnimation];
    [self.dog.textureSprite runAction:sniffRepeat withKey:@"Sniff"];
    SKAction *moveOver = [SKAction moveByX:self.frame.size.width*0.5f y:0.0f duration:2.55];
    [self.dog runAction:moveOver completion:^{
        
        [self.dog.textureSprite removeActionForKey:@"Sniff"];
        
        self.dog.textureSprite.texture = [atlas textureNamed:@"dogSniff6.png"];
        SKAction *pause = [SKAction waitForDuration:1.0];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"dogJump"];
        SKTexture *f1 = [atlas textureNamed:@"dogJump1.png"];
        SKTexture *f2 = [atlas textureNamed:@"dogJump2.png"];
        NSArray *dogJumpTextures = @[f1,f2];
        
        SKAction *jumpAnimation = [SKAction animateWithTextures:dogJumpTextures timePerFrame:0.5];
        SKAction *jumpSequence = [SKAction sequence:@[pause,jumpAnimation]];
        [self.dog.textureSprite runAction:jumpSequence];
        SKAction *moveUp = [SKAction moveByX:0.0 y:100.0 duration:0.5];
        moveUp.timingMode = SKActionTimingEaseOut;
        SKAction *moveDown = [SKAction moveByX:0.0 y:-25.0 duration:0.5];
        moveDown.timingMode = SKActionTimingEaseIn;
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
        SKAction *upDown = [SKAction sequence:@[pause,moveUp,moveDown,fadeOut]];
        [self.dog runAction:upDown completion:^{
            [self.dog removeFromParent];
            [self hatchDucks];
            
            
        }];
        SKAction *bark = [SKAction playSoundFileNamed:@"bark.mp3" waitForCompletion:YES];
        SKAction *barking = [SKAction sequence:@[bark,bark,bark]];
        [self.dog runAction:barking];
    }];
}

-(void)updateWaveTimerLabel
{
    self.waveCountdown--;
    self.countdown.text = [NSString stringWithFormat:@"%i",self.waveCountdown];
    if (self.waveCountdown<1) {
        for (DuckHuntDuck *duck in [self.ducks children]) {
            [duck.timer invalidate];
            [duck flyAway];
        }
        [self.waveTimer invalidate];
        [self.game.currentLevel waveTimedOut];
        [self.dogBehindBushes showNoDucks];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
        SKAction *pause = [SKAction waitForDuration:0.5];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
        SKAction *fadeOutIn = [SKAction sequence:@[fadeOut,pause,fadeIn]];
        [self.sky runAction:fadeOutIn completion:^{
            self.waveCountdown = DUCKWAVETIME;
            [self updateBulletCount];
            if (self.game.currentLevel.waves>0) {
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hatchDucks) userInfo:nil repeats:NO];
            }else if ([self.game.currentLevel levelFinished]){
                if ([self.game nextLevel]) {
                    //[self nextLevel];
                    [self updateDuckCount];
                    SKAction *end = [SKAction playSoundFileNamed:@"end.mp3" waitForCompletion:NO];
                    [self runAction:end];
                    self.level.text = [NSString stringWithFormat:@"Level: %i",self.game.level];
                    [self updateBulletCount];
                    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"dogSniff"];
                    SKTexture *f1 = [atlas textureNamed:@"dogSniff1.png"];
                    self.dog.textureSprite.texture =f1;
                    self.dog.position = CGPointMake(self.dog.frame.size.width * -0.75f, self.dog.frame.size.height * 0.5f + 70.0f);
                    [self addChild:self.dog];
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dogOpenningAnimation) userInfo:nil repeats:NO];
                    
                }else{
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(triggerGameOver) userInfo:nil repeats:NO];
                }
               
                
            }
        }];
    }
}

-(void)nextLevel
{
    SKLabelNode *text = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
    text.text = [NSString stringWithFormat:@"Level %i",self.game.level];
    text.fontColor = [SKColor lightTextColor];
    text.fontSize = 50;
    text.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height *0.5);
    [self addChild:text];
    SKAction *moveup = [SKAction moveByX:0 y:100.0 duration:0.5];
    SKAction *zoom = [SKAction scaleTo:1.5 duration:0.25];
    SKAction *pause = [SKAction waitForDuration:0.5];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveSequence = [SKAction sequence:@[moveup,zoom,pause,fadeAway,remove]];
    [text runAction:moveSequence completion:^{
        [text removeFromParent];
    }];
}

-(void)hatchDucks
{
    
    for (int i=0; i<self.game.currentLevel.ducksToKill; i++) {
        DuckHuntDuck *duck = [DuckHuntDuck node];
        
        [duck runAction:[SKAction moveTo:duck.position duration:0.0]];
        duck.duckSpeed = self.game.currentLevel.duckSpeed;
        if (self.view.frame.size.width>500.0f) {
            duck.duckSpeed = self.game.currentLevel.duckSpeed * 2.0f;
        }
        
        [self.ducks addChild:duck];
        duck.position = CGPointMake((self.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.frame.size.width*0.1), 1.0f);
        [duck fly];

    }
    self.waveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateWaveTimerLabel) userInfo:nil repeats:YES];
}

-(void)updateBulletCount
{
    [self.bullets removeAllChildren];
    for (int i=0; i<self.game.currentLevel.numBullets; i++) {
        SKSpriteNode *bullet = [[SKSpriteNode alloc] initWithImageNamed:@"bullet.png"];
        bullet.position = CGPointMake(bullet.frame.size.width*0.5+(bullet.frame.size.width+2.0)*i, bullet.frame.size.height*0.5f+5.0);
        [self.bullets addChild:bullet];
    }
}

-(void)updateDuckCount
{
    for (int i = 0; i<self.game.currentLevel.deadDucks; i++) {
        SKSpriteNode *duck = [[SKSpriteNode alloc]initWithImageNamed:@"duckDead.png"];
        duck.position = CGPointMake(self.frame.size.width - (duck.frame.size.width *0.5+(duck.frame.size.width + 2.0)*i), duck.frame.size.height*0.5+5.0);
        [self.duckCount addChild:duck];
    }
    for (int i = self.game.currentLevel.deadDucks; i<(self.game.currentLevel.deadDucks+self.game.currentLevel.liveDucks); i++) {
        SKSpriteNode *duck = [[SKSpriteNode alloc]initWithImageNamed:@"duckLive.png"];
        duck.position = CGPointMake(self.frame.size.width - (duck.frame.size.width *0.5+(duck.frame.size.width + 2.0)*i), duck.frame.size.height*0.5+5.0);
        [self.duckCount addChild:duck];
    }
}

-(void) didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask != contact.bodyB.categoryBitMask) {
        SKNode *attacker = nil;
        SKNode *attackee = nil;
        if (contact.bodyA.categoryBitMask>contact.bodyB.categoryBitMask) {
            attacker = contact.bodyA.node;
            attackee = contact.bodyB.node;
        }else{
            attacker = contact.bodyB.node;
            attackee = contact.bodyA.node;
        }
        if ([attackee isKindOfClass:[DuckHuntDuck class]]) {
            [(DuckHuntDuck*)attackee duckKilled];
        }else if([attacker isKindOfClass:[DuckHuntDuck class]])
        {
            [(DuckHuntDuck*)attacker duckKilled];
        }
        [self.game.currentLevel duckKilled];
        [self.game duckShot];
        [self updateDuckCount];
        self.score.text = [NSString stringWithFormat:@"Score: %i",self.game.score];
        
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        DuckHuntBullet *bullet = [[DuckHuntBullet alloc]init];
        bullet.position = location;
        if (bullet && (self.game.currentLevel.numBullets > 0) && self.waveCountdown>0) {
            [self.shots addChild:bullet];
            SKAction *shot = [SKAction playSoundFileNamed:@"shot.wav" waitForCompletion:NO];
            [self runAction:shot];
        }
        [self.game.currentLevel shotFired];
        [self updateBulletCount];


    }
}

-(void)triggerGameOver
{
    SKTransition *transistion = [SKTransition fadeWithDuration:1.0];
    SKScene *gameOver = [[DuckHuntGameOverScene alloc]initWithSize:self.frame.size];
    [self.view presentScene:gameOver transition:transistion];
}

-(void)update:(CFTimeInterval)currentTime {
    NSMutableArray *ducksToRemove = [NSMutableArray array];
    for (DuckHuntDuck *duck in [self.ducks children]) {
        if(duck.position.y<0.0){
            [ducksToRemove addObject:duck];
        }
    }
    if ([ducksToRemove count]) {
        SKAction *drop = [SKAction playSoundFileNamed:@"drop.mp3" waitForCompletion:NO];
        [self runAction:drop];
        [self.ducks removeChildrenInArray:ducksToRemove];
        [self.dogBehindBushes showOffDuck];
        if ([self.game.currentLevel waveOver]) {
            [self.waveTimer invalidate];
            self.waveCountdown = DUCKWAVETIME;
            self.countdown.text = [NSString stringWithFormat:@"%i",self.waveCountdown];
            [self updateBulletCount];
            if (self.game.currentLevel.waves>0) {
                [self updateDuckCount];
                [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hatchDucks) userInfo:nil repeats:NO];
            }
            else if ([self.game.currentLevel levelFinished]){
                if ([self.game nextLevel]) {
                    //[self nextLevel];
                    [self updateDuckCount];
                    SKAction *end = [SKAction playSoundFileNamed:@"end.mp3" waitForCompletion:NO];
                    [self runAction:end];
                    self.level.text = [NSString stringWithFormat:@"Level: %i",self.game.level];
                    [self updateBulletCount];
                    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"dogSniff"];
                    SKTexture *f1 = [atlas textureNamed:@"dogSniff1.png"];
                    self.dog.textureSprite.texture =f1;
                    self.dog.position = CGPointMake(self.dog.frame.size.width * -0.75f, self.dog.frame.size.height * 0.5f + 70.0f);
                    [self addChild:self.dog];
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dogOpenningAnimation) userInfo:nil repeats:NO];
                }else{
                    [self updateDuckCount];
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(triggerGameOver) userInfo:nil repeats:NO];
                }
                
            }
            
        }

    }
    for (DuckHuntDuck *duck in [self.ducks children]) {
        if(duck.position.y>CGRectGetMaxY(self.view.frame)){
            [ducksToRemove addObject:duck];
        }
    }
    if ([ducksToRemove count]) {
        [self.ducks removeChildrenInArray:ducksToRemove];
    }
    
}

@end
