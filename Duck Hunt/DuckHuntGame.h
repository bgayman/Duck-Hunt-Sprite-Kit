//
//  DuckHuntGame.h
//  Duck Hunt
//
//  Created by iMac on 5/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DuckHuntLevel.h"

@interface DuckHuntGame : NSObject
@property (nonatomic, readonly) int level;
@property (nonatomic, readonly) int score;
@property (nonatomic, strong) DuckHuntLevel *currentLevel;

-(BOOL)nextLevel;
-(void)duckShot;

@end
