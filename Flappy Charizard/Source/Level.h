//
//  Level.h
//  FlappyCharizard
//
//  Created by Conrado MB on 5/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//
#import "CCNode.h"
#import "Obstacle.h"

@interface Level : CCNode<CCPhysicsCollisionDelegate>

- (void) initialize: (int) diff;
@end
