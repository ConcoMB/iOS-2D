//
//  Obstacle.m
//  FlappyCharizard
//
//  Created by Conrado MB on 5/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle {
    CCNode *_topPart;
    CCNode *_botPart;
}

#define ARC4RANDOM_MAX      0x100000000
static const CGFloat minimumYPositionTopPipe = 128.f;
static const CGFloat maximumYPositionBottomPipe = 440.f;
static const CGFloat pipeDistance = 142.f;
static const CGFloat maximumYPositionTopPipe = maximumYPositionBottomPipe - pipeDistance;

- (void)didLoadFromCCB {
    _topPart.physicsBody.collisionType = @"level";
    _topPart.physicsBody.sensor = TRUE;
    _botPart.physicsBody.collisionType = @"level";
    _botPart.physicsBody.sensor = TRUE;
}

- (void)setupRandomPosition {
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat range = maximumYPositionTopPipe - minimumYPositionTopPipe;
    _topPart.position = ccp(_topPart.position.x, minimumYPositionTopPipe + (random * range));
    _botPart.position = ccp(_botPart.position.x, _topPart.position.y + pipeDistance);
}
@end
