//
//  DuckHuntGameOverScene.m
//  Duck Hunt
//
//  Created by iMac on 5/27/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntGameOverScene.h"
#import "DuckHuntStartScene.h"

@implementation DuckHuntGameOverScene

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:104.0/255.0 green:178.0/255.0 blue:252.0/255.0 alpha:1.0];
        
        SKSpriteNode *tree = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"tree"]]];
        tree.position = CGPointMake(tree.frame.size.width *0.5f, tree.frame.size.height*0.5 + 100.0f);
        [self addChild:tree];
        
        SKSpriteNode *bushes = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"back.png"]]];
        bushes.position = CGPointMake(bushes.frame.size.width*0.5f, bushes.frame.size.height * 0.5f);
        [self addChild:bushes];
        
        SKLabelNode *text = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        text.text = @"Game Over!";
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
            SKTransition *transition = [SKTransition fadeWithDuration:1.0];
            SKScene *start = [[DuckHuntStartScene alloc]initWithSize:self.frame.size];
            [self.view presentScene:start transition:transition];
        }];
    }
    return self;
}

@end
