//
//  Monster.m
//  Tower Defense
//
//  Created by Conrado MB on 4/5/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import "Monster.h"

@implementation Monster

- (id) initMonsterWithLevel: (int) level andFlies: (BOOL) flies
{
    Monster * monster = [super spriteWithImageNamed:@"enemy_land_1"];
    monster.flies = flies;
    return monster;
}

@end
