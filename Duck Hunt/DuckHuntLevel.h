//
//  DuckHuntLevel.h
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuckHuntLevel : NSObject

@property (nonatomic, readonly)int numBullets;
@property (nonatomic, readonly)int ducksToKill;
@property (nonatomic, readonly)CGFloat duckSpeed;
@property (nonatomic, readonly)int waves;
@property (nonatomic, readonly)int deadDucks;
@property (nonatomic, readonly)int liveDucks;

-(instancetype)initWithBullets:(int)bullets ducks:(int)ducks duckSpeed:(CGFloat)speed;
-(void)duckKilled;
-(void)shotFired;
-(BOOL)levelFinished;
-(BOOL)waveOver;
-(void)waveTimedOut;

@end
