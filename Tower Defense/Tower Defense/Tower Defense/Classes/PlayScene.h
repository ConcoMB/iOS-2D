//
//  PlayScene.h
//  Tower Defense
//
//  Created by Conrado MB on 3/30/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Tower.h"
#import "Monster.h"
#import "Fire.h"
#import "IntroScene.h"

@interface PlayScene : CCScene <CCPhysicsCollisionDelegate, UIAlertViewDelegate>

@property(atomic, readwrite) CCLabelTTF * levelLabel;
@property(atomic, readwrite) CCLabelTTF * goldLabel;
@property(atomic, readwrite) CCLabelTTF * priceLabel;
@property(atomic, readwrite) CCPhysicsNode * physicsWorld;
@property(atomic, readwrite) int gold;
@property(atomic, readwrite) int level;
@property(atomic, readwrite) CCButton * selectedTower;
@property(atomic, readwrite) CCSprite * selectedTowerSprite;
@property(atomic, readwrite) CCTiledMap * tiledMap;
@property(atomic, readwrite) CCTiledMapLayer * background;
@property(atomic, readwrite) CCTiledMapObjectGroup * roadGroup;
@property(atomic, readwrite) CCTiledMapObjectGroup * objectGroup;
@property(atomic, readwrite) NSMutableArray * towers;
@property(atomic, readwrite) NSMutableArray * monsters;
@property(atomic, readwrite) NSMutableSet * occupiedTiles;
@property(atomic, readwrite) CGSize tileSize;
@property(atomic, readwrite) BOOL isEditMode;
@property(atomic, readwrite) CCButton * attackButton;
@property(atomic, readwrite) int selectedTowerPrice;
@property(atomic, readwrite) int spawnPoint_x;
@property(atomic, readwrite) int spawnPoint_y;
@property(atomic, readwrite) float fireTiming;
@property(atomic, readwrite) BOOL isTrash;
@property(atomic, readwrite) NSMutableDictionary * towerMap;


+ (PlayScene *)scene;
- (id)init;
- (void) setUpTowerWithSprite: sprite andObject: object;
- (void) setUpTowerButtons;
- (void) monsterArrivedToEnd;

@end
