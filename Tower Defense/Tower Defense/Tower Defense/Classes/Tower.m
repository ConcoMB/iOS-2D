//
//  Tower.m
//  Tower Defense
//
//  Created by Conrado MB on 4/5/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import "Tower.h"

@implementation Tower

+ (id) initTower:(NSString*)name
{
    if ([name isEqualToString: @"land_1.png"]) {
        return [Tower initTowerWithName: name level: 1 hitsLand:YES hitsAir:NO];
    } else if ([name isEqualToString: @"land_2.png"]) {
        return [Tower initTowerWithName: name level: 2 hitsLand:YES hitsAir:NO];
    } else if ([name isEqualToString: @"land_3.png"]) {
        return [Tower initTowerWithName: name level: 3 hitsLand:YES hitsAir:NO];
    } else if ([name isEqualToString: @"land_4.png"]) {
        return [Tower initTowerWithName: name level: 4 hitsLand:YES hitsAir:NO];
    } else if ([name isEqualToString: @"air_1.png"]) {
        return [Tower initTowerWithName: name level: 1 hitsLand:NO hitsAir:YES];
    } else if ([name isEqualToString: @"air_2.png"]) {
        return [Tower initTowerWithName: name level: 2 hitsLand:NO hitsAir:YES];
    } else if ([name isEqualToString: @"air_3.png"]) {
        return [Tower initTowerWithName: name level: 3 hitsLand:NO hitsAir:YES];
    } else if ([name isEqualToString: @"land_and_air_1.png"]) {
        return [Tower initTowerWithName: name level: 1 hitsLand:YES hitsAir:YES];
    } else if ([name isEqualToString: @"land_and_air_2.png"]) {
        return [Tower initTowerWithName: name level: 2 hitsLand:YES hitsAir:YES];
    } else if ([name isEqualToString: @"land_and_air_3.png"]) {
        return [Tower initTowerWithName: name level: 3 hitsLand:YES hitsAir:YES];
    }
    return NULL;
}

+ (id)initTowerWithName: (NSString*) name level:(int)level hitsLand:(BOOL)land hitsAir:(BOOL)air
{
    Tower * tower = [super spriteWithImageNamed:name];
    tower.hitsAir = air;
    tower.hitsLand = land;
    tower.level = level;
    tower.damage = level;
    
    [tower setAnchorPoint:CGPointMake(0, 0)];
    if (tower.hitsLand && !tower.hitsAir) {
        if (tower.level == 1) {
            tower.price = 10;
        } else if (tower.level == 2) {
            tower.price = 25;
        } else if (tower.level == 3) {
            tower.price = 55;
        } else if (tower.level == 4) {
            tower.price = 120;
        }
    } else if (!tower.hitsLand && tower.hitsAir) {
        if (tower.level == 1) {
            tower.price = 15;
        } else if (tower.level == 2) {
            tower.price = 40;
        } else if (tower.level == 3) {
            tower.price = 90;
        }
    } else {
        if (tower.level == 1) {
            tower.price = 30;
        } else if (tower.level == 2) {
            tower.price = 70;
        } else if (tower.level == 3) {
            tower.price = 150;
        }
    }
    return tower;
}

- (BOOL) canHitMonster: (Monster *) monster
{
    if (_hitsLand && !monster.flies) {
        return YES;
    }
    if (_hitsAir && monster.flies) {
        return YES;
    }
    return NO;
}

@end
