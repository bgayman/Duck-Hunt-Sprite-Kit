//
//  DuckHuntGame.m
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntGame.h"
@interface DuckHuntGame()
@property (nonatomic, readwrite) int level;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) float scoreToAchieve;

@end

@implementation DuckHuntGame

-(DuckHuntLevel *)setCurrentLevel
{
    if (!_currentLevel) {
        _currentLevel = [[DuckHuntLevel alloc]initWithBullets:4 ducks:2 duckSpeed:2.0];
    }
    return _currentLevel;
}

-(instancetype)init
{
    DuckHuntGame *game = [super init];
    if (game) {
        game.level = 1;
        game.currentLevel = [[DuckHuntLevel alloc]initWithBullets:4 ducks:2 duckSpeed:2.0];
        game.scoreToAchieve = 200.0f * 2.0 * 3.0/4.0;
    }
    return game;
}

-(BOOL)nextLevel
{
    NSLog(@"%f",self.scoreToAchieve);
    if (self.score > self.scoreToAchieve) {
        self.level++;
    
        self.currentLevel = [[DuckHuntLevel alloc] initWithBullets:log(self.level)+4 ducks:2+log(self.level) duckSpeed:0.5-(1/(1.0-self.level))];
        NSLog(@"%f",1.0-(1/(1.0-self.level)));
        
        
        self.scoreToAchieve = self.score + (3.0* 200.0f * (2.0+(int)log(self.level)) * 3.0/4.0);
        return YES;
    }
    return NO;
}

-(void)duckShot
{
    self.score +=200;
}

@end
