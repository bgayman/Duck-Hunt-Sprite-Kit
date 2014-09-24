//
//  DuckHuntLevel.m
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DuckHuntLevel.h"

@interface DuckHuntLevel()
@property (nonatomic, readwrite)int numBullets;
@property (nonatomic, readwrite)int startingNumBullets;
@property (nonatomic, readwrite)int startingNumDucksToKill;
@property (nonatomic, readwrite)int ducksToKill;
@property (nonatomic, readwrite)CGFloat duckSpeed;
@property (nonatomic, readwrite)int waves;
@property (nonatomic, readwrite)int deadDucks;
@property (nonatomic, readwrite)int liveDucks;

@end

@implementation DuckHuntLevel

-(instancetype)initWithBullets:(int)bullets ducks:(int)ducks duckSpeed:(CGFloat)speed
{
    DuckHuntLevel *level = [super init];
    if (level) {
        level.numBullets = bullets;
        level.startingNumBullets = bullets;
        level.ducksToKill = ducks;
        self.startingNumDucksToKill = ducks;
        level.duckSpeed = speed;
        level.waves = 3;
        level.liveDucks = level.waves * level.ducksToKill;
        level.deadDucks = 0;
    }
    return level;
}

-(void)duckKilled
{
    self.ducksToKill--;
    self.deadDucks++;
    self.liveDucks--;
}

-(void)shotFired
{
    self.numBullets--;
}

-(BOOL)levelFinished
{
    if (self.waves<1) {
        return YES;
    }
    return NO;
}

-(BOOL)waveOver
{
    if (self.ducksToKill<1) {
        self.waves--;
        self.numBullets = self.startingNumBullets;
        self.ducksToKill = self.startingNumDucksToKill;
        return YES;
    }
    return NO;
}

-(void)waveTimedOut
{
    self.waves--;
    self.numBullets = self.startingNumBullets;
    self.ducksToKill = self.startingNumDucksToKill;

}


@end
