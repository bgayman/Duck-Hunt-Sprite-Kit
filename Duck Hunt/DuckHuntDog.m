//
//  DuckHuntDog.m
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntDog.h"

@implementation DuckHuntDog

-(instancetype)init{
    if (self = [super init])
    {
        self.name = [NSString stringWithFormat:@"Dog %p",self];
        [self initNodeGraph];
    }
    return self;
}

-(void)initNodeGraph{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"dogSniff"];
    SKTexture *f1 = [atlas textureNamed:@"dogSniff1.png"];
    /*SKTexture *f2 = [atlas textureNamed:@"dogSniff2.png"];
    SKTexture *f3 = [atlas textureNamed:@"dogSniff3.png"];
    SKTexture *f4 = [atlas textureNamed:@"dogSniff4.png"];
    SKTexture *f5 = [atlas textureNamed:@"dogSniff5.png"];
    NSArray *dogSniffTextures = @[f1,f2,f3,f4,f5];*/
    
    SKSpriteNode *dog = [SKSpriteNode spriteNodeWithTexture:f1];
    self.textureSprite = dog;
    //dog.position = CGPointMake(dog.frame.size.width*-0.5f, dog.frame.size.height *0.5f);
    [self addChild:self.textureSprite];
}

-(void)showOffDuck
{
    [self removeActionForKey:@"movement"];
    self.position = CGPointMake(CGRectGetMidX(self.scene.view.frame)+5.0f, 0.0f);
    self.alpha = 1.0;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"dogDuck"];
    SKTexture *f1 = [atlas textureNamed:@"dogOneDuck.png"];
    self.textureSprite.texture = f1;
    SKAction *moveUp = [SKAction moveToY:80.0f+self.textureSprite.size.height * 0.5f duration:0.50f];
    SKAction *pause = [SKAction waitForDuration:0.50f];
    SKAction *moveDown = [SKAction moveToY:0.0f duration:0.50f];
    SKAction *upDown = [SKAction sequence:@[moveUp,pause,moveDown]];
    [self runAction:upDown withKey:@"movement"];
}

-(void)showNoDucks
{
    [self removeActionForKey:@"movement"];
    self.position = CGPointMake(CGRectGetMidX(self.scene.view.frame)+5.0f, 0.0f);
    self.alpha = 1.0;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"dogDuck"];
    SKTexture *f1 = [atlas textureNamed:@"dogNoDuck.png"];
    self.textureSprite.texture = f1;
    SKAction *moveUp = [SKAction moveToY:80.0f+self.textureSprite.size.height * 0.5f duration:0.50f];
    SKAction *pause = [SKAction waitForDuration:0.50f];
    SKAction *moveDown = [SKAction moveToY:0.0f duration:0.50f];
    SKAction *upDown = [SKAction sequence:@[moveUp,pause,moveDown]];
    [self runAction:upDown withKey:@"movement"];
    SKAction *laugh = [SKAction playSoundFileNamed:@"laugh.mp3" waitForCompletion:NO];
    [self runAction:laugh];
}

@end
