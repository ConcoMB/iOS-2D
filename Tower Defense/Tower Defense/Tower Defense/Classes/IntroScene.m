//
//  IntroScene.m
//  Tower Defense
//
//  Created by Conrado MB on 3/30/14.
//  Copyright Conrado MB 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "PlayScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tower Defense" fontName:@"Zapfino" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Spinning scene button
    CCButton *playButton = [CCButton buttonWithTitle:@"Play" fontName:@"Verdana-Bold" fontSize:18.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.5f, 0.25f);
    [playButton setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playButton];
    
//    // Spinning scene button
//    CCButton *recordsButton = [CCButton buttonWithTitle:@"Records" fontName:@"Verdana-Bold" fontSize:18.0f];
//    recordsButton.positionType = CCPositionTypeNormalized;
//    recordsButton.position = ccp(0.5f, 0.15f);
//    [self addChild:recordsButton];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onPlayClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[PlayScene scene]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionUp duration:0.2f]];
}

// -----------------------------------------------------------------------
@end
