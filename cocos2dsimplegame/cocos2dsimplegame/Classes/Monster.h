//
//  Monster.h
//  cocos2dsimplegame
//
//  Created by Conrado MB on 3/20/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CCSprite.h"

@interface Monster : CCSprite

@property (atomic, readwrite) int lifePoints;

+ (id)initMonster;

- (int)harm;

@end
