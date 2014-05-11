//
//  Monster.m
//  Tower Defense
//
//  Created by Conrado MB on 4/5/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import "Monster.h"

@implementation Monster

+ (id) initMonsterWithLevel: (int) level andFlies: (BOOL) flies inGame: (PlayScene *) game
{
    Monster * monster = [super spriteWithImageNamed: [self calculateMonsterSpriteNameBasedOnLevel: level andFlies: flies ]];
    monster.flies = flies;
    monster.HP = level * 5;
    monster.level = level;
    monster.tilePosition = 1;
    monster.gold = level * 10 + arc4random() % level;
    [monster setAnchorPoint:CGPointMake(0, 0)];
    CCTiledMap * tiledMap = [[CCTiledMap alloc]initWithFile:@"tileMap.tmx"];
    monster.roadGroup = [tiledMap objectGroupNamed:@"Road"];
    monster.game = game;
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
    monster.physicsBody.collisionGroup = @"monsterGroup";
    monster.physicsBody.collisionType  = @"monsterCollision";
    return monster;
}

+ (NSString *) calculateMonsterSpriteNameBasedOnLevel: (int) level andFlies: (BOOL) flies
{
    if (flies) {
        if (level == 1) {
            return @"enemy_air_1.png";
        }
        if (level == 2) {
            return @"enemy_air_2.png";
        }
        if (level == 3) {
            return @"enemy_air_3.png";
        }
        if (level == 4) {
            return @"enemy_air_4.png";
        }
    } else {
        if (level == 1) {
            return @"enemy_land_1.png";
        }
        if (level == 2) {
            return @"enemy_land_2.png";
        }
        if (level == 3) {
            return @"enemy_land_3.png";
        }
        if (level == 4) {
            return @"enemy_land_4.png";
        }
    }
    return NULL;
}

- (BOOL) harm: (int) damage {
    _HP -= damage;
    return _HP <= 0;
}

- (void) move
{
    _tilePosition++;
    NSMutableDictionary * tile = [_roadGroup objectNamed: [NSString stringWithFormat:@"%i", _tilePosition]];
    if ([[tile valueForKey:@"end"] isEqualToString: @"true"]) {
        [_game monsterArrivedToEnd];
    }
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.5 position: CGPointMake([[tile valueForKey:@"x"] integerValue], [[tile valueForKey:@"y"] integerValue])];
    CCActionCallFunc * actionMoveAgain = [CCActionCallFunc actionWithTarget:self selector:@selector(move)];
    [self runAction:[CCActionSequence actionWithArray:@[actionMove, actionMoveAgain]]];
}

- (void) spawn {
    [self setPosition: CGPointMake(((PlayScene*)_game).spawnPoint_x, ((PlayScene*)_game).spawnPoint_y)];
    [((PlayScene*)_game).physicsWorld addChild:self];
    NSMutableDictionary * tile = [_roadGroup objectNamed: @"1"];
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:0.5 position: CGPointMake([[tile valueForKey:@"x"] integerValue], [[tile valueForKey:@"y"] integerValue])];
    CCActionCallFunc * actionMoveAgain = [CCActionCallFunc actionWithTarget:self selector:@selector(move)];
    [self runAction:[CCActionSequence actionWithArray:@[actionMove, actionMoveAgain]]];
}

@end
