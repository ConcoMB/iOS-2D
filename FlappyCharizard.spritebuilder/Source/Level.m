//
//  Level.m
//  FlappyCharizard
//
//  Created by Conrado MB on 5/31/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"

static const CGFloat firstObstaclePosition = 280.f;
static const int POINTS_FOR_LEVEL_UP = 5;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderPipes,
    DrawingOrderGround,
    DrawingOrderCharizard,
    DrawingOrderPoints
};

@implementation Level {
    CCSprite *_charizard;
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    NSArray *_grounds;
    NSMutableArray *_obstacles;
    NSTimeInterval _sinceTouch;
    CCButton *_restartButton;
    BOOL _gameOver;
    CGFloat _scrollSpeed;
    NSInteger _points;
    CCLabelTTF *_scoreLabel;
    CGFloat _distanceBetweenObstacles;
    int _level;
    CCLabelTTF * _levelUp;
    CCLabelTTF * _levelN;
}

- (void)didLoadFromCCB {
//    [[OALSimpleAudio sharedInstance] stopBg];
    [[OALSimpleAudio sharedInstance] playBg:@"battle.mp3" loop:YES];
}

- (void)initialize: (int) diff {
    self.userInteractionEnabled = TRUE;
    _level = diff;
    [self setUpLevel];
    _grounds = @[_ground1, _ground2];
    for (CCNode *ground in _grounds) {
        ground.physicsBody.collisionType = @"level";
        ground.zOrder = DrawingOrderGround;
    }
    _scoreLabel.zOrder = DrawingOrderPoints;
    _physicsNode.collisionDelegate = self;
    _charizard.physicsBody.collisionType = @"charizard";
    _charizard.zOrder = DrawingOrderCharizard;
    _obstacles = [NSMutableArray array];
    _levelN.string = [NSString stringWithFormat:@"Level %d", _level];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
}

- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleXPosition = previousObstacle.position.x;
    if (!previousObstacle) {
        // this is the first obstacle
        previousObstacleXPosition = firstObstaclePosition;
    }
    Obstacle *obstacle = (Obstacle *)[CCBReader load:@"Pilar"];
    [obstacle setLevel: _level];
    obstacle.position = ccp(previousObstacleXPosition + _distanceBetweenObstacles, 0);
    [obstacle setupRandomPosition];
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
}

- (void)update:(CCTime)delta {
    //move floors
    if (!_gameOver) {
        _charizard.position = ccp(_charizard.position.x + delta * _scrollSpeed * 0.975, _charizard.position.y);
        _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
    }
    for (CCNode *ground in _grounds) {
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }
    
    //rotate charizard
    float yVelocity = clampf(_charizard.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _charizard.physicsBody.velocity = ccp(0, yVelocity);
    
    _sinceTouch += delta;
    _charizard.rotation = clampf(_charizard.rotation, -30.f, 90.f);
    if (_charizard.physicsBody.allowsRotation) {
        float angularVelocity = clampf(_charizard.physicsBody.angularVelocity, -2.f, 1.f);
        _charizard.physicsBody.angularVelocity = angularVelocity *0.8;
    }
    if ((_sinceTouch > 1.0f)) {
        [_charizard.physicsBody applyAngularImpulse:-10000.f*delta];
    }
    
    //generate objstacles
    NSMutableArray *offScreenObstacles = nil;
    for (CCNode *obstacle in _obstacles) {
        CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
        CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
        if (obstacleScreenPosition.x < -obstacle.contentSize.width * 4) {
            if (!offScreenObstacles) {
                offScreenObstacles = [NSMutableArray array];
            }
            [offScreenObstacles addObject:obstacle];
        }
    }
    for (CCNode *obstacleToRemove in offScreenObstacles) {
        [obstacleToRemove removeFromParent];
        [_obstacles removeObject:obstacleToRemove];
        // for each removed obstacle, add a new one
        [self spawnNewObstacle];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!_gameOver) {
        [_charizard.physicsBody applyImpulse:ccp(0, 400.f)];
        [_charizard.physicsBody applyAngularImpulse:10000.f];
        _sinceTouch = 0.f;
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair charizard:(CCNode *)charizard level:(CCNode *)level {
    [self gameOver];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair charizard:(CCNode *)charizard goal:(CCNode *)goal {
    [goal removeFromParent];
    _points++;
    if (_points % POINTS_FOR_LEVEL_UP == 0) {
        [self levelUp];
    }
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _points];
    return TRUE;
}

- (void) levelUp {
    _level++;
    CCAction * fade = [CCActionFadeTo actionWithDuration:1 opacity:1];
    [_levelUp runAction:fade];

    [self performSelector:@selector(dimLevelUp) withObject:nil afterDelay:2];
    [self setUpLevel];
    _levelN.string = [NSString stringWithFormat:@"Level %d", _level];
}

- (void) dimLevelUp {
    CCAction * fade = [CCActionFadeTo actionWithDuration:1 opacity:0];
    [_levelUp runAction:fade];
}

- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void) setUpLevel {
    _scrollSpeed = 80.0f  + 20.0f * (_level - 1);
    _distanceBetweenObstacles = 350.0f - (20.0f * _level - 1);
}

- (void)gameOver {
    if (!_gameOver) {
        [[OALSimpleAudio sharedInstance] playBg:@"lost.mp3" loop:YES];
        _scrollSpeed = 0.f;
        _gameOver = TRUE;
        _restartButton.visible = TRUE;
        _charizard.rotation = 90.f;
        _charizard.physicsBody.allowsRotation = FALSE;
        [_charizard stopAllActions];
        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(-2, 2)];
        CCActionInterval *reverseMovement = [moveBy reverse];
        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
        [self runAction:bounce];
    }
}

@end

