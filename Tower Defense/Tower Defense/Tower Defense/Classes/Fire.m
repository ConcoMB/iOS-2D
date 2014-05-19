//
//  Fire.m
//  Tower Defense
//
//  Created by Conrado MB on 5/11/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import "Fire.h"

@implementation Fire

+ (id) initFireWithDamage: (int) damage {
    Fire * fire;
    if (damage == 1) {
        fire = [super spriteWithImageNamed:@"pokeball.png"];
    } else if (damage == 2) {
        fire = [super spriteWithImageNamed:@"greatball.png"];
    } else if (damage == 3) {
        fire = [super spriteWithImageNamed:@"ultraball.png"];
    }
    fire.damage = damage;
    fire.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:fire.contentSize.width/2.0f andCenter:fire.anchorPointInPoints];
    fire.physicsBody.collisionGroup = @"towerGroup";
    fire.physicsBody.collisionType  = @"fireCollision";
    CCActionRotateBy *actionRotate = [CCActionRotateBy actionWithDuration: 0.5f angle:360];
    [fire runAction:[CCActionRepeatForever actionWithAction:actionRotate]];
    return fire;
}

@end
