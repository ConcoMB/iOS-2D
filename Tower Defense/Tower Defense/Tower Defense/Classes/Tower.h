//
//  Tower.h
//  Tower Defense
//
//  Created by Conrado MB on 4/5/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@interface Tower : CCSprite

@property(atomic, readwrite) int level;
@property(atomic, readwrite) BOOL hitsLand;
@property(atomic, readwrite) BOOL hitsAir;
@property(atomic, readwrite) int price;
@property(atomic, readwrite) int damage;

+ (id)initTower: (NSString*) name;
+ (id)initTowerWithName: (NSString*)name level: (int)level hitsLand:(BOOL)land hitsAir:(BOOL)air;

@end
