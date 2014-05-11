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
    Fire * fire = [super spriteWithImageNamed:@"fireball.gif"];
    fire.damage = damage;
    fire.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:fire.contentSize.width/2.0f andCenter:fire.anchorPointInPoints];
    fire.physicsBody.collisionGroup = @"towerGroup";
    fire.physicsBody.collisionType  = @"fireCollision";
    return fire;
}

@end
