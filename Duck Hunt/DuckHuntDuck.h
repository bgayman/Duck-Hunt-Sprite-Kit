//
//  DuckHuntDuck.h
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DuckHuntDuck : SKNode
@property (nonatomic, strong) SKSpriteNode *textureSprite;
@property (nonatomic, readonly) BOOL otherDuck;
@property (nonatomic, readwrite) float duckSpeed;
@property (nonatomic, strong) NSTimer *timer;

-(void) fly;
-(void) duckKilled;
-(void) flyAway;
-(void)startPosition;

@end
