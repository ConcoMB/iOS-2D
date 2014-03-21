//
//  HelloWorldScene.h
//  Cocos2DSimpleGame
//
//  Created by Martin Walsh on 18/01/2014.
//  Copyright Razeware LLC 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Monster.h"


// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface HelloWorldScene : CCScene <CCPhysicsCollisionDelegate, UIAlertViewDelegate>

// -----------------------------------------------------------------------

@property(atomic, readwrite) int score;
@property(atomic, readwrite) CCLabelTTF * scoreLabel;


+ (HelloWorldScene *)scene;
- (id)init;
- (void)loose;

// -----------------------------------------------------------------------
@end