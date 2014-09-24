//
//  DuckHuntDuck.m
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntDuck.h"
#import "BIDGeometry.h"
#import "BIDPhysicsCategories.h"

#define ARC4RANDOM_MAX 0x100000000

@interface DuckHuntDuck()

@property (nonatomic, readwrite) BOOL otherDuck;
@property (nonatomic, strong) SKTextureAtlas *atlas;

@end

@implementation DuckHuntDuck

-(instancetype)init{
    if(self =[super init])
    {
        self.name = [NSString stringWithFormat:@"Duck %p", self];
        int rand = arc4random()%4;
        if (rand == 1) {
            self.otherDuck = YES;
            self.atlas = [SKTextureAtlas atlasNamed:@"otherDuck"];
            self.duckSpeed = 2.0;
        }else{
            self.otherDuck = NO;
            self.atlas = [SKTextureAtlas atlasNamed:@"duck"];
            self.duckSpeed = 2.0;
        }
        [self initNodeGraph];
        [self initPhysicsBody];
        self.timer = [[NSTimer alloc]init];
    }
    return self;
}

-(void) initNodeGraph{
    
    SKTexture *f1 = [self.atlas textureNamed:@"duckUpRight1.png"];
    SKSpriteNode *duck = [SKSpriteNode spriteNodeWithTexture:f1];
    self.textureSprite = duck;
    
    [self addChild:self.textureSprite];
    //self.position = CGPointMake((self.scene.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.self.scene.frame.size.width*0.1), 1.0f);
    
    //NSLog(@"%f",duck.position.x);
}

-(void)initPhysicsBody
{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50.0, 50.0)];
    body.affectedByGravity = NO;
    body.allowsRotation = NO;
    body.categoryBitMask = EnemyCategory;
    body.contactTestBitMask = PlayerMissileCategory;
    body.collisionBitMask = PlayerMissileCategory;
    
    self.physicsBody = body;
    
}

-(void)startPosition
{
    self.position = CGPointMake((self.scene.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.self.scene.frame.size.width*0.1), 1.0f);
    NSLog(@"%f",self.position.x);
}

-(void)fly
{
    //self.position = CGPointMake((self.scene.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.self.scene.frame.size.width*0.1), 1.0f);
    if (!self.physicsBody.affectedByGravity){
        CGFloat x = (self.scene.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.scene.frame.size.width*0.1);
        CGFloat y = (self.scene.frame.size.height *0.7*arc4random() / ARC4RANDOM_MAX)+(self.scene.frame.size.height *0.3);
        [self moveToward:CGPointMake(x, y)];
    }
}

-(void)moveToward:(CGPoint)location
{
    [self removeActionForKey:@"movement"];
    [self removeActionForKey:@"animation"];
    
    CGFloat distance = BIDPointDistance(self.position, location);
    CGFloat pixels = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = self.duckSpeed*distance/pixels;
    
    [self runAction:[SKAction moveTo:location duration:duration] withKey:@"movement"];
    
    if (arc4random()%2) {
        SKAction *quack = [SKAction playSoundFileNamed:@"duck.mp3" waitForCompletion:NO];
        [self runAction:quack];
    }
    
    
    CGFloat slope = BIDSlope(self.position, location);
    if (slope<0) {
        slope*=-1;
    }
    
    if (slope>4.0f/3.0f) {
        if(location.x<self.position.x){
            SKTexture *f1 = [self.atlas textureNamed:@"duckUpLeft1.png"];
            SKTexture *f2 = [self.atlas textureNamed:@"duckUpLeft2.png"];
            SKTexture *f3 = [self.atlas textureNamed:@"duckUpLeft3.png"];
            NSArray *upLeft = @[f1,f2,f3];
            SKAction *flyUpLeft = [SKAction animateWithTextures:upLeft timePerFrame:duration/6.0];
            SKAction *flyUpLeftRepeat = [SKAction repeatActionForever:flyUpLeft];
            [self.textureSprite runAction:flyUpLeftRepeat withKey:@"animation"];
        }else{
            SKTexture *f1 = [self.atlas textureNamed:@"duckUpRight1.png"];
            SKTexture *f2 = [self.atlas textureNamed:@"duckUpRight2.png"];
            SKTexture *f3 = [self.atlas textureNamed:@"duckUpRight3.png"];
            NSArray *upRight = @[f1,f2,f3];
            SKAction *flyUpRight = [SKAction animateWithTextures:upRight timePerFrame:duration/6.0];
            SKAction *flyUpRightRepeat = [SKAction repeatActionForever:flyUpRight];
            [self.textureSprite runAction:flyUpRightRepeat withKey:@"animation"];
        }
    }else{
        if(location.x<self.position.x){
            SKTexture *f1 = [self.atlas textureNamed:@"duckAcrossLeft1.png"];
            SKTexture *f2 = [self.atlas textureNamed:@"duckAcrossLeft2.png"];
            SKTexture *f3 = [self.atlas textureNamed:@"duckAcrossLeft3.png"];
            NSArray *acrossLeft = @[f1,f2,f3];
            SKAction *flyAcrossLeft = [SKAction animateWithTextures:acrossLeft timePerFrame:duration/6.0];
            SKAction *flyAcrossLeftRepeat = [SKAction repeatActionForever:flyAcrossLeft];
            [self.textureSprite runAction:flyAcrossLeftRepeat withKey:@"animation"];
        }else{
            SKTexture *f1 = [self.atlas textureNamed:@"duckAcrossRight1.png"];
            SKTexture *f2 = [self.atlas textureNamed:@"duckAcrossRight2.png"];
            SKTexture *f3 = [self.atlas textureNamed:@"duckAcrossRight3.png"];
            NSArray *acrossRight = @[f1,f2,f3];
            SKAction *flyAcrossRight = [SKAction animateWithTextures:acrossRight timePerFrame:duration/6.0];
            SKAction *flyAcrossRightRepeat = [SKAction repeatActionForever:flyAcrossRight];
            [self.textureSprite runAction:flyAcrossRightRepeat withKey:@"animation"];
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(fly) userInfo:nil repeats:NO];
}

-(void)duckKilled
{
    [self.timer invalidate];
    [self removeActionForKey:@"movement"];
    [self.textureSprite removeActionForKey:@"animation"];
    self.textureSprite.texture = [self.atlas textureNamed:@"duckShot.png"];
    SKAction *pause = [SKAction waitForDuration:0.25];
    [self runAction:pause completion:^{
        self.physicsBody.affectedByGravity = YES;
        SKTexture *f1 = [self.atlas textureNamed:@"duckDown1.png"];
        SKTexture *f2 = [self.atlas textureNamed:@"duckDown2.png"];
        NSArray *down = @[f1,f2];
        SKAction *shotDown = [SKAction animateWithTextures:down timePerFrame:0.2];
        SKAction *shotDownRepeat = [SKAction repeatActionForever:shotDown];
        [self.textureSprite runAction:shotDownRepeat];

    }];
    
}

-(void)flyAway
{
    [self moveToward:CGPointMake(CGRectGetMidX(self.scene.view.frame), CGRectGetMaxY(self.scene.view.frame)+30.0)];
}

@end
