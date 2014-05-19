//
//  Fire.h
//  Tower Defense
//
//  Created by Conrado MB on 5/11/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Fire : CCSprite

@property(atomic, readwrite) int damage;
@property(atomic, readwrite) CCColor * color;

+ (id) initFireWithDamage: (int) damage;

@end
