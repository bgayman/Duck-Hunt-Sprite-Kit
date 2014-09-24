//
//  DuckHuntBullet.m
//  Duck Hunt
//
//  Created by iMac on 5/25/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntBullet.h"
#import "BIDPhysicsCategories.h"

@implementation DuckHuntBullet

-(instancetype) init{
    if (self = [super init]) {
        SKSpriteNode *box = [[SKSpriteNode alloc]initWithColor:[SKColor colorWithWhite:1.0 alpha:0.5] size:CGSizeMake(20.0, 20.0)];
        SKAction *fade = [SKAction fadeOutWithDuration:0.10];
        
        [self addChild:box];
        
        [self runAction:fade completion:^{
            [self removeFromParent];
        }];
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10.0, 10.0)];
        body.categoryBitMask = PlayerMissileCategory;
        body.contactTestBitMask = EnemyCategory;
        body.collisionBitMask = EnemyCategory;
        body.mass = 0.01;
        body.affectedByGravity = NO;
        
        self.physicsBody = body;
        self.name = [NSString stringWithFormat:@"Bullet %p",self];
    }
    return self;
}



@end
