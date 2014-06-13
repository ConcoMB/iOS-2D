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
    CCNode *_mountainTop;
    CCNode *_mountainBot;
}

#define ARC4RANDOM_MAX      0x100000000
static const CGFloat minimumYPositionTopPipe = 128.f;
static const CGFloat maximumYPositionBottomPipe = 440.f;
static const CGFloat pipeDistance = 142.f;
static const CGFloat maximumYPositionTopPipe = maximumYPositionBottomPipe - pipeDistance;
static const CGFloat correction = -150.f;

- (void)didLoadFromCCB {
    _topPart.physicsBody.collisionType = @"level";
    _topPart.physicsBody.sensor = TRUE;
    _botPart.physicsBody.collisionType = @"level";
    _botPart.physicsBody.sensor = TRUE;
    _mountainTop.physicsBody.collisionType = @"level";
    _mountainTop.physicsBody.sensor = TRUE;
    _mountainBot.physicsBody.collisionType = @"level";
    _mountainBot.physicsBody.sensor = TRUE;
}

- (void)setupRandomPosition {
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat range = maximumYPositionTopPipe - minimumYPositionTopPipe;
    _topPart.position = ccp(_topPart.position.x, minimumYPositionTopPipe + (random * range));
    _botPart.position = ccp(_botPart.position.x, _topPart.position.y + pipeDistance);
    
    _mountainBot.position = ccp(_mountainBot.position.x, minimumYPositionTopPipe + (random * range)  + correction);
    _mountainTop.position = ccp(_mountainTop.position.x, _mountainTop.position.y + pipeDistance + correction);
}

- (void) setLevel:(int)level {
    double r = ((double)arc4random() / ARC4RANDOM_MAX);
    if (level == 1) {
        [self removeChild:_mountainBot];
        [self removeChild:_mountainTop];
        if(r < 0.5) {
            [self removeChild:_botPart];
        } else {
            [self removeChild:_topPart];
        }
    } else if (level == 2) {
        [self removeChild:_mountainBot];
        [self removeChild:_mountainTop];
        if (r < 0.25) {
            [self removeChild:_botPart];
        } else if (r < 0.5) {
            [self removeChild:_topPart];
        }
    } else if (level == 3){
        if (r < 0.25) {
            [self removeChild:_mountainBot];
            [self removeChild:_mountainTop];
        } else if (r < 0.5) {
            [self removeChild:_botPart];
            [self removeChild:_mountainTop];
        } else if (r < 0.75) {
            [self removeChild:_mountainBot];
            [self removeChild:_topPart];
        } else {
            [self removeChild:_topPart];
            [self removeChild:_botPart];
        }
    } else {
         if (r < 0.75) {
            [self removeChild:_mountainBot];
            [self removeChild:_mountainTop];
        } else {
            [self removeChild:_topPart];
            [self removeChild:_botPart];
        }
    }
}

@end
