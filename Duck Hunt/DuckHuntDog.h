//
//  DuckHuntDog.h
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DuckHuntDog : SKNode
@property (nonatomic, strong) SKSpriteNode *textureSprite;
-(void)showOffDuck;
-(void)showNoDucks;

@end
