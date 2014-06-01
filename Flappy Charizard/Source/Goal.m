//
//  Goal.m
//  FlappyCharizard
//
//  Created by Conrado MB on 5/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Goal.h"

@implementation Goal

-(void)didLoadFromCCB {
    self.physicsBody.collisionType = @"goal";
    self.physicsBody.sensor = TRUE;
}

@end
