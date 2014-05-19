//
//  Monster.h
//  Tower Defense
//
//  Created by Conrado MB on 4/5/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "PlayScene.h"

@interface Monster : CCSprite

@property(atomic, readwrite) int HP;
@property(atomic, readwrite) int max_HP;
@property(atomic, readwrite) int level;
@property(atomic, readwrite) int tilePosition;
@property(atomic, readwrite) BOOL flies;
@property(atomic, readwrite) id game;
@property(atomic, readwrite) int gold;
@property(atomic, readwrite) CCTiledMapObjectGroup * roadGroup;
@property(atomic, readwrite) CCSprite * lifeBar;

+ (id) initMonsterWithLevel: (int) level andFlies: (BOOL) flies inGame: (id) game;
- (void) move;
- (void) spawn;
- (BOOL) harm: (int) damage;

@end
