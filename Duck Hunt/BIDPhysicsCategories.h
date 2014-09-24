//
//  BIDPhysicsCategories.h
//  TextShooter
//
//  Created by iMac on 5/16/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#ifndef TextShooter_BIDPhysicsCategories_h
#define TextShooter_BIDPhysicsCategories_h

typedef NS_OPTIONS(uint32_t, BIDPhysicsCategory) {
    PlayerCategory        =  1 << 1,
    EnemyMissileCategory  =  1 << 2,
    EnemyCategory         =  1 << 3,
    PlayerMissileCategory =  1 << 4
};

#endif
