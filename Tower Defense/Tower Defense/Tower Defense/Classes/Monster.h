//
//  Monster.h
//  Tower Defense
//
//  Created by Conrado MB on 4/5/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"

@interface Monster : CCSprite

@property(atomic, readwrite) int HP;
@property(atomic, readwrite) BOOL flies;

+ (id) initMonsterWithLevel: (int) level andFlies: (BOOL) flies;

@end
