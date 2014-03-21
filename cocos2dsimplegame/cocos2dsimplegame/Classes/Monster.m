//
//  Monster.m
//  cocos2dsimplegame
//
//  Created by Conrado MB on 3/20/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "Monster.h"

@implementation Monster

+(id)initMonster {
    Monster * monster = [super spriteWithImageNamed:@"monster.png"];
    monster.lifePoints = (int) (((double)arc4random() / 0x100000000) * 3) +1;
    return monster;
}

-(int)harm {
    return self.lifePoints--;
}

@end
