//
//  DuckHuntStartScene.m
//  Duck Hunt
//
//  Created by iMac on 5/27/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntStartScene.h"
#import "DuckHuntDuck.h"
#import "DuckHuntMyScene.h"

#define ARC4RANDOM_MAX 0x100000000

@interface DuckHuntStartScene()
@property (strong, nonatomic) SKNode *ducks;

@end

@implementation DuckHuntStartScene

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:104.0/255.0 green:178.0/255.0 blue:252.0/255.0 alpha:1.0];
        
        SKNode *ducks = [SKNode node];
        self.ducks = ducks;
        [self addChild:self.ducks];
        
        SKSpriteNode *tree = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"tree"]]];
        tree.position = CGPointMake(tree.frame.size.width *0.5f, tree.frame.size.height*0.5 + 100.0f);
        [self addChild:tree];
        
        SKSpriteNode *bushes = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"back.png"]]];
        bushes.position = CGPointMake(bushes.frame.size.width*0.5f, bushes.frame.size.height * 0.5f);
        [self addChild:bushes];
        
        SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        topLabel.text = @"Duck Hunt";
        topLabel.fontColor = [SKColor lightTextColor];
        topLabel.fontSize = 48;
        topLabel.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height *0.7);
        [self addChild:topLabel];
        
        SKLabelNode *bottomLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
        bottomLabel.text = @"Touch Anywhere to Start";
        bottomLabel.fontColor = [SKColor lightTextColor];
        bottomLabel.fontSize = 20;
        bottomLabel.position = CGPointMake(self.frame.size.width *0.5, self.frame.size.height * 0.3);
        [self addChild:bottomLabel];
        
        [self hatchDucks];

    }
    return self;
}

-(void)flyA
{
    for (DuckHuntDuck *duck  in [self.ducks children]) {
        [duck.timer invalidate];
        [duck flyAway];
    }
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hatchDucks) userInfo:nil repeats:NO];
}

-(void)hatchDucks
{
    
    for (int i=0; i<arc4random()%6+1; i++) {
        DuckHuntDuck *duck = [DuckHuntDuck node];
        //NSLog(@"%f",(self.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.frame.size.width*0.1));
        
        duck.duckSpeed = 1.8;
        if (self.view.frame.size.width>500.0f) {
            duck.duckSpeed = 1.8 * 2.0f;
        }
        //duck.position = CGPointMake((self.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.frame.size.width*0.1), 1.0f);
        //[duck runAction:[SKAction moveTo:CGPointMake((self.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.frame.size.width*0.1), 1.0f) duration:0.0]];
        [self.ducks addChild:duck];
        duck.position = CGPointMake((self.frame.size.width*0.8*arc4random()/ARC4RANDOM_MAX)+(self.frame.size.width*0.1), 1.0f);
        [duck fly];
    }
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(flyA) userInfo:nil repeats:NO];
}

-(void)update:(CFTimeInterval)currentTime {
    NSMutableArray *ducksToRemove = [NSMutableArray array];
    for (DuckHuntDuck *duck in [self.ducks children]) {
        if(duck.position.y<0.0 || duck.position.y>CGRectGetMaxY(self.frame)){
            [ducksToRemove addObject:duck];
        }
    }
    if ([ducksToRemove count]) {
        [self.ducks removeChildrenInArray:ducksToRemove];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    SKScene *game = [[DuckHuntMyScene alloc]initWithSize:self.frame.size];
    [self.view presentScene:game transition:transition];
}

@end
